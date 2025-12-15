-- Additional Go tools for refactoring and code generation
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure gopls is configured
      if not opts.servers then
        opts.servers = {}
      end
      
      -- Add Go-specific keymaps
      if not opts.servers.gopls then
        opts.servers.gopls = {}
      end
      
      if not opts.servers.gopls.keys then
        opts.servers.gopls.keys = {}
      end
      
      vim.list_extend(opts.servers.gopls.keys, {
        -- Struct tags manipulation using gomodifytags
        {
          "<leader>cgt",
          function()
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            local ns = vim.api.nvim_create_namespace("gomodifytags")
            
            vim.ui.select({ "add", "remove", "clear" }, {
              prompt = "Modify tags:",
            }, function(action)
              if not action then
                return
              end
              
              local tags = { "json", "yaml", "xml" }
              local tag_input = table.concat(tags, ",")
              
              local cmd = string.format(
                "gomodifytags -file %s -line %d -offset %d -%s-tags %s -w",
                vim.fn.expand("%:p"),
                row,
                col,
                action,
                tag_input
              )
              
              vim.fn.system(cmd)
              vim.cmd("edit!")
            end)
          end,
          desc = "Modify Struct Tags (Go)",
        },
        -- Generate interface implementation using impl
        {
          "<leader>cgi",
          function()
            vim.ui.input({ prompt = "Receiver name: " }, function(receiver)
              if not receiver or receiver == "" then
                return
              end
              
              vim.ui.input({ prompt = "Interface (e.g., io.Reader): " }, function(interface)
                if not interface or interface == "" then
                  return
                end
                
                local cmd = string.format("impl '%s' %s", receiver, interface)
                local output = vim.fn.system(cmd)
                
                if vim.v.shell_error ~= 0 then
                  vim.notify("Failed to generate implementation: " .. output, vim.log.levels.ERROR)
                  return
                end
                
                -- Insert at cursor
                local lines = vim.split(output, "\n")
                local row = vim.api.nvim_win_get_cursor(0)[1]
                vim.api.nvim_buf_set_lines(0, row, row, false, lines)
              end)
            end)
          end,
          desc = "Generate Interface Implementation (Go)",
        },
        -- Fill struct fields
        {
          "<leader>cgf",
          function()
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { "refactor.rewrite" } }
            local results = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
            
            for _, result in pairs(results or {}) do
              for _, action in pairs(result.result or {}) do
                if action.title == "Fill struct" then
                  vim.lsp.buf.code_action({ apply = true, context = { only = { "refactor.rewrite" } } })
                  return
                end
              end
            end
            
            vim.notify("No 'Fill struct' action available", vim.log.levels.WARN)
          end,
          desc = "Fill Struct Fields (Go)",
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        "gomodifytags",
        "impl",
        "goimports",
        "gofumpt",
        "golangci-lint",
      })
    end,
  },
}
