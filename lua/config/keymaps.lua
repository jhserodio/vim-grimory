-- Grimory custom keymaps. LazyVim loads this module on VeryLazy.
-- Keep local agent mappings in ONE place; plugin specs should not remap them.
-- Minuet supplies inline completion independently of this API client.

local function agent(action)
  return function()
    require("grimory.agent")[action]()
  end
end

local actions = {
  { suffix = "h", action = "health", command = "GrimoryAgentHealth", description = "Qwen: API health" },
  { suffix = "a", action = "ask", command = "GrimoryAgentAsk", description = "Qwen: ask project" },
  { suffix = "f", action = "ask_file", command = "GrimoryAgentFile", description = "Qwen: ask current file" },
  { suffix = "e", action = "propose", command = "GrimoryAgentEdit", description = "Qwen: propose file edit" },
  { suffix = "p", action = "preview", command = "GrimoryAgentPreview", description = "Qwen: preview staged diff" },
}

for _, entry in ipairs(actions) do
  local callback = agent(entry.action)
  vim.keymap.set("n", "<leader>a" .. entry.suffix, callback, {
    silent = true,
    desc = entry.description,
  })
  vim.api.nvim_create_user_command(entry.command, callback, {
    desc = entry.description,
  })
end
