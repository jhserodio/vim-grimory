-- ============================================================================
-- Vim Grimory - Debugger UI
--
-- LazyVim dap.core manages:
--   dapui.setup()
--   event_initialized
--   event_terminated
--   event_exited
-- ============================================================================

return {
  {
    "rcarriga/nvim-dap-ui",

    keys = {
      {
        "<leader>dW",
        function()
          require("dapui").float_element("watches", { enter = true })
        end,
        desc = "Floating Watches",
      },

      {
        "<leader>dS",
        function()
          require("dapui").float_element("scopes", { enter = true })
        end,
        desc = "Floating Scopes",
      },

      {
        "<leader>dR",
        function()
          require("dapui").float_element("repl", { enter = true })
        end,
        desc = "Floating REPL",
      },

      {
        "<leader>dL",
        function()
          require("dapui").float_element("console", { enter = true })
        end,
        desc = "Floating Console",
      },
    },

    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.35 },
            { id = "breakpoints", size = 0.15 },
            { id = "stacks", size = 0.35 },
            { id = "watches", size = 0.15 },
          },

          size = 42,
          position = "left",
        },

        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },

          size = 12,
          position = "bottom",
        },
      },

      floating = {
        max_height = 0.9,
        max_width = 0.9,
        border = "rounded",

        mappings = {
          close = { "q", "<Esc>" },
        },
      },

      render = {
        indent = 1,
        max_value_lines = 100,
      },
    },
  },

  {
    "theHamsta/nvim-dap-virtual-text",

    opts = {
      enabled = true,

      highlight_changed_variables = true,
      highlight_new_as_changed = false,

      show_stop_reason = true,

      only_first_definition = true,
      all_references = false,

      clear_on_continue = false,

      virt_text_pos = "eol",
    },
  },
}
