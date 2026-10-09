-- ============================================================================
-- Vim Grimory - Java / JDTLS
--
-- Neovim >= 0.11.3
-- Mason >= 2.x
--
-- Features:
--   - Eclipse JDT Language Server
--   - Lombok
--   - Blink.cmp / nvim-cmp
--   - Java Debug Adapter (DAP)
--   - JUnit / TestNG
--   - Refactoring and code generation
-- ============================================================================

local java_filetypes = { "java" }

-- Fallback markers in case the native JDTLS config is unavailable.
local root_markers = {
  "settings.gradle",
  "settings.gradle.kts",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "build.xml",
  "mvnw",
  "gradlew",
  ".git",
}

-- ============================================================================
-- Helpers
-- ============================================================================

local function get_capabilities()
  if LazyVim.has("blink.cmp") then
    return require("blink.cmp").get_lsp_capabilities()
  end

  if LazyVim.has("cmp-nvim-lsp") then
    return require("cmp_nvim_lsp").default_capabilities()
  end

  return nil
end

local function get_bundles(opts)
  local bundles = {}

  if not LazyVim.has("mason.nvim") then
    return bundles
  end

  if not opts.dap or not LazyVim.has("nvim-dap") then
    return bundles
  end

  local registry = require("mason-registry")

  -- Mason 2.x exposes package resources through $MASON/share.
  if registry.is_installed("java-debug-adapter") then
    vim.list_extend(
      bundles,
      vim.fn.glob(
        "$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar",
        false,
        true
      )
    )

    -- Java Test depends on Java Debug.
    if opts.test and registry.is_installed("java-test") then
      vim.list_extend(
        bundles,
        vim.fn.glob(
          "$MASON/share/java-test/*.jar",
          false,
          true
        )
      )
    end
  end

  return bundles
end

-- ============================================================================
-- Plugin
-- ============================================================================

