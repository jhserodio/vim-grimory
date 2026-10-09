return {
  "mrcjkb/haskell-tools.nvim",
  version = "^4",
  ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  dependencies = {
    { "nvim-telescope/telescope.nvim", optional = true },
  },
  opts = {
    hls = {
      on_attach = function(client, bufnr)
        -- Refactoring keymaps
        local opts_key = { silent = true, buffer = bufnr }
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts_key)
        vim.keymap.set("n", "<leader>hs", require("haskell-tools").lsp.start, { desc = "Start HLS", buffer = bufnr })
        vim.keymap.set("n", "<leader>hS", require("haskell-tools").lsp.stop, { desc = "Stop HLS", buffer = bufnr })
        vim.keymap.set("n", "<leader>hr", require("haskell-tools").lsp.restart, { desc = "Restart HLS", buffer = bufnr })
        
        -- Hoogle
        vim.keymap.set("n", "<leader>hh", require("haskell-tools").hoogle.hoogle_signature, { desc = "Hoogle Signature", buffer = bufnr })
        
        -- Repl
        vim.keymap.set("n", "<leader>rr", require("haskell-tools").repl.toggle, { desc = "Toggle GHCi Repl", buffer = bufnr })
        vim.keymap.set("n", "<leader>rf", function()
          require("haskell-tools").repl.toggle(vim.api.nvim_buf_get_name(0))
        end, { desc = "Toggle GHCi Repl (current file)", buffer = bufnr })
        vim.keymap.set("n", "<leader>rq", require("haskell-tools").repl.quit, { desc = "Quit Repl", buffer = bufnr })
      end,
      settings = {
        haskell = {
          -- Plugin settings
          plugin = {
            tactics = {
              config = {
                max_use_ctor_actions = 10,
                timeout_duration = 2,
              },
            },
            importLens = {
              codeLensOn = true,
            },
            refineImports = {
              codeLensOn = true,
            },
            retrie = {
              codeLensOn = true,
            },
          },
          -- Formatting
          formattingProvider = "fourmolu",
          -- Checkproject on save
          checkProject = true,
          maxCompletions = 40,
        },
      },
    },
    tools = {
      hover = {
        enable = true,
        border = {
          { "╭", "FloatBorder" },
          { "─", "FloatBorder" },
          { "╮", "FloatBorder" },
          { "│", "FloatBorder" },
          { "╯", "FloatBorder" },
          { "─", "FloatBorder" },
          { "╰", "FloatBorder" },
          { "│", "FloatBorder" },
        },
        stylize_markdown = true,
        auto_focus = false,
      },
      repl = {
        handler = "toggleterm",
        builtin = {
          create_repl_window = function(view)
            return view.create_repl_split({ size = vim.o.lines / 3 })
          end,
        },
      },
    },
  },
  config = function(_, opts)
    local ok, telescope = pcall(require, "telescope")
    if ok then
      telescope.load_extension("ht")
    end
    vim.g.haskell_tools = opts
  end,
}
