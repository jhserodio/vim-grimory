return {
  "mason-org/mason.nvim",

  opts = {
    ensure_installed = {
      -- General
      "stylua",
      "shfmt",
      "prettier",
      "markdownlint-cli2",
      "markdown-toc",

      -- Rust
      "rust-analyzer",
      "codelldb",
      "bacon",

      -- Javascript / Typescript
      "js-debug-adapter",

      -- Containers
      "hadolint",

      -- Go
      "goimports",
      "gofumpt",
      "gomodifytags",
      "impl",
      "delve",

      -- Java / Kotlin
      "java-debug-adapter",
      "java-test",
      "jdtls",
      "klint",

      -- Terraform
      "tflint",

      --Haskell
      "haskell-language-server",
      "haskell-debug-adapter",
    },
  },
}
