return {
  "leoluz/nvim-dap-go",
  opts = {
    -- Delve configuration
    delve = {
      -- Path to delve executable (leave empty for auto-detect)
      path = "dlv",
      -- Time before delve command times out, in milliseconds
      initialize_timeout_sec = 20,
      -- Port to start delve debugger
      port = "${port}",
      -- Build arguments
      args = {},
      -- Additional dlv args
      detached = vim.fn.has("win32") == 0,
      -- Build flags for delve
      cwd = nil,
    },
    -- DAP configurations
    dap_configurations = {
      {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug test",
        request = "launch",
        mode = "test",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
      },
      {
        type = "go",
        name = "Attach to process",
        mode = "local",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
    },
  },
  config = function(_, opts)
    require("dap-go").setup(opts)
    
    -- Add keymaps for Go debugging
    local keymap = vim.keymap.set
    keymap("n", "<leader>dgt", function()
      require("dap-go").debug_test()
    end, { desc = "Debug Go Test" })
    
    keymap("n", "<leader>dgl", function()
      require("dap-go").debug_last_test()
    end, { desc = "Debug Last Go Test" })
  end,
}
