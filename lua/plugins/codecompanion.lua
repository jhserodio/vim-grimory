-- OpenCode ACP is started only when a CodeCompanion command is invoked.
-- Pass Grimory's tracked OpenCode config to this process without modifying
-- OPENCODE_CONFIG globally for unrelated terminals or projects.

local opencode_config = vim.fn.stdpath("config") .. "/opencode.json"

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
          adapter = "opencode_build",
        },
      },

      adapters = {
        acp = {
          opencode_build = function()
            return require("codecompanion.adapters").extend("opencode", {
              name = "OpenCode Build",
              env = {
                OPENCODE_CONFIG = opencode_config,
              },
              defaults = {
                timeout = 180000,
                session_config_options = {
                  mode = "build",
                },
              },
            })
          end,

          opencode_plan = function()
            return require("codecompanion.adapters").extend("opencode", {
              name = "OpenCode Plan",
              env = {
                OPENCODE_CONFIG = opencode_config,
              },
              defaults = {
                timeout = 180000,
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
