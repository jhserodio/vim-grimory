-- Termux-specific overrides. Original plugin specs are loaded first.
-- Only adapt external executables / installer behavior for Android.
return {
  -- Keep the user's Termux Tokyo Night Storm palette.
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = { style = "storm", transparent = false },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },

  -- Mason's upstream downloadable tools are often not Android-compatible.
  -- Keep Mason itself, but do not automatically install prebuilt Linux tools.
  -- Use native Termux executables (pkg, npm, cargo, go) instead.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
      opts.automatic_installation = false
      opts.automatic_enable = false
    end,
  },

  -- All language settings from plugins/lsp.lua remain intact.
  -- LSP servers are native executables: no Mason installer on Android.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      for name, server in pairs(opts.servers or {}) do
        if type(server) == "table" then
          server.mason = false
        end
      end
    end,
  },

  -- Blink has an Android/aarch64 Rust binary and can fall back to Lua.
  -- Retain the original completion sources and custom keymaps.
  {
    "saghen/blink.cmp",
    opts = {
      fuzzy = { implementation = "prefer_rust" },
    },
  },

  -- Tree-sitter and parser selections stay in the original plugin specs.
  -- The compiler preference is configured via CC/CXX in config/options.lua.
}
