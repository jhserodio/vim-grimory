-- ============================================================================
-- Vim Grimory - Debugging
--
-- Core lifecycle and keymaps: LazyVim dap.core
-- Rust: rustaceanvim
-- C/C++: CodeLLDB
-- Go: nvim-dap-go
-- Node.js: js-debug-adapter
-- ============================================================================

return {
  "mfussenegger/nvim-dap",

  opts = function()
    local dap = require("dap")

    -- ======================================================================
    -- CodeLLDB
    -- ======================================================================

    dap.adapters.codelldb = {
      type = "server",
      host = "127.0.0.1",
      port = "${port}",

      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      },
    }

    local cpp_configs = {
      {
        name = "Launch Executable (CodeLLDB)",
        type = "codelldb",
        request = "launch",

        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,

        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },

      {
        name = "Attach to Process (CodeLLDB)",
        type = "codelldb",
        request = "attach",

        pid = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }

    for _, ft in ipairs({
      "c",
      "cpp",
      "objc",
      "objcpp",
    }) do
      if not dap.configurations[ft] then
        dap.configurations[ft] = vim.deepcopy(cpp_configs)
      end
    end

    -- ======================================================================
    -- Node.js / JavaScript
    -- ======================================================================

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "127.0.0.1",
      port = "${port}",

      executable = {
        command = "js-debug-adapter",
        args = { "${port}" },
      },
    }

    local node_configs = {
      {
        name = "Launch Node.js",
        type = "pwa-node",
        request = "launch",

        program = "${file}",
        cwd = "${workspaceFolder}",

        sourceMaps = true,

        skipFiles = {
          "<node_internals>/**",
        },
      },

      {
        name = "Attach to Node.js",
        type = "pwa-node",
        request = "attach",

        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",

        sourceMaps = true,

        skipFiles = {
          "<node_internals>/**",
        },
      },
    }

    if not dap.configurations.javascript then
      dap.configurations.javascript = vim.deepcopy(node_configs)
    end

    -- TypeScript may require a project-specific runtime
    -- (tsx, ts-node, compiled JS, etc.).
    -- Provide Attach as a common starting point.

    if not dap.configurations.typescript then
      dap.configurations.typescript = {
        vim.deepcopy(node_configs[2]),
      }
    end
  end,
}
