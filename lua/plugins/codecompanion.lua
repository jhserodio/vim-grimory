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
      -- Build is the default OpenCode interaction.
      --
      interactions = {
        chat = {
          adapter = "opencode_build",
        },
      },

      --
      -- Two OpenCode ACP adapters.
      --
      -- We deliberately create separate Build and Plan adapters instead
      -- of switching the mode in an existing chat, because the current
      -- /acp_session_options picker path triggers:
      --
      --   attempt to yield across C-call boundary
      --
      -- in our Snacks/CodeCompanion setup.
      --
      adapters = {
        acp = {
          opencode_build = function()
            return require("codecompanion.adapters").extend("opencode", {
              name = "OpenCode Build",

              defaults = {
                timeout = 60000,

                session_config_options = {
                  mode = "build",
                },
              },
            })
          end,

          opencode_plan = function()
            return require("codecompanion.adapters").extend("opencode", {
              name = "OpenCode Plan",

              defaults = {
                timeout = 60000,

                session_config_options = {
                  mode = "plan",
                },
              },
            })
          end,
        },
      },

      display = {
        diff = {
          enabled = true,

          --
          -- Prefer the dedicated diff UI even for very small changes.
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
