-- Grimory custom keymaps. LazyVim loads this module on VeryLazy.
-- Keep local agent mappings in ONE place; plugin specs should not remap them.
-- Minuet owns inline AI completion independently of this API client.

local function agent(action)
  return function()
    require("grimory.agent")[action]()
  end
end

--
-- Hermes legacy local-agent API.
--
-- This remains available as a supervised fallback while OpenCode
-- becomes the primary agentic runtime through CodeCompanion + ACP.
--
local actions = {
  {
    suffix = "h",
    action = "health",
    command = "HermesHealth",
    description = "Hermes: local agent health",
  },
  {
    suffix = "a",
    action = "ask",
    command = "HermesAsk",
    description = "Hermes: ask project",
  },
  {
    suffix = "f",
    action = "ask_file",
    command = "HermesFile",
    description = "Hermes: ask current file",
  },
  {
    suffix = "e",
    action = "propose",
    command = "HermesEdit",
    description = "Hermes: propose file edit",
  },
  {
    suffix = "p",
    action = "preview",
    command = "HermesPreview",
    description = "Hermes: preview staged diff",
  },
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

--
-- OpenCode through CodeCompanion + ACP.
--
-- <leader>ac -> toggle current chat
-- <leader>an -> start a new OpenCode chat
-- <leader>as -> send visual selection to chat
-- <leader>ao -> CodeCompanion actions
--

vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", {
  silent = true,
  desc = "Hermes: toggle OpenCode chat",
})

vim.keymap.set("n", "<leader>an", "<cmd>CodeCompanionChat adapter=opencode<cr>", {
  silent = true,
  desc = "Hermes: new OpenCode chat",
})

vim.keymap.set("v", "<leader>as", "<cmd>CodeCompanionChat Add<cr>", {
  silent = true,
  desc = "Hermes: add selection to OpenCode",
})

vim.keymap.set({ "n", "v" }, "<leader>ao", "<cmd>CodeCompanionActions<cr>", {
  silent = true,
  desc = "Hermes: CodeCompanion actions",
})
