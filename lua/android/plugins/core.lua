-- Vim Grimory / Termux Android profile.
-- This is the only custom plugin module loaded by android-version.
-- Desktop plugins remain in lua/plugins, but are not imported.

return {
  -- Match the Tokyo Night Storm palette used by Termux.
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = { style = "storm", transparent = false },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },

  -- Conventional completion only; no AI providers.
  -- Current blink.cmp releases support Android aarch64.
  {
    "saghen/blink.cmp",
    opts = {
      appearance = { nerd_font_variant = "mono" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust" },
    },
  },

  -- Do not have Mason automatically install a desktop toolchain.
  -- Prefer native Termux packages and binaries on PATH.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
    end,
  },

  -- Native Termux language servers, not Mason downloads.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      for _, server in ipairs({
        "lua_ls",
        "bashls",
        "clangd",
        "rust_analyzer",
        "gopls",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "astro",
        "marksman",
      }) do
        opts.servers[server] = vim.tbl_deep_extend(
          "force",
          opts.servers[server] or {},
          { mason = false }
        )
      end
    end,
  },

  -- Parsers compiled on-device (requires Termux clang/toolchain).
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "rust",
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "markdown",
        "markdown_inline",
      },
    },
  },
}
