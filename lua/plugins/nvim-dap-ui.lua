return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
      { "<leader>dE", function() require("dapui").eval(vim.fn.input("Expression: ")) end, desc = "Eval Expression" },
      { "<leader>dw", function() require("dapui").float_element("watches", { enter = true }) end, desc = "Watches" },
      { "<leader>ds", function() require("dapui").float_element("scopes", { enter = true }) end, desc = "Scopes" },
      { "<leader>dr", function() require("dapui").float_element("repl", { enter = true }) end, desc = "REPL" },
      { "<leader>dc", function() require("dapui").float_element("console", { enter = true }) end, desc = "Console" },
    },
    opts = {
      -- Enhanced layout configuration
      layouts = {
        {
          -- Left sidebar: scopes, breakpoints, stacks, watches
          elements = {
            { id = "scopes", size = 0.35 },
            { id = "breakpoints", size = 0.15 },
            { id = "stacks", size = 0.35 },
            { id = "watches", size = 0.15 },
          },
          size = 50,
          position = "left",
        },
        {
          -- Bottom panel: repl, console
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 12,
          position = "bottom",
        },
      },
      
      -- Controls configuration
      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "",
          terminate = "",
          disconnect = "",
        },
      },
      
      -- Floating window configuration
      floating = {
        max_height = 0.9,
        max_width = 0.9,
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      
      -- Icons
      icons = {
        expanded = "",
        collapsed = "",
        current_frame = "",
      },
      
      -- Mappings
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
      
      -- Render configuration
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
      
      -- Configure enhanced highlights
      vim.api.nvim_set_hl(0, "DapUIVariable", { link = "Normal" })
      vim.api.nvim_set_hl(0, "DapUIScope", { link = "Keyword" })
      vim.api.nvim_set_hl(0, "DapUIType", { link = "Type" })
      vim.api.nvim_set_hl(0, "DapUIModifiedValue", { link = "DiagnosticWarn" })
      vim.api.nvim_set_hl(0, "DapUIDecoration", { link = "Comment" })
      vim.api.nvim_set_hl(0, "DapUIThread", { link = "String" })
      vim.api.nvim_set_hl(0, "DapUIStoppedThread", { link = "DiagnosticInfo" })
      vim.api.nvim_set_hl(0, "DapUISource", { link = "Directory" })
      vim.api.nvim_set_hl(0, "DapUILineNumber", { link = "LineNr" })
      vim.api.nvim_set_hl(0, "DapUIFloatBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "DapUIWatchesEmpty", { link = "Comment" })
      vim.api.nvim_set_hl(0, "DapUIWatchesValue", { link = "String" })
      vim.api.nvim_set_hl(0, "DapUIWatchesError", { link = "DiagnosticError" })
      vim.api.nvim_set_hl(0, "DapUIBreakpointsPath", { link = "Directory" })
      vim.api.nvim_set_hl(0, "DapUIBreakpointsInfo", { link = "DiagnosticInfo" })
      vim.api.nvim_set_hl(0, "DapUIBreakpointsCurrentLine", { link = "CursorLine" })
    end,
  },
  
  -- Virtual text for DAP (show variable values inline)
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,
      
      -- Position of virtual text
      virt_text_pos = "eol",
      
      -- Customize virtual text
      display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == "inline" then
          return " = " .. variable.value
        else
          return variable.name .. " = " .. variable.value
        end
      end,
    },
  },
}
