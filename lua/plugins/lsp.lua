-- Grimory: custom LSP configuration.
-- Native LSP management is delegated to LazyVim.
--
-- Neovim >= 0.11.3
-- mason.nvim >= 2.x
-- mason-lspconfig.nvim >= 2.x

local rust_diagnostics = vim.g.lazyvim_rust_diagnostics or "rust-analyzer"

return {
  "neovim/nvim-lspconfig",

  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
    },

    inlay_hints = {
      enabled = true,
      exclude = { "vue" },
    },

    servers = {
      -- General / Web
      astro = {},
      html = {},
      cssls = {},
      jsonls = {
        settings = {
          json = {
            format = { enable = true },
            validate = { enable = true },
          },
        },
      },
      marksman = {},
      prismals = {},

      -- Infrastructure
      terraformls = {},
      dockerls = {},
      docker_compose_language_service = {},

      -- Other languages
      elixirls = {},
      kotlin_language_server = {},
      zls = {},

      -- Java: managed by nvim-jdtls
      jdtls = {},

      -- Haskell: managed by haskell-tools.nvim
      hls = {
        enabled = false,
      },

      -- Rust: rustaceanvim owns rust-analyzer
      rust_analyzer = {
        enabled = false,
      },

      bacon_ls = {
        enabled = rust_diagnostics == "bacon-ls",
      },

      -- TypeScript: use VTSLS
      tsserver = { enabled = false },
      ts_ls = { enabled = false },
      tsc = { enabled = false },

      -- C / C++
      clangd = {
        keys = {
          {
            "<leader>ch",
            "<cmd>LspClangdSwitchSourceHeader<cr>",
            desc = "Switch Source/Header",
          },
        },

        root_markers = {
          "compile_commands.json",
          "compile_flags.txt",
          "Makefile",
          "configure.ac",
          "configure.in",
          "config.h.in",
          "meson.build",
          "meson_options.txt",
          "build.ninja",
          ".git",
        },

        capabilities = {
          offsetEncoding = { "utf-16" },
        },

        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },

        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      },

      -- Go
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,

            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },

            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },

            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },

            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            semanticTokens = true,

            directoryFilters = {
              "-.git",
              "-.vscode",
              "-.idea",
              "-.vscode-test",
              "-node_modules",
            },
          },
        },
      },
    },

    setup = {
      -- JDTLS has its own lifecycle.
      jdtls = function()
        return true
      end,
    },
  },
}
