-- Termux/Android terminal and clipboard integration.
vim.opt.termguicolors = true
vim.opt.mouse = "a"

-- Avoid E8500 ("No clipboard provider") when Termux clipboard isn't available.
-- The Google Play Termux build exposes these commands without termux-api.
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

-- The nvim-treesitter main branch uses the system C toolchain (cc crate).
-- Respect existing compiler choices, otherwise prefer Termux's native clang.
if vim.fn.executable("clang") == 1 then
  if not vim.env.CC or vim.env.CC == "" then
    vim.env.CC = "clang"
  end
  if vim.fn.executable("clang++") == 1 and (not vim.env.CXX or vim.env.CXX == "") then
    vim.env.CXX = "clang++"
  end
end
