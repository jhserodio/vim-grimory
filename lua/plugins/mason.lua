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
    
    -- Safely setup registry event handler
    local ok, _ = pcall(function()
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          pcall(require("lazy.core.handler.event").trigger, {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
    end)
    
    if not ok then
      -- Fallback: just ensure installed packages
      vim.defer_fn(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if p and not p:is_installed() then
            p:install()
          end
        end
      end, 100)
    end
  end,
}
