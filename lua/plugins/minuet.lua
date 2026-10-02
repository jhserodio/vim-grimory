-- ============================================================================
-- Vim Grimory - Local AI Suggestions
--
-- Provider: Ollama (Docker)
-- Model: Qwen2.5-Coder 1.5B Base
-- Frontend: Virtual Text (Ghost Text)
--
-- Blink.cmp remains responsible for conventional LSP autocomplete.
-- ============================================================================

return {
  "milanglacier/minuet-ai.nvim",

  -- Register :Minuet immediately, rather than waiting for InsertEnter.
  lazy = false,

  opts = {
    -- ================================================================
    -- Provider
    -- ================================================================

    provider = "openai_fim_compatible",

    -- One request per completion cycle to reduce local GPU usage.
    n_completions = 1,

    -- Measured in characters, not tokens.
    -- Start small and increase after validating latency.
    context_window = 768,

    -- Request control.
    throttle = 1000,
    debounce = 400,
    request_timeout = 8,

    -- ================================================================
    -- Ollama
    -- ================================================================

    provider_options = {
      openai_fim_compatible = {
        name = "Grimory Ollama",

        -- Ollama does not require an API key.
        -- Minuet expects a non-nil value for the Authorization header.
        api_key = function()
          return "ollama"
        end,

        end_point = "http://127.0.0.1:11434/v1/completions",

        -- Dedicated lightweight model for code suggestions.
        model = "qwen2.5-coder:1.5b-base",

        optional = {
          max_tokens = 96,
          temperature = 0.2,
          top_p = 0.9,
        },
      },
    },

    -- ================================================================
    -- Virtual Text / Ghost Text
    -- ================================================================

    virtualtext = {
      auto_trigger_ft = {
        "rust",
        "c",
        "cpp",
        "lua",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "astro",
        "html",
        "css",
      },

      -- Avoid competing visually with the Blink.cmp completion menu.
      show_on_completion_menu = false,

      keymap = {
        -- Accept the entire suggestion.
        accept = "<A-A>",

        -- Accept only the next line.
        accept_line = "<A-a>",

        -- Request / cycle through suggestions.
        next = "<A-]>",
        prev = "<A-[>",

        -- Dismiss the suggestion.
        dismiss = "<A-e>",
      },
    },
  },

  config = function(_, opts)
    require("minuet").setup(opts)
  end,
}
