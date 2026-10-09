-- Android-specific LazyVim overrides.
-- Keep this profile small: no auto-installs, build steps or AI services.
return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = { style = "storm", transparent = false },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },

  -- These installers generally expect Linux binaries rather than Android.
  -- Use tools installed natively via Termux and present on PATH.
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },

  -- No external native matcher or Rust build required for basic completion.
  {
    "saghen/blink.cmp",
    build = false,
    opts = {
      fuzzy = { implementation = "lua" },
      appearance = { nerd_font_variant = "mono" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },

  -- Keep Tree-sitter plugin without downloading or compiling grammars.
  -- Native grammars can be added after validating Termux clang.
  {
    "nvim-treesitter/nvim-treesitter",
    build = false,
    opts = function(_, opts)
      opts.ensure_installed = {}
      opts.auto_install = false
    end,
  },

  -- Start language servers only when a matching executable is installed.
  -- Mason is disabled; no installers are triggered for missing languages.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      local executables = {
        lua_ls = "lua-language-server",
        bashls = "bash-language-server",
        clangd = "clangd",
        rust_analyzer = "rust-analyzer",
        gopls = "gopls",
        ts_ls = "typescript-language-server",
        html = "vscode-html-language-server",
        cssls = "vscode-css-language-server",
        jsonls = "vscode-json-language-server",
        astro = "astro-ls",
        marksman = "marksman",
      }

      for server, executable in pairs(executables) do
        opts.servers[server] = vim.tbl_deep_extend(
          "force",
          type(opts.servers[server]) == "table" and opts.servers[server] or {},
          {
            mason = false,
            enabled = vim.fn.executable(executable) == 1,
          }
        )
      end
    end,
  },
}
