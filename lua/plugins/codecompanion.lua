return {
  {
    "olimorris/codecompanion.nvim",

    version = "^19.0.0",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },

    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCLI",
    },

    opts = {
      --
      -- OpenCode is the agent runtime.
      --
      -- CodeCompanion talks to:
      --
      --   opencode acp
      --
      -- OpenCode itself decides which model/provider to use from
      -- opencode.json, currently:
      --
      --   ollama/qwen3.5:9b
      --
      interactions = {
        chat = {
          adapter = "opencode",
        },
      },

      --
      -- Extend the built-in OpenCode ACP adapter.
      --
      -- The default ACP timeout is 20 seconds. Give the local
      -- process more room for startup / initialization.
      --
      adapters = {
        acp = {
          extend = {
            opencode = {
              defaults = {
                timeout = 60000,
              },
            },
          },
        },
      },

      display = {
        chat = {
          window = {
            layout = "vertical",
            width = 0.40,
          },
        },
      },
    },
  },
}
