return {
  "nvim-neotest/neotest",
  optional = true,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "fredrikaverpil/neotest-golang",
    "rouge8/neotest-rust",
    "mrcjkb/neotest-haskell",
    "rcasia/neotest-java",
    "alfaix/neotest-gtest", -- C/C++ via Google Test
  },
  opts = {
    adapters = {
      -- Rust (usando neotest-rust em vez de rustaceanvim.neotest)
      ["neotest-rust"] = {
        args = { "--no-capture" },
        dap_adapter = "codelldb",
      },
      -- Zig
      ["neotest-zig"] = {},
      -- Haskell
      ["neotest-haskell"] = {
        build_tools = { "stack", "cabal" },
      },
      -- Elixir
      ["neotest-elixir"] = {},
      -- Go
      ["neotest-golang"] = {
        go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
        dap_go_enabled = true, -- requires leoluz/nvim-dap-go
      },
      -- Java
      ["neotest-java"] = {
        ignore_wrapper = false,
      },
      -- C/C++ Google Test
      ["neotest-gtest"] = {},
    },
    -- Enhanced status configuration
    status = { 
      virtual_text = true,
      signs = true,
    },
    -- Enhanced output configuration
    output = { 
      open_on_run = "short",
      enabled = true,
    },
    -- Enhanced icons
    icons = {
      passed = "",
      running = "",
      failed = "",
      skipped = "",
      unknown = "",
      running_animated = vim.tbl_map(function(s)
        return s .. " "
      end, { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }),
    },
    -- Floating window configuration
    floating = {
      border = "rounded",
      max_height = 0.6,
      max_width = 0.6,
    },
    -- Diagnostic configuration
    diagnostic = {
      enabled = true,
      severity = vim.diagnostic.severity.ERROR,
    },
    -- Summary window configuration
    summary = {
      enabled = true,
      animated = true,
      follow = true,
      expand_errors = true,
      mappings = {
        attach = "a",
        clear_marked = "M",
        clear_target = "T",
        debug = "d",
        debug_marked = "D",
        expand = { "<CR>", "<2-LeftMouse>" },
        expand_all = "e",
        jumpto = "i",
        mark = "m",
        next_failed = "J",
        output = "o",
        prev_failed = "K",
        run = "r",
        run_marked = "R",
        short = "O",
        stop = "u",
        target = "t",
        watch = "w",
      },
    },
    -- Watch configuration
    watch = {
      enabled = true,
      symbol_queries = {
        go = [[((function_declaration name: (identifier) @name))((method_declaration name: (field_identifier) @name))]],
        rust = [[((function_item name: (identifier) @name))((impl_item name: (identifier) @name))]],
      },
    },
    quickfix = {
      open = function()
        if LazyVim.has("trouble.nvim") then
          require("trouble").toggle({ mode = "quickfix", focus = false })
        else
          vim.cmd("copen")
        end
      end,
    },
  },
  config = function(_, opts)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          -- Replace newline and tab characters with space for more compact diagnostics
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)

    if LazyVim.has("trouble.nvim") then
      opts.consumers = opts.consumers or {}
      -- Refresh and auto close trouble after running tests
      ---@type neotest.Consumer
      opts.consumers.trouble = function(client)
        client.listeners.results = function(adapter_id, results, partial)
          if partial then
            return
          end
          local tree = assert(client:get_position(nil, { adapter = adapter_id }))

          local failed = 0
          for pos_id, result in pairs(results) do
            if result.status == "failed" and tree:get_key(pos_id) then
              failed = failed + 1
            end
          end
          vim.schedule(function()
            local trouble = require("trouble")
            local windows = vim.api.nvim_list_wins()
            local trouble_open = false
            for _, win in ipairs(windows) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == "trouble" then
                trouble_open = true
                break
              end
            end
            if trouble_open then
              trouble.refresh()
              if failed == 0 then
                trouble.close()
              end
            end
          end)
          return {}
        end
      end
    end

    if opts.adapters then
      local adapters = {}
      for name, config in pairs(opts.adapters or {}) do
        if type(name) == "number" then
          if type(config) == "string" then
            config = require(config)
          end
          adapters[#adapters + 1] = config
        elseif config ~= false then
          local adapter = require(name)
          if type(config) == "table" and not vim.tbl_isempty(config) then
            local meta = getmetatable(adapter)
            if adapter.setup then
              adapter.setup(config)
            elseif adapter.adapter then
              adapter.adapter(config)
              adapter = adapter.adapter
            elseif meta and meta.__call then
              adapter = adapter(config)
            else
              error("Adapter " .. name .. " does not support setup")
            end
          end
          adapters[#adapters + 1] = adapter
        end
      end
      opts.adapters = adapters
    end

    require("neotest").setup(opts)
  end,
  -- stylua: ignore
  keys = {
    {"<leader>t", "", desc = "+test"},
    { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
    { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
    { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch (Neotest)" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest (Neotest)" },
  },
}

