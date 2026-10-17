-- Local AI completion (explicitly on demand).
-- Qwen3.8 is a chat model, so use the chat completions endpoint rather
-- than the FIM endpoint intended for Qwen2.5-Coder Base.
-- Set GRIMORY_AI_MODEL to override the Ollama tag for local experiments.

local model = vim.env.GRIMORY_AI_MODEL
if not model or model == "" then
  model = "qwen3.8:27b"
end

return {
  "milanglacier/minuet-ai.nvim",

  -- No model requests, key mappings or Minuet setup during startup.
  lazy = true,
  cmd = { "Minuet" },
  keys = {
    {
      "<A-]>",
      function()
        require("minuet.virtualtext").action.next()
      end,
      mode = "i",
      desc = "AI: request one completion",
    },
  },

  opts = {
    provider = "openai_compatible",
    n_completions = 1,
    context_window = 768,
    throttle = 1000,
    debounce = 400,

    -- A larger local reasoning model may have a substantial cold-start delay.
    request_timeout = 120,

    provider_options = {
      openai_compatible = {
        name = "Grimory Ollama (manual)",
        api_key = function()
          return "ollama"
        end,
        end_point = "http://127.0.0.1:11434/v1/chat/completions",
        model = model,
        stream = false,
        optional = {
          max_tokens = 96,
          temperature = 0.2,
        },
      },
    },

    virtualtext = {
      -- Critical: no automatic AI completions on InsertEnter or typing.
      auto_trigger_ft = {},
      show_on_completion_menu = false,
      keymap = {
        accept = "<A-A>",
        accept_line = "<A-a>",
        next = "<A-]>",
        prev = "<A-[>",
        dismiss = "<A-e>",
      },
    },
  },

  config = function(_, opts)
    require("minuet").setup(opts)
  end,
}
