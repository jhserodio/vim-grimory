return {

  "mason-org/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  opts_extend = { "ensure_installed" },
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
      "prettier",
      "codelldb",
      "hadolint",
      "goimports",
      "gofumpt",
      "gomodifytags",
      "impl",
      "delve",
      "java-debug-adapter",
      "java-test",
      "ktlint",
      "markdownlint-cli2",
      "markdown-toc",
      "tflint",
      "js-debug-adapter",
      "bacon",
      "haskell-language-server",
      "haskell-debug-adapter",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        -- trigger FileType event to possibly load this newly installed LSP server
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)
  end,
}
