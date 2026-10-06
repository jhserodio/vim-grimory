-- Grimory custom keymaps. LazyVim loads this module on VeryLazy.
-- Keep local agent mappings in ONE place; plugin specs should not remap them.
-- Minuet owns inline AI completion independently of this API client.

local function agent(action)
  return function()
    require("grimory.agent")[action]()
  end
end

local actions = {
  { suffix = "h", action = "health", command = "HermesHealth", description = "Hermes: API health" },
  { suffix = "a", action = "ask", command = "HermesAsk", description = "Hermes: ask project" },
  { suffix = "f", action = "ask_file", command = "HermesFile", description = "Hermes: ask current file" },
  { suffix = "e", action = "propose", command = "HermesEdit", description = "Hermes: propose file edit" },
  { suffix = "p", action = "preview", command = "HermesPreview", description = "Hermes: preview staged diff" },
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
