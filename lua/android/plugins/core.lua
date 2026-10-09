-- Android-only overrides; portable plugins remain in lua/plugins.
return {
  { "folke/tokyonight.nvim", priority = 1000,
    opts = { style = "storm", transparent = false } },
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight" } },

  -- Keep the Mason UI, but no native-incompatible downloads or PATH
  -- precedence over the tools installed by Termux.
  {
    "mason-org/mason.nvim",
    build = false,
    opts = function(_, opts)
      opts.ensure_installed = {}
      opts.PATH = "skip"
    end,
  },

  -- The pinned LazyVim version configures mason-lspconfig directly.
  -- opts.automatic_installation=false would not stop that code path.
  -- Native LSP servers do not need the Mason installation bridge.
  { "mason-org/mason-lspconfig.nvim", enabled = false },

  -- Preserve all existing per-language settings. Convert boolean
  -- entries as well so every server bypasses Mason.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      for name, server in pairs(opts.servers or {}) do
        if server == true then
          opts.servers[name] = { mason = false }
        elseif type(server) == "table" then
          server.mason = false
        end
      end
    end,
  },

  { "saghen/blink.cmp",
    opts = { fuzzy = { implementation = "prefer_rust" } } },

  -- No Tree-sitter or Telescope disabling: their native builds use
  -- the CC/CXX toolchain selected in lua/config/options.lua.
}
