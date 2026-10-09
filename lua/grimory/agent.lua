-- Local Hermes client for selfhosted-qwen-codeagent.
-- Neovim >= 0.11, curl.
-- No cloud API dependency.

local M = {
  pending = nil,
}

local ACTIVITY_DELAY_MS = 500
local ACTIVITY_INTERVAL_MS = 400

local function notify(message, level)
  vim.notify("Hermes: " .. message, level or vim.log.levels.WARN)
end

local function format_duration(elapsed_ms)
  if not elapsed_ms then
    return nil
  end

  if elapsed_ms < 1000 then
    return string.format("%dms", elapsed_ms)
  end

  return string.format("%.1fs", elapsed_ms / 1000)
end

local function title_with_duration(title, elapsed_ms)
  local duration = format_duration(elapsed_ms)

  if not duration then
    return title
  end

  return title .. " • " .. duration
end

local function start_activity(message)
  local timer = vim.uv.new_timer()
  local started_at = vim.uv.hrtime()

  local stopped = false
  local shown = false
  local dots = 1

  local function elapsed_ms()
    return math.floor(((vim.uv.hrtime() - started_at) / 1e6) + 0.5)
  end

  timer:start(
    ACTIVITY_DELAY_MS,
    ACTIVITY_INTERVAL_MS,
    vim.schedule_wrap(function()
      if stopped then
        return
      end

      shown = true

      vim.api.nvim_echo({
        {
          message .. string.rep(".", dots),
          "Comment",
        },
      }, false, {})

      dots = (dots % 3) + 1
    end)
  )

  return function()
    if stopped then
      return elapsed_ms()
    end

    stopped = true

    pcall(function()
      timer:stop()
    end)

    pcall(function()
      if not timer:is_closing() then
        timer:close()
      end
    end)

    local duration = elapsed_ms()

    if shown then
      vim.schedule(function()
        vim.api.nvim_echo({
          { "" },
        }, false, {})
      end)
    end

    return duration
  end
end

local function settings()
  local url = vim.g.qwen_agent_url or "http://127.0.0.1:8766"

  local workspace = vim.g.qwen_agent_workspace or vim.fn.expand("~/dev/vim-grimory")

  if not url:match("^http://127%.0%.0%.1:%d+$") then
    return nil, "Only http://127.0.0.1:<port> is supported"
  end

  local canonical = vim.uv.fs_realpath(vim.fn.expand(workspace))

  if not canonical then
    return nil, "Configured workspace does not exist"
  end

  return {
    url = url,
    workspace = canonical,
  }
end

local function current_workspace(config)
  local cwd = vim.uv.fs_realpath(vim.fn.getcwd())

  if cwd ~= config.workspace then
    notify("Open Neovim at the configured server workspace: " .. config.workspace)

    return false
  end

  return true
end

local function token()
  local path = vim.fn.expand("~/.config/qwen-codeagent/token")

  local file = io.open(path, "r")

  if not file then
    return nil, "Cannot read " .. path
  end

  local value = file:read("*a")

  file:close()

  value = (value or ""):gsub("%s+$", "")

  if #value < 32 or value:find("[\r\n]") then
    return nil, "Invalid API token"
  end

  return value
end

local function request(method, route, payload, done, options)
  options = options or {}

  if vim.fn.executable("curl") ~= 1 then
    return notify("curl is required")
  end

  local config, config_error = settings()

  if not config then
    return notify(config_error)
  end

  if not current_workspace(config) then
    return
  end

  local auth, auth_error = token()

  if not auth then
    return notify(auth_error)
  end

  --
  -- Keep bearer token out of process arguments visible through `ps`.
  --
  local header_path = vim.fn.tempname()

  local fd, open_error = vim.uv.fs_open(header_path, "w", 384)

  if not fd then
    return notify("Cannot prepare private header: " .. tostring(open_error))
  end

  local wrote, write_error = vim.uv.fs_write(fd, "Authorization: Bearer " .. auth .. "\n", 0)

  vim.uv.fs_close(fd)

  if not wrote then
    vim.uv.fs_unlink(header_path)

    return notify("Cannot prepare authorization: " .. tostring(write_error))
  end

  local argv = {
    "curl",
    "-q",
    "--silent",
    "--show-error",
    "--noproxy",
    "*",

    "--connect-timeout",
    "3",

    "--max-time",
    "240",

    "--request",
    method,

    "--header",
    "@" .. header_path,

    "--header",
    "Content-Type: application/json",

    "--write-out",
    "\n%{http_code}",
  }

  if payload then
    vim.list_extend(argv, {
      "--data-binary",
      "@-",
    })
  end

  table.insert(argv, config.url .. route)

  local input = payload and vim.json.encode(payload) or nil

  local stop_activity = start_activity(options.activity or "Hermes is thinking")

  vim.system(argv, {
    text = true,
    stdin = input,
  }, function(result)
    local elapsed_ms = stop_activity()

    vim.uv.fs_unlink(header_path)

    vim.schedule(function()
      if result.code ~= 0 then
        return notify((result.stderr or "curl failed"):gsub("%s+$", ""), vim.log.levels.ERROR)
      end

      local data, status = (result.stdout or ""):match("^(.*)\n(%d%d%d)%s*$")

      if not data or not status then
        return notify("Invalid HTTP response", vim.log.levels.ERROR)
      end

      local ok, response = pcall(vim.json.decode, data)

      if not ok or type(response) ~= "table" then
        return notify("Invalid JSON response", vim.log.levels.ERROR)
      end

      local status_number = tonumber(status)

      if status_number < 200 or status_number >= 300 then
        return notify("HTTP " .. status .. ": " .. tostring(response.error or "Request failed"), vim.log.levels.ERROR)
      end

      done(response, {
        elapsed_ms = elapsed_ms,
      })
    end)
  end)
