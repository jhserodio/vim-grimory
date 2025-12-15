local diagnostics = vim.g.lazyvim_rust_diagnostics or "rust-analyzer"

return {
  "mrcjkb/rustaceanvim",
  version = false,
  ft = { "rust" },
  opts = {
    server = {
      on_attach = function(_, bufnr)
        -- Code actions
        vim.keymap.set("n", "<leader>cR", function()
          vim.cmd.RustLsp("codeAction")
        end, { desc = "Code Action (Rust)", buffer = bufnr })
        
        -- Debugging
        vim.keymap.set("n", "<leader>dr", function()
          vim.cmd.RustLsp("debuggables")
        end, { desc = "Rust Debuggables", buffer = bufnr })
        
        -- Refactoring tools
        vim.keymap.set("n", "<leader>rh", function()
          vim.cmd.RustLsp("hover", "actions")
        end, { desc = "Hover Actions (Rust)", buffer = bufnr })
        
        vim.keymap.set("n", "<leader>rm", function()
          vim.cmd.RustLsp("moveItem", "up")
        end, { desc = "Move Item Up (Rust)", buffer = bufnr })
        
        vim.keymap.set("n", "<leader>rM", function()
          vim.cmd.RustLsp("moveItem", "down")
        end, { desc = "Move Item Down (Rust)", buffer = bufnr })
        
        vim.keymap.set("n", "J", function()
          vim.cmd.RustLsp("joinLines")
        end, { desc = "Join Lines (Rust)", buffer = bufnr })
        
        vim.keymap.set("n", "<leader>rS", function()
          vim.cmd.RustLsp("ssr")
        end, { desc = "Structural Search Replace (Rust)", buffer = bufnr })
        
        -- Explainers
        vim.keymap.set("n", "<leader>re", function()
          vim.cmd.RustLsp("explainError")
        end, { desc = "Explain Error (Rust)", buffer = bufnr })
        
        vim.keymap.set("n", "<leader>rc", function()
          vim.cmd.RustLsp("openCargo")
        end, { desc = "Open Cargo.toml (Rust)", buffer = bufnr })
        
        vim.keymap.set("n", "<leader>rp", function()
          vim.cmd.RustLsp("parentModule")
        end, { desc = "Parent Module (Rust)", buffer = bufnr })
        
        -- Testing
        vim.keymap.set("n", "<leader>rt", function()
          vim.cmd.RustLsp("runnables")
        end, { desc = "Rust Runnables", buffer = bufnr })
        
        vim.keymap.set("n", "<leader>rT", function()
          vim.cmd.RustLsp("testables")
        end, { desc = "Rust Testables", buffer = bufnr })
      end,
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
            -- Auto-reload on Cargo.toml changes
            autoreload = true,
          },
          -- Add clippy lints for Rust if using rust-analyzer
          checkOnSave = {
            enable = true,
            command = "clippy",
            extraArgs = { "--no-deps" },
            allTargets = true,
          },
          -- Enable diagnostics if using rust-analyzer
          diagnostics = {
            enable = diagnostics == "rust-analyzer",
            experimental = {
              enable = true,
            },
            styleLints = {
              enable = true,
            },
          },
          procMacro = {
            enable = true,
            attributes = {
              enable = true,
            },
            ignored = {
              ["async-trait"] = { "async_trait" },
              ["napi-derive"] = { "napi" },
              ["async-recursion"] = { "async_recursion" },
            },
          },
          -- Inlay hints configuration
          inlayHints = {
            bindingModeHints = {
              enable = false,
            },
            chainingHints = {
              enable = true,
            },
            closingBraceHints = {
              enable = true,
              minLines = 25,
            },
            closureReturnTypeHints = {
              enable = "never",
            },
            lifetimeElisionHints = {
              enable = "never",
              useParameterNames = false,
            },
            maxLength = 25,
            parameterHints = {
              enable = true,
            },
            reborrowHints = {
              enable = "never",
            },
            renderColons = true,
            typeHints = {
              enable = true,
              hideClosureInitialization = false,
              hideNamedConstructor = false,
            },
          },
          -- Imports optimization
          imports = {
            granularity = {
              group = "module",
            },
            prefix = "self",
          },
          -- Lens configuration
          lens = {
            enable = true,
            debug = {
              enable = true,
            },
            implementations = {
              enable = true,
            },
            run = {
              enable = true,
            },
            references = {
              adt = {
                enable = true,
              },
              enumVariant = {
                enable = true,
              },
              method = {
                enable = true,
              },
              trait = {
                enable = true,
              },
            },
          },
          -- Hover actions
          hover = {
            actions = {
              enable = true,
              implementations = {
                enable = true,
              },
              references = {
                enable = true,
              },
              run = {
                enable = true,
              },
            },
            documentation = {
              enable = true,
            },
          },
          -- Completion settings
          completion = {
            autoimport = {
              enable = true,
            },
            autoself = {
              enable = true,
            },
            callable = {
              snippets = "fill_arguments",
            },
            postfix = {
              enable = true,
            },
            privateEditable = {
              enable = false,
            },
          },
          -- Assist (code generation)
          assist = {
            importEnforceGranularity = true,
            importPrefix = "self",
            expressionFillDefault = "default",
          },
          files = {
            excludeDirs = {
              ".direnv",
              ".git",
              ".github",
              ".gitlab",
              "bin",
              "node_modules",
              "target",
              "venv",
              ".venv",
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    if LazyVim.has("mason.nvim") then
      local package_path = require("mason-registry").get_package("codelldb"):get_install_path()
      local codelldb = package_path .. "/extension/adapter/codelldb"
      local library_path = package_path .. "/extension/lldb/lib/liblldb.dylib"
      local uname = io.popen("uname"):read("*l")
      if uname == "Linux" then
        library_path = package_path .. "/extension/lldb/lib/liblldb.so"
      end
      opts.dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
      }
    end
    vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    if vim.fn.executable("rust-analyzer") == 0 then
      LazyVim.error(
        "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
        { title = "rustaceanvim" }
      )
    end
  end,
}
