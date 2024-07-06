return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- C
        "cmakelang",
        "cmakelint",
        -- DOCKER
        "hadolint",
        -- ELIXIR / ERLLANG
        "elixir-ls",
        "elp",
        -- GO
        "gopls",
        "goimports",
        "gofumpt",
        "gomodifytags",
        "impl",
        "delve",
        -- HASKELL
        "haskell-language-server",
        "haskell-debug-adapter",
        -- MARKDOWN
        "markdownlint",
        "marksman",
        -- RUST
        "codelldb",
        "taplo",
        -- FORMAT FW
        "prettier",
        "eslint-lsp",
        -- HTML
        "astro-language-server",
        "emmet-ls",
        "emmet-language-server",
        "html-lsp",
        -- CSS
        "tailwindcss-language-server",
        "css-lsp",
        "cssmodules-language-server",
        -- NODE / DENO / TS
        "vtsls",
        "typescript-language-server",
        -- SQL AND DATABASES
        "sqlls",
        "sqls",
        -- C / C++
        "clangd",
        "cspell",
        "clang-format",
        "cmake-language-server",
        "codelldb",
        -- BASH / SHELL / ZSH
        "shellcheck",
        -- CONFIG FILES
        "tflint",
      })
    end,
  },
}
