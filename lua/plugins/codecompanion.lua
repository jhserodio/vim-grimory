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
      interactions = {
        chat = {
          adapter = "opencode",
        },
      },

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
        diff = {
          enabled = true,

          --
          -- Force even tiny ACP edits out of the chat body
          -- and into the dedicated diff UI.
          --
          threshold_for_chat = 0,

          window = {
            width = function()
              return math.min(120, vim.o.columns - 10)
            end,

            height = function()
              return vim.o.lines - 4
            end,

            opts = {
              number = true,
              relativenumber = false,
            },
          },

          word_highlights = {
            additions = true,
            deletions = true,
          },
        },

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