end

local function close_window(win)
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
end

local function show(title, content, filetype, actions)
  local lines = vim.split(content, "\n", {
    plain = true,
  })

  local width = math.min(110, math.max(30, vim.o.columns - 6))

  local height = math.min(math.max(3, #lines), math.max(3, vim.o.lines - 7))

  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.bo[buf].filetype = filetype or "markdown"
  vim.bo[buf].modifiable = false

  local window_options = {
    relative = "editor",
    style = "minimal",
    border = "rounded",

    width = width,
    height = height,

    row = math.floor((vim.o.lines - height) / 2) - 1,

    col = math.floor((vim.o.columns - width) / 2),

    title = title,
    title_pos = "center",
  }

  if actions then
    window_options.footer = " a Apply   r Reject   q Close "
    window_options.footer_pos = "center"
  end

  local win = vim.api.nvim_open_win(buf, true, window_options)

  vim.keymap.set("n", "q", function()
    close_window(win)
  end, {
    buffer = buf,
    silent = true,
    nowait = true,
    desc = "Close Hermes panel",
  })

  if actions then
    if actions.apply then
      vim.keymap.set("n", "a", function()
        actions.apply(win, buf)
      end, {
        buffer = buf,
        silent = true,
        nowait = true,
        desc = "Apply Hermes proposal",
      })
    end

    if actions.reject then
      vim.keymap.set("n", "r", function()
        actions.reject(win, buf)
      end, {
        buffer = buf,
        silent = true,
        nowait = true,
        desc = "Reject Hermes proposal",
      })
    end
  end

  return buf, win
end

local function current_file(config)
  if not current_workspace(config) then
    return nil
  end

  if vim.bo.modified then
    notify("Save the current buffer before using it as Hermes context")

    return nil
  end

  local filename = vim.api.nvim_buf_get_name(0)

  local canonical = vim.uv.fs_realpath(filename)

  if not canonical or canonical:sub(1, #config.workspace + 1) ~= config.workspace .. "/" then
    notify("Current file is outside the API workspace")

    return nil
  end

  return canonical:sub(#config.workspace + 2)
end

local function loaded_buffer_for(config, relative)
  local path = config.workspace .. "/" .. relative

  local target = vim.uv.fs_realpath(path) or path

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local name = vim.api.nvim_buf_get_name(bufnr)

      if name ~= "" then
        local canonical = vim.uv.fs_realpath(name)

        if canonical == target then
          return bufnr
        end
      end
    end
  end

  return nil
end

local function reload_buffer(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  if vim.bo[bufnr].modified then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd("silent edit!")
  end)
end

local function reject_pending(win)
  if not M.pending then
    close_window(win)

    return
  end

  local file = M.pending.file

  M.pending = nil

  close_window(win)

  notify("Proposal rejected for " .. file .. "; no file changes were applied", vim.log.levels.INFO)
end

local function apply_pending(win)
  if not M.pending then
    return notify("There is no pending proposal")
  end

  local config, config_error = settings()

  if not config then
    return notify(config_error)
  end

  if not current_workspace(config) then
    return
  end

  local pending = M.pending

  local target_buf = loaded_buffer_for(config, pending.file)

  --
  -- Protect unsaved editor work.
  -- The backend protects the on-disk hash;
  -- this protects modified Vim buffers.
  --
  if target_buf and vim.bo[target_buf].modified then
    return notify(
      "The target buffer has unsaved changes; save or discard them before applying the proposal",
      vim.log.levels.ERROR
    )
  end

  vim.ui.select({
    "Apply",
    "Cancel",
  }, {
    prompt = "Apply proposed changes to " .. pending.file .. "?",
  }, function(choice)
    if choice ~= "Apply" then
      return
    end

    request("POST", "/v1/edits/" .. pending.id .. "/apply", {
      confirm = true,
    }, function(response)
      --
      -- Only clear the proposal after successful application.
      --
      M.pending = nil

      close_window(win)

      reload_buffer(target_buf)

      notify("Applied changes to " .. tostring(response.file or pending.file), vim.log.levels.INFO)
    end, {
      activity = "Hermes is applying",
    })
  end)
end

local function show_proposal(diff, file, elapsed_ms)
  local title = title_with_duration("Hermes — PROPOSAL • " .. vim.fs.basename(file), elapsed_ms)

  show(title, diff, "diff", {
    apply = function(win)
      apply_pending(win)
    end,

    reject = function(win)
      reject_pending(win)
    end,
  })
end

function M.health()
  request("GET", "/v1/health", nil, function(response)
    local capabilities = table.concat(response.capabilities or {}, ", ")

    notify("API " .. tostring(response.status) .. " | " .. capabilities, vim.log.levels.INFO)
  end, {
    activity = "Hermes is checking",
  })
end

function M.ask()
  vim.ui.input({
    prompt = "Ask Hermes: ",
  }, function(question)
    if not question or question:match("^%s*$") then
      return
    end

    request("POST", "/v1/ask", {
      question = question,
      context = "auto",
    }, function(response, meta)
      local body = {
        response.answer or "(Empty answer)",
      }

      if type(response.sources) == "table" and #response.sources > 0 then
        table.insert(body, "\n---\nRetrieved context (not verification of every model claim):")

        for _, source in ipairs(response.sources) do
          table.insert(
            body,
            string.format(
              "- `%s:%s-%s`",
              tostring(source.relativePath),
              tostring(source.startLine),
              tostring(source.endLine)
            )
          )
        end
      end

      show(title_with_duration("Hermes — ASK", meta.elapsed_ms), table.concat(body, "\n"), "markdown")
    end)
  end)
end

function M.ask_file()
  local config, error_text = settings()

  if not config then
    return notify(error_text)
  end

  local relative = current_file(config)

  if not relative then
    return
  end

  vim.ui.input({
    prompt = "Ask Hermes about " .. relative .. ": ",
  }, function(question)
    if not question or question:match("^%s*$") then
      return
    end

    request("POST", "/v1/ask", {
      question = question,

      files = {
        relative,
      },

      context = "auto",
    }, function(response, meta)
      local body = {
        response.answer or "(Empty answer)",
      }

      if type(response.sources) == "table" and #response.sources > 0 then
        table.insert(body, "\n---\nAdditional retrieved chunks (not verification of all claims):")

        for _, source in ipairs(response.sources) do
          table.insert(
            body,
            string.format(
              "- `%s:%s-%s`",
              tostring(source.relativePath),
              tostring(source.startLine),
              tostring(source.endLine)
            )
          )
        end
      end

      show(
        title_with_duration("Hermes — ASK • " .. vim.fs.basename(relative), meta.elapsed_ms),
        table.concat(body, "\n"),
        "markdown"
      )
    end)
  end)
end

function M.propose()
  local config, error_text = settings()

  if not config then
    return notify(error_text)
  end

  local relative = current_file(config)

  if not relative then
    return
  end

  vim.ui.input({
    prompt = "Edit " .. relative .. " with Hermes: ",
  }, function(instruction)
    if not instruction or instruction:match("^%s*$") then
      return
    end

    request("POST", "/v1/edits/propose", {
      file = relative,
      instruction = instruction,
    }, function(response, meta)
      if not response.id or not response.diff then
        return notify("Incomplete proposal response")
      end

      M.pending = {
        id = response.id,
        file = response.relativePath or relative,
      }

      show_proposal(response.diff, M.pending.file, meta.elapsed_ms)
    end)
  end)
end

function M.preview()
  if not M.pending then
    return notify("There is no pending proposal")
  end

  local pending = M.pending

  request("GET", "/v1/edits/" .. pending.id, nil, function(response)
    if response.file then
      pending.file = response.file
    end

    show_proposal(response.diff or "(Empty diff)", pending.file)
  end, {
    activity = "Hermes is loading",
  })
end

function M.apply()
  apply_pending(nil)
end

function M.reject()
  reject_pending(nil)
end

return M
