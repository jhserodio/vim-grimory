-- ============================================================================
-- Vim Grimory - Local AI Agent
--
-- Backend: Ollama (Docker)
-- Agent model: Qwen2.5-Coder 7B
-- Suggestions: Minuet (configured separately)
--
-- No external API key required.
-- ============================================================================

return {
  "olimorris/codecompanion.nvim",

  version = "^19.0.0",

  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionCodeReview",
  },

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },

  opts = {
    adapters = {
      http = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = "http://127.0.0.1:11434",
            },

            schema = {
              num_ctx = {
                default = 16384,
              },

              keep_alive = {
                default = "5m",
              },
            },
          })
        end,
      },
    },

    interactions = {
      chat = {
        adapter = {
          name = "ollama",
          model = "qwen2.5-coder:7b",
        },

        tools = {
          opts = {
            -- Require approval for sensitive operations.
            approval_mode = "ask",
          },
        },

        opts = {
          context_management = {
            editing = {
              trigger = 10000,
            },

            compaction = {
              trigger = 13000,
            },
          },
        },
      },

      inline = {
        adapter = {
          name = "ollama",
          model = "qwen2.5-coder:7b",
        },
      },
    },
  },

  keys = {
    {
      "<leader>ac",
      "<cmd>CodeCompanionChat Toggle<cr>",
      mode = { "n", "v" },
      desc = "AI: Toggle Chat",
    },

    {
      "<leader>aa",
      "<cmd>CodeCompanionActions<cr>",
      mode = { "n", "v" },
      desc = "AI: Actions",
    },

    {
      "<leader>ae",
      "<cmd>CodeCompanionChat Add<cr>",
      mode = "v",
      desc = "AI: Add Selection",
    },
  },
}
