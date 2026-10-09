-- C/C++ additional tools for static analysis and debugging
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if not opts.servers then
        opts.servers = {}
      end
      
      if not opts.servers.clangd then
        opts.servers.clangd = {}
      end
      
      -- Add inlay hints configuration
      vim.list_extend(opts.servers.clangd.keys or {}, {
        {
          "<leader>cH",
          function()
            if vim.lsp.inlay_hint.is_enabled(0) then
              vim.lsp.inlay_hint.enable(0, false)
              vim.notify("Inlay hints disabled", vim.log.levels.INFO)
            else
              vim.lsp.inlay_hint.enable(0, true)
              vim.notify("Inlay hints enabled", vim.log.levels.INFO)
            end
          end,
          desc = "Toggle Inlay Hints (C/C++)",
        },
      })
      
      -- Merge with existing clangd settings
      opts.servers.clangd = vim.tbl_deep_extend("force", opts.servers.clangd, {
        settings = {
          clangd = {
            InlayHints = {
              Enabled = true,
              ParameterNames = true,
              DeducedTypes = true,
              Designators = true,
              BlockEnd = true,
            },
          },
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        "clang-format",
        "codelldb",
        "cpplint",
        "cpptools",
      })
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {
      inlay_hints = {
        inline = false,
        only_current_line = false,
        only_current_line_autocmd = { "CursorHold" },
        show_parameter_hints = true,
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
      },
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
      memory_usage = {
        border = "none",
      },
      symbol_info = {
        border = "none",
      },
    },
  },
}
