-- ============================================================================
-- Vim Grimory - Testing
--
-- Core: LazyVim test.core
-- Runner integration: Neotest
-- Debugging: nvim-dap (configured in step 05)
--
-- Do not call require("neotest").setup() manually.
-- ============================================================================

return {
  "nvim-neotest/neotest",

  optional = true,

  dependencies = {
    "nvim-neotest/nvim-nio",

    -- JavaScript / TypeScript / React
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",

    -- Rust
    "rouge8/neotest-rust",

    -- Go
    "fredrikaverpil/neotest-golang",

    -- Haskell
    "mrcjkb/neotest-haskell",

    -- Java
    "rcasia/neotest-java",

    -- C/C++
    "alfaix/neotest-gtest",

    -- Zig
    "lawrence-laz/neotest-zig",

    -- Elixir
    "jfpedroza/neotest-elixir",
  },

  opts = {
    adapters = {
      -- ================================================================
      -- JavaScript / TypeScript
      -- ================================================================

      -- Uses the Jest installation belonging to the project.
      -- Keep automatic command and config discovery for now.
      ["neotest-jest"] = {},

      -- Vitest / Vite / React
      ["neotest-vitest"] = {
        filter_dir = function(name)
          return name ~= "node_modules" and name ~= "dist" and name ~= "coverage" and name ~= ".git"
        end,
      },

      -- ================================================================
      -- Rust
      -- ================================================================

      -- Preserve the existing neotest-rust adapter.
      -- Do not additionally enable rustaceanvim.neotest.

      ["neotest-rust"] = {
        args = { "--no-capture" },
        dap_adapter = "codelldb",
      },

      -- ================================================================
      -- Go
      -- ================================================================

      ["neotest-golang"] = {
        go_test_args = {
          "-v",
          "-race",
          "-count=1",
          "-timeout=60s",
        },

        dap_go_enabled = true,
      },

      -- ================================================================
      -- Other languages
      -- ================================================================

      ["neotest-haskell"] = {
        build_tools = {
          "stack",
          "cabal",
        },
      },

      ["neotest-java"] = {
        ignore_wrapper = false,
      },

      ["neotest-gtest"] = {},

      ["neotest-zig"] = {},

      ["neotest-elixir"] = {},
    },

    -- ================================================================
    -- Presentation
    -- ================================================================

    floating = {
      border = "rounded",
      max_height = 0.6,
      max_width = 0.7,
    },
  },
}