return {
  "mfussenegger/nvim-jdtls",

  dependencies = {
    "folke/which-key.nvim",
  },

  ft = java_filetypes,

  -- ========================================================================
  -- Options
  -- ========================================================================

  opts = function()
    local cmd = { vim.fn.exepath("jdtls") }

    -- Lombok support (Mason 2.x).
    if LazyVim.has("mason.nvim") then
      local lombok_jar = vim.fn.expand(
        "$MASON/share/jdtls/lombok.jar"
      )

      if vim.fn.filereadable(lombok_jar) == 1 then
        table.insert(
          cmd,
          string.format("--jvm-arg=-javaagent:%s", lombok_jar)
        )
      end
    end

    -- Optional Eclipse formatter profile.
    -- Do not use IntelliJ formatter XML with JDTLS.
    local formatter = vim.fn.stdpath("config")
        .. "/lang-config/eclipse-java-google-style.xml"

    local format_opts = {
      enabled = true,
    }

    if vim.fn.filereadable(formatter) == 1 then
      format_opts.settings = {
        url = formatter,
        profile = "GoogleStyle",
      }
    end

    return {
      -- --------------------------------------------------------------------
      -- Project detection
      -- --------------------------------------------------------------------

      root_dir = function(path)
        local lsp_config = vim.lsp.config.jdtls

        local markers = lsp_config
            and lsp_config.root_markers
            or root_markers

        return vim.fs.root(path, markers)
      end,

      project_name = function(root_dir)
        return root_dir and vim.fs.basename(root_dir)
      end,

      -- --------------------------------------------------------------------
      -- Workspace
      -- --------------------------------------------------------------------

      jdtls_config_dir = function(project_name)
        return vim.fn.stdpath("cache")
            .. "/jdtls/"
            .. project_name
            .. "/config"
      end,

      jdtls_workspace_dir = function(project_name)
        return vim.fn.stdpath("cache")
            .. "/jdtls/"
            .. project_name
            .. "/workspace"
      end,

      -- --------------------------------------------------------------------
      -- Command
      -- --------------------------------------------------------------------

      cmd = cmd,

      full_cmd = function(opts)
        local fname = vim.api.nvim_buf_get_name(0)

        local root_dir = opts.root_dir(fname)
        local project_name = opts.project_name(root_dir)

        local full_cmd = vim.deepcopy(opts.cmd)

        if project_name then
          vim.list_extend(full_cmd, {
            "-configuration",
            opts.jdtls_config_dir(project_name),
            "-data",
            opts.jdtls_workspace_dir(project_name),
          })
        end

        return full_cmd
      end,

      -- --------------------------------------------------------------------
      -- Debugging / Testing
      -- --------------------------------------------------------------------

      dap = {
        hotcodereplace = "auto",
        config_overrides = {},
      },

      -- Disable automatic main-class scanning for better performance.
      -- Change to {} if you want generated main-class DAP configurations.
      dap_main = false,

      test = true,

      -- --------------------------------------------------------------------
      -- Java Settings
      -- --------------------------------------------------------------------

      settings = {
        java = {
          inlayHints = {
            parameterNames = {
              enabled = "all",
            },
          },

          codeGeneration = {
            toString = {
              template =
              "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },

            useBlocks = true,
          },

          configuration = {
            updateBuildConfiguration = "interactive",
            runtimes = {},
          },

          eclipse = {
            downloadSources = true,
          },

          implementationsCodeLens = {
            enabled = true,
          },

          referencesCodeLens = {
            enabled = true,
          },

          references = {
            includeDecompiledSources = true,
          },

          signatureHelp = {
            enabled = true,
          },

          format = format_opts,

          saveActions = {
            organizeImports = true,
          },

          completion = {
            favoriteStaticMembers = {
              "org.junit.jupiter.api.Assertions.*",
              "org.junit.Assert.*",
              "org.junit.Assume.*",
              "org.mockito.Mockito.*",
              "org.mockito.ArgumentMatchers.*",
              "org.mockito.Answers.*",
            },

            importOrder = {
              "java",
              "javax",
              "com",
              "org",
            },
          },

          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
        },
      },
    }
  end,

  -- ========================================================================
  -- Configuration
  -- ========================================================================

  config = function(_, opts)
    local bundles = get_bundles(opts)

    local group = vim.api.nvim_create_augroup(
      "GrimoryJdtls",
      { clear = true }
    )

    -- ----------------------------------------------------------------------
    -- Start or attach JDTLS
    -- ----------------------------------------------------------------------

    local function attach_jdtls()
      local fname = vim.api.nvim_buf_get_name(0)

      if fname == "" then
        return
      end

      local root_dir = opts.root_dir(fname)

      if not root_dir then
        return
      end

      if opts.cmd[1] == "" then
        vim.notify(
          "JDTLS executable not found. Check Mason installation.",
          vim.log.levels.WARN
        )
        return
      end

      local config = {
        cmd = opts.full_cmd(opts),

        root_dir = root_dir,

        init_options = {
          bundles = bundles,
        },

        settings = opts.settings,

        capabilities = get_capabilities(),
      }

      -- Optional user-level JDTLS overrides.
      if type(opts.jdtls) == "function" then
        config = opts.jdtls(config) or config
      elseif type(opts.jdtls) == "table" then
        config = vim.tbl_deep_extend(
          "force",
          config,
          opts.jdtls
        )
      end

      -- Reuse an existing server when the project root matches.
      require("jdtls").start_or_attach(config)
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = java_filetypes,
      callback = attach_jdtls,
    })

    -- ----------------------------------------------------------------------
    -- LSP Attach: Keymaps / Debug / Tests
    -- ----------------------------------------------------------------------

    vim.api.nvim_create_autocmd("LspAttach", {
      group = group,

      callback = function(args)
        local client = vim.lsp.get_client_by_id(
          args.data.client_id
        )

        if not client or client.name ~= "jdtls" then
          return
        end

        local jdtls = require("jdtls")
        local wk = require("which-key")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = args.buf,
            silent = true,
            desc = desc,
          })
        end

        -- ------------------------------------------------------------------
        -- Refactoring
        -- ------------------------------------------------------------------

        wk.add({
          {
            "<leader>cx",
            group = "extract",
            buffer = args.buf,
            mode = { "n", "x" },
          },
        })

        map(
          "n",
          "<leader>cxv",
          jdtls.extract_variable_all,
          "Extract Variable"
        )

        map(
          "n",
          "<leader>cxc",
          jdtls.extract_constant,
          "Extract Constant"
        )

        map(
          "n",
          "<leader>cgs",
          jdtls.super_implementation,
          "Goto Super"
        )

        map(
          "n",
          "<leader>cgS",
          require("jdtls.tests").goto_subjects,
          "Goto Subjects"
        )

        map(
          "n",
          "<leader>co",
          jdtls.organize_imports,
          "Organize Imports"
        )

        -- Visual mode

        map(
          "x",
          "<leader>cxm",
          [[<Esc><Cmd>lua require("jdtls").extract_method(true)<CR>]],
          "Extract Method"
        )

        map(
          "x",
          "<leader>cxv",
          [[<Esc><Cmd>lua require("jdtls").extract_variable_all(true)<CR>]],
          "Extract Variable"
        )

        map(
          "x",
          "<leader>cxc",
          [[<Esc><Cmd>lua require("jdtls").extract_constant(true)<CR>]],
          "Extract Constant"
        )

        -- ------------------------------------------------------------------
        -- DAP / Java Test
        -- ------------------------------------------------------------------

        if LazyVim.has("mason.nvim") then
          local registry = require("mason-registry")

          if
              opts.dap
              and LazyVim.has("nvim-dap")
              and registry.is_installed("java-debug-adapter")
          then
            jdtls.setup_dap(opts.dap)

            if opts.dap_main then
              require("jdtls.dap")
                  .setup_dap_main_class_configs(opts.dap_main)
            end

            if opts.test and registry.is_installed("java-test") then
              local jdtls_dap = require("jdtls.dap")

              wk.add({
                {
                  "<leader>t",
                  group = "test",
                  buffer = args.buf,
                },
              })

              map("n", "<leader>tt", function()
                jdtls_dap.test_class({
                  config_overrides =
                      type(opts.test) ~= "boolean"
                      and opts.test.config_overrides
                      or nil,
                })
              end, "Run Class Tests")

              map("n", "<leader>tr", function()
                jdtls_dap.test_nearest_method({
                  config_overrides =
                      type(opts.test) ~= "boolean"
                      and opts.test.config_overrides
                      or nil,
                })
              end, "Run Nearest Test")

              map(
                "n",
                "<leader>tT",
                jdtls_dap.pick_test,
                "Pick Java Test"
              )
            end
          end
        end

        -- Optional custom callback.
        if opts.on_attach then
          opts.on_attach(args)
        end
      end,
    })

    -- The first FileType event already happened when lazy.nvim
    -- loaded this plugin. Attach explicitly to the first Java buffer.
    attach_jdtls()
  end,
}
