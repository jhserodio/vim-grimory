-- Vim Grimory - Tree-sitter
-- Extend LazyVim's configuration.
-- Do not replace its setup, build or version pin.

return {
  "nvim-treesitter/nvim-treesitter",

  -- LazyVim appends this list to its built-in parsers.
  opts_extend = { "ensure_installed" },

  opts = {
    ensure_installed = {
      -- Rust and C/C++
      "rust",
      "cpp", -- C is already provided by LazyVim

      -- Web (HTML, JS, TS, TSX, JSON, Markdown
      -- are already included in LazyVim).
      "astro",
      "css",
      "scss",
      "svelte",
      "vue",
      "json5",

      -- Build, containers and infrastructure
      "dockerfile",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "hcl",
      "terraform",

      -- Other languages already supported by Grimory
      "clojure",
      "eex",
      "elixir",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "haskell",
      "heex",
      "java",
      "kotlin",
      "prisma",
      "ron",
      "zig",
    },
  },

  -- Preserve the mapping from Grimory's previous config.
  init = function()
    vim.treesitter.language.register("markdown", "livebook")
  end,
}
