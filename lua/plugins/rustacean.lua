-- ============================================================================
-- Vim Grimory - Rust Development
--
-- Neovim: 0.11.x
-- rustaceanvim: v8.0.5
--
-- LSP: rust-analyzer (managed by rustaceanvim)
-- Diagnostics: rust-analyzer + Clippy
-- Formatting: rustfmt via conform.nvim
-- Debugging: CodeLLDB via nvim-dap
-- ============================================================================

local diagnostics = vim.g.lazyvim_rust_diagnostics or "rust-analyzer"

-- The quant-dev-roadmap exercises are compiled via development/config/rust/Cargo.toml.
-- Match that worktree so rust-analyzer does not treat each main.rs as a standalone crate.
local function quant_roadmap_root(filename)
  local root = vim.fs.root(filename, ".git")
  if root and vim.uv.fs_stat(root .. "/development/config/rust/Cargo.toml") then
    return root
  end
  return nil
end

local rustacean_opts = {
  server = {
    -- The shared Cargo manifest is not an ancestor of each exercise's main.rs.
    root_dir = function(filename, default)
      return quant_roadmap_root(filename) or default(filename)
    end,

    settings = function(root, default_settings)
      local settings = vim.deepcopy(default_settings or {})
      if root and vim.uv.fs_stat(root .. "/development/config/rust/Cargo.toml") then
        settings["rust-analyzer"] = settings["rust-analyzer"] or {}
        settings["rust-analyzer"].linkedProjects = {
          root .. "/development/config/rust/Cargo.toml",
        }
      end
      return settings
    end,


    -- ====================================================================
    -- Rust keymaps
    -- ====================================================================

    on_attach = function(_, bufnr)
      local function map(lhs, command, desc)
        vim.keymap.set("n", lhs, function()
          vim.cmd.RustLsp(command)
        end, {
          buffer = bufnr,
          silent = true,
          desc = desc,
        })
      end

      -- Code actions
      map("<leader>cR", "codeAction", "Rust Code Action")

      -- Rust tools
      map("<leader>rh", { "hover", "actions" }, "Hover Actions")
      map("<leader>re", "explainError", "Explain Error")
      map("<leader>rc", "openCargo", "Open Cargo.toml")
      map("<leader>rp", "parentModule", "Parent Module")

      -- Execution
      map("<leader>rr", "runnables", "Rust Runnables")
      map("<leader>rt", "testables", "Rust Testables")

      -- Debugging
      map("<leader>rD", "debuggables", "Rust Debuggables")

      -- Code generation / refactoring
      map("<leader>rS", "ssr", "Structural Search Replace")
      map("<leader>rE", "expandMacro", "Expand Macro")

      map("<leader>rm", { "moveItem", "up" }, "Move Item Up")
      map("<leader>rM", { "moveItem", "down" }, "Move Item Down")
    end,

    -- ====================================================================
    -- rust-analyzer
    -- ====================================================================

    default_settings = {
      ["rust-analyzer"] = {

        cargo = {
          buildScripts = {
            enable = true,
          },

          autoreload = true,
        },

        -- Modern rust-analyzer configuration.
        -- checkOnSave is a boolean, not a table.

        checkOnSave = diagnostics == "rust-analyzer",

        check = {
          command = "clippy",
          allTargets = true,
        },

        diagnostics = {
          enable = diagnostics == "rust-analyzer",
        },

        -- Procedural macros
        procMacro = {
          enable = true,
        },

        -- =================================================================
        -- Inlay hints
        -- =================================================================

        inlayHints = {
          chainingHints = {
            enable = true,
          },

          parameterHints = {
            enable = true,
          },

          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },

          closingBraceHints = {
            enable = true,
            minLines = 25,
          },

          lifetimeElisionHints = {
            enable = "never",
          },

          maxLength = 25,
        },

        -- =================================================================
        -- Workspace
        -- =================================================================

        files = {
          exclude = {
            ".direnv",
            ".git",
            ".jj",
            "node_modules",
            "target",
            "venv",
            ".venv",
          },

          watcher = "client",
        },
      },
    },
  },
}

return {
  "mrcjkb/rustaceanvim",

  -- v9 requires Neovim >= 0.12.
  tag = "v8.0.5",

  ft = { "rust" },

  -- rustaceanvim reads this global before loading its Rust ftplugin.
  init = function()
    vim.g.rustaceanvim = vim.tbl_deep_extend("force", vim.g.rustaceanvim or {}, rustacean_opts)

    if vim.fn.executable("rust-analyzer") == 0 then
      vim.notify("rust-analyzer was not found in PATH", vim.log.levels.ERROR, { title = "Grimory / Rust" })
    end
  end,
}
