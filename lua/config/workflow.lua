-- Workflow automation and productivity enhancements
local M = {}

-- Auto-save on focus lost and buffer leave
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.api.nvim_command("silent! update")
    end
  end,
  desc = "Auto-save on focus lost or buffer leave",
})

-- Auto-format on save for configured languages
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.rs", "*.go", "*.hs", "*.java", "*.cpp", "*.c", "*.h", "*.hpp", "*.jl" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
  desc = "Auto-format on save",
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

-- Auto-create missing directories when saving
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto-create directories",
})

-- Remember cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Restore cursor position",
})

-- Project templates
M.create_rust_project = function(name)
  vim.fn.system({ "cargo", "new", name })
  vim.cmd("edit " .. name .. "/Cargo.toml")
  vim.notify("Created Rust project: " .. name, vim.log.levels.INFO)
end

M.create_go_module = function(name)
  local dir = vim.fn.expand(name)
  vim.fn.mkdir(dir, "p")
  vim.fn.chdir(dir)
  vim.fn.system({ "go", "mod", "init", name })
  vim.cmd("edit go.mod")
  vim.notify("Created Go module: " .. name, vim.log.levels.INFO)
end

M.create_haskell_project = function(name)
  vim.fn.system({ "cabal", "init", "--non-interactive", "--simple", name })
  vim.cmd("edit " .. name .. "/" .. name .. ".cabal")
  vim.notify("Created Haskell project: " .. name, vim.log.levels.INFO)
end

-- Register commands
vim.api.nvim_create_user_command("RustNew", function(opts)
  M.create_rust_project(opts.args)
end, { nargs = 1, desc = "Create new Rust project" })

vim.api.nvim_create_user_command("GoNew", function(opts)
  M.create_go_module(opts.args)
end, { nargs = 1, desc = "Create new Go module" })

vim.api.nvim_create_user_command("HaskellNew", function(opts)
  M.create_haskell_project(opts.args)
end, { nargs = 1, desc = "Create new Haskell project" })

-- Quick refactoring helpers
M.extract_variable = function()
  vim.lsp.buf.code_action({
    filter = function(action)
      return action.kind and action.kind:match("refactor.extract")
    end,
    apply = true,
  })
end

M.inline_variable = function()
  vim.lsp.buf.code_action({
    filter = function(action)
      return action.kind and action.kind:match("refactor.inline")
    end,
    apply = true,
  })
end

-- Keymaps for workflow
vim.keymap.set("n", "<leader>rn", M.extract_variable, { desc = "Extract Variable" })
vim.keymap.set("n", "<leader>ri", M.inline_variable, { desc = "Inline Variable" })

-- Toggle options helpers
vim.keymap.set("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify("Wrap: " .. tostring(vim.wo.wrap), vim.log.levels.INFO)
end, { desc = "Toggle Wrap" })

vim.keymap.set("n", "<leader>us", function()
  vim.wo.spell = not vim.wo.spell
  vim.notify("Spell: " .. tostring(vim.wo.spell), vim.log.levels.INFO)
end, { desc = "Toggle Spell" })

vim.keymap.set("n", "<leader>ul", function()
  vim.wo.number = not vim.wo.number
  vim.notify("Line Numbers: " .. tostring(vim.wo.number), vim.log.levels.INFO)
end, { desc = "Toggle Line Numbers" })

vim.keymap.set("n", "<leader>ur", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.notify("Relative Numbers: " .. tostring(vim.wo.relativenumber), vim.log.levels.INFO)
end, { desc = "Toggle Relative Numbers" })

-- Smart buffer navigation (skip quickfix/loclist)
M.next_buffer = function()
  local current = vim.api.nvim_get_current_buf()
  vim.cmd("bnext")
  while vim.bo.buftype ~= "" and vim.api.nvim_get_current_buf() ~= current do
    vim.cmd("bnext")
  end
end

M.prev_buffer = function()
  local current = vim.api.nvim_get_current_buf()
  vim.cmd("bprevious")
  while vim.bo.buftype ~= "" and vim.api.nvim_get_current_buf() ~= current do
    vim.cmd("bprevious")
  end
end

vim.keymap.set("n", "<S-l>", M.next_buffer, { desc = "Next Buffer" })
vim.keymap.set("n", "<S-h>", M.prev_buffer, { desc = "Previous Buffer" })

-- Quick window navigation with terminal support
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Window resize with arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Better indenting in visual mode (keeps selection)
vim.keymap.set("v", "<", "<gv", { desc = "Indent Left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent Right" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Selection Down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Selection Up" })

-- Quick save and quit
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit All" })

-- Clear search highlight with ESC
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear Search Highlight" })

-- Better paste (don't yank replaced text)
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste Without Yank" })

return M
