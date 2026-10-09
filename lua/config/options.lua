-- Termux / Samsung DeX: avoid X11 and Wayland clipboard commands.
vim.opt.termguicolors = true
vim.opt.mouse = "a"

-- Preserve Vim's registers when Android clipboard commands are unavailable.
vim.opt.clipboard = ""

if vim.fn.executable("termux-clipboard-set") == 1
  and vim.fn.executable("termux-clipboard-get") == 1 then
  vim.g.clipboard = {
    name = "termux",
    copy = {
      ["+"] = "termux-clipboard-set",
      ["*"] = "termux-clipboard-set",
    },
    paste = {
      ["+"] = "termux-clipboard-get",
      ["*"] = "termux-clipboard-get",
    },
    cache_enabled = 0,
  }
  vim.opt.clipboard = "unnamedplus"
end
