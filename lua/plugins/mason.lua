-- ============================================================================
-- Vim Grimory - Mason
--
-- Extends LazyVim's Mason configuration.
-- Preserves existing packages and removes duplicates.
--
-- Do not redefine config() or call mason.setup() manually.
-- ============================================================================

local extra_tools = {
  -- General
  "prettier",
  "markdownlint-cli2",
  "markdown-toc",

  -- Rust / C / C++
  "codelldb",
  "bacon",

  -- JavaScript / TypeScript
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
  "jdtls",
  "java-debug-adapter",
  "java-test",
  "ktlint",

  -- Terraform
  "tflint",

  -- Haskell
  "haskell-language-server",
  "haskell-debug-adapter",
}

return {
  "mason-org/mason.nvim",

  opts = function(_, opts)
    -- Keep tools already declared by LazyVim and its extras.
    local tools = vim.deepcopy(opts.ensure_installed or {})

    -- Append Grimory-specific tools.
    vim.list_extend(tools, extra_tools)

    -- Remove duplicates while preserving their original order.
    opts.ensure_installed = LazyVim.dedup(tools)
  end,
}
