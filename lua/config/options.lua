-- Native Termux settings. No Wayland or X11 clipboard helpers.
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.mouse = "a"

-- Google Play Termux exposes native clipboard commands on supported builds.
-- Check them before registering the provider to prevent clipboard errors.
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
end
