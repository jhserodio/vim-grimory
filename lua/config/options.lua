vim.g.lazyvim_prettier_needs_config = false
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

-- Keep navigation rooted at the Git project even if the LSP detects a subdirectory.
-- Outside Git, prefer the LSP workspace and then the working directory.
vim.g.root_spec = { ".git", "lsp", "cwd" }

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
