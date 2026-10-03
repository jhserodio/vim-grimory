-- Local client for selfhosted-qwen-codeagent.
-- Neovim >= 0.11, curl. No cloud API and no dependency on CodeCompanion.
local M = { pending = nil }

local function warn(message, level)
  vim.notify("Qwen Agent: " .. message, level or vim.log.levels.WARN)
end

local function settings()
  local url = vim.g.qwen_agent_url or "http://127.0.0.1:8766"
  local workspace = vim.g.qwen_agent_workspace or vim.fn.expand("~/dev/vim-grimory")
  -- This first client intentionally supports only a loopback HTTP endpoint.
  if not url:match("^http://127%.0%.0%.1:%d+$") then
    return nil, "Only http://127.0.0.1:<port> is supported"
  end
  local canonical = vim.uv.fs_realpath(vim.fn.expand(workspace))
  if not canonical then return nil, "Configured workspace does not exist" end
  return { url = url, workspace = canonical }
end

local function current_workspace(config)
  local cwd = vim.uv.fs_realpath(vim.fn.getcwd())
  if cwd ~= config.workspace then
    warn("Open Neovim at the configured server workspace: " .. config.workspace)
    return false
  end
  return true
end

local function token()
  local path = vim.fn.expand("~/.config/qwen-codeagent/token")
  local file = io.open(path, "r")
  if not file then return nil, "Cannot read " .. path end
  local value = file:read("*a")
  file:close()
  value = (value or ""):gsub("%s+$", "")
  if #value < 32 or value:find("[\r\n]") then return nil, "Invalid API token" end
  return value
end

local function request(method, route, payload, done)
  if vim.fn.executable("curl") ~= 1 then return warn("curl is required") end
  local config, config_error = settings()
  if not config then return warn(config_error) end
  if not current_workspace(config) then return end
  local auth, auth_error = token()
  if not auth then return warn(auth_error) end

  -- Keep the bearer token OUT of process arguments (visible through `ps`).
  -- curl reads it from an ephemeral, mode-0600 header file instead.
  local header_path = vim.fn.tempname()
  local fd, open_error = vim.uv.fs_open(header_path, "w", 384) -- 0600
  if not fd then return warn("Cannot prepare private header: " .. tostring(open_error)) end
  local wrote, write_error = vim.uv.fs_write(fd, "Authorization: Bearer " .. auth .. "\n", 0)
  vim.uv.fs_close(fd)
  if not wrote then
    vim.uv.fs_unlink(header_path)
    return warn("Cannot prepare authorization: " .. tostring(write_error))
  end

  local argv = {
    "curl", "-q", "--silent", "--show-error", "--noproxy", "*",
    "--connect-timeout", "3", "--max-time", "240", "--request", method,
    "--header", "@" .. header_path,
    "--header", "Content-Type: application/json",
    "--write-out", "\n%{http_code}",
  }
  if payload then
    -- Send user text through stdin, not process arguments.
    vim.list_extend(argv, { "--data-binary", "@-" })
  end
  table.insert(argv, config.url .. route)
  local input = payload and vim.json.encode(payload) or nil
  vim.system(argv, { text = true, stdin = input }, function(result)
    vim.uv.fs_unlink(header_path)
    vim.schedule(function()
      if result.code ~= 0 then
        return warn((result.stderr or "curl failed"):gsub("%s+$", ""), vim.log.levels.ERROR)
      end
      local data, status = (result.stdout or ""):match("^(.*)\n(%d%d%d)%s*$")
      if not data or not status then return warn("Invalid HTTP response", vim.log.levels.ERROR) end
      local ok, response = pcall(vim.json.decode, data)
      if not ok or type(response) ~= "table" then
        return warn("Invalid JSON response", vim.log.levels.ERROR)
      end
      if tonumber(status) < 200 or tonumber(status) >= 300 then
        return warn("HTTP " .. status .. ": " .. tostring(response.error or "Request failed"), vim.log.levels.ERROR)
      end
      done(response)
    end)
  end)
end

