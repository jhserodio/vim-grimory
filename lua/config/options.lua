vim.g.lazyvim_prettier_needs_config = false
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

-- Clipboard configuration
vim.opt.clipboard = "unnamedplus"

-- Typescript language server
vim.g.lazyvim_ts_lsp = "vtsls"

-- Ensure clipboard providers are set correctly
vim.g.clipboard = {
  name = "WaylandClipboard",
  copy = {
    ["+"] = "wl-copy",
    ["*"] = "wl-copy",
  },
  paste = {
    ["+"] = "wl-paste --no-newline",
    ["*"] = "wl-paste --no-newline",
  },
  cache_enabled = 0,
}
