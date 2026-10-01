-- Grimory: Deno and Node.js project isolation.

local deno_markers = {
  "deno.json",
  "deno.jsonc",
}

return {
  "neovim/nvim-lspconfig",

  opts = {
    servers = {
      denols = {
        root_dir = function(bufnr, on_dir)
          local root = vim.fs.root(bufnr, deno_markers)

          if root then
            on_dir(root)
          end
        end,
      },

      vtsls = {
        root_dir = function(bufnr, on_dir)
          -- Deno projects belong to denols.
          if vim.fs.root(bufnr, deno_markers) then
            return
          end

          local root = vim.fs.root(bufnr, {
            "tsconfig.json",
            "jsconfig.json",
            "package.json",
            ".git",
          })

          if root then
            on_dir(root)
            return
          end

          -- Standalone JavaScript/TypeScript files.
          local filename = vim.api.nvim_buf_get_name(bufnr)

          if filename ~= "" then
            on_dir(vim.fs.dirname(filename))
          end
        end,
      },
    },
  },
}