local function show(title, content, filetype)
  local lines = vim.split(content, "\n", { plain = true })
  local width = math.min(100, math.max(20, vim.o.columns - 4))
  local height = math.min(math.max(3, #lines), math.max(3, vim.o.lines - 5))
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = filetype or "markdown"
  vim.bo[buf].modifiable = false
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor", style = "minimal", border = "rounded",
    width = width, height = height,
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    title = title, title_pos = "center",
  })
  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end, { buffer = buf, silent = true, desc = "Close Qwen Agent panel" })
end

function M.health()
  request("GET", "/v1/health", nil, function(response)
    warn("API " .. tostring(response.status) .. " | " .. table.concat(response.capabilities or {}, ", "), vim.log.levels.INFO)
  end)
end

function M.ask()
  vim.ui.input({ prompt = "Ask local Qwen Agent: " }, function(question)
    if not question or question:match("^%s*$") then return end
    request("POST", "/v1/ask", { question = question, context = "auto" }, function(response)
      local body = { response.answer or "(Empty answer)" }
      if type(response.sources) == "table" and #response.sources > 0 then
        table.insert(body, "\n---\nRetrieved context (not verification of every model claim):")
        for _, source in ipairs(response.sources) do
          table.insert(body, string.format("- `%s:%s-%s`", tostring(source.relativePath), tostring(source.startLine), tostring(source.endLine)))
        end
      end
      show("Qwen Agent — ASK", table.concat(body, "\n"), "markdown")
    end)
  end)
end

local function current_file(config)
  if not current_workspace(config) then return nil end
  if vim.bo.modified then
    warn("Save the current buffer before using it as agent context")
    return nil
  end
  local filename = vim.api.nvim_buf_get_name(0)
  local canonical = vim.uv.fs_realpath(filename)
  if not canonical or canonical:sub(1, #config.workspace + 1) ~= config.workspace .. "/" then
    warn("Current file is outside the API workspace")
    return nil
  end
  return canonical:sub(#config.workspace + 2)
end

function M.ask_file()
  local config, error_text = settings()
  if not config then return warn(error_text) end
  local relative = current_file(config)
  if not relative then return end
  vim.ui.input({ prompt = "Ask about " .. relative .. ": " }, function(question)
    if not question or question:match("^%s*$") then return end
    request("POST", "/v1/ask", { question = question, files = { relative }, context = "auto" }, function(response)
      local body = { response.answer or "(Empty answer)" }
      if type(response.sources) == "table" and #response.sources > 0 then
        table.insert(body, "\n---\nAdditional retrieved chunks (not verification of all claims):")
        for _, source in ipairs(response.sources) do
          table.insert(body, string.format("- `%s:%s-%s`", tostring(source.relativePath), tostring(source.startLine), tostring(source.endLine)))
        end
      end
      show("Qwen Agent — ASK " .. relative, table.concat(body, "\n"), "markdown")
    end)
  end)
end

function M.propose()
  local config, error_text = settings()
  if not config then return warn(error_text) end
  local relative = current_file(config)
  if not relative then return end
  vim.ui.input({ prompt = "Propose change to " .. relative .. ": " }, function(instruction)
    if not instruction or instruction:match("^%s*$") then return end
    request("POST", "/v1/edits/propose", { file = relative, instruction = instruction }, function(response)
      if not response.id or not response.diff then return warn("Incomplete proposal response") end
      M.pending = { id = response.id, file = relative }
      show("Qwen Agent — STAGED ONLY [" .. response.id .. "]", response.diff, "diff")
      warn("Proposal " .. response.id .. " staged; application requires CLI confirmation", vim.log.levels.INFO)
    end)
  end)
end

function M.preview()
  local function get(id)
    if not id or id == "" then return end
    if not id:match("^[%x%-]+$") then return warn("Invalid proposal ID") end
    request("GET", "/v1/edits/" .. id, nil, function(response)
      show("Qwen Agent — Proposal " .. id, response.diff or "(Empty diff)", "diff")
    end)
  end
  if M.pending then return get(M.pending.id) end
  vim.ui.input({ prompt = "Proposal UUID: " }, get)
end

return M
