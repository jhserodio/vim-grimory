-- Enhanced clipboard support for Neovim
-- Allows copying error messages and logs to system clipboard

-- Mouse support for easier copying
vim.opt.mouse = "a" -- Enable mouse in all modes
vim.opt.mousemodel = "extend" -- Right-click extends selection

-- Function to copy messages/errors to clipboard
vim.api.nvim_create_user_command("CopyMessages", function()
  local messages = vim.fn.execute("messages")
  vim.fn.setreg("+", messages)
  vim.notify("Messages copied to clipboard!", vim.log.levels.INFO)
end, {})

-- Function to copy last error to clipboard
vim.api.nvim_create_user_command("CopyLastError", function()
  local messages = vim.fn.execute("messages")
  local lines = vim.split(messages, "\n")
  local errors = {}
  
  for _, line in ipairs(lines) do
    if line:match("Error") or line:match("Error detected") or line:match("stacktrace") then
      table.insert(errors, line)
    end
  end
  
  if #errors > 0 then
    vim.fn.setreg("+", table.concat(errors, "\n"))
    vim.notify("Last error copied to clipboard!", vim.log.levels.INFO)
  else
    vim.notify("No errors found in messages", vim.log.levels.WARN)
  end
end, {})

-- Keymaps for easy access
vim.keymap.set("n", "<leader>cm", "<cmd>CopyMessages<cr>", { desc = "Copy all messages to clipboard" })
vim.keymap.set("n", "<leader>ce", "<cmd>CopyLastError<cr>", { desc = "Copy last error to clipboard" })

-- Visual mode: easy copy with Ctrl+C
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("v", "<C-x>", '"+d', { desc = "Cut to clipboard" })

-- Normal mode: paste from clipboard
vim.keymap.set("n", "<C-v>", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("i", "<C-v>", '<C-r>+', { desc = "Paste from clipboard" })

-- Auto-save errors to a log file
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local log_file = vim.fn.stdpath("data") .. "/error.log"
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        local messages = vim.fn.execute("messages")
        local f = io.open(log_file, "w")
        if f then
          f:write(messages)
          f:close()
        end
      end,
    })
  end,
})
