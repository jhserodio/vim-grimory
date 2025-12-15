return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        julials = {
          settings = {
            julia = {
              -- SymbolServer cache configuration
              symbolCacheDownload = true,
              -- Linting
              lint = {
                run = true,
                missingrefs = "all",
                iter = true,
                lazy = true,
                modname = true,
                pirates = true,
                useoffuncargs = true,
                call = true,
                constif = true,
                typeparam = true,
              },
              -- Format
              format = {
                indent = 4,
                calls = true,
              },
              -- Runtime paths
              runtimeCompletions = true,
              useRevise = true,
              -- Execution environment
              executablePath = "",
              -- Performance
              completionmode = "qualify",
            },
          },
        },
      },
    },
  },
}
