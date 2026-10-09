-- ============================================================================
-- Vim Grimory - Mason DAP integration
--
-- Package installation: plugins/mason.lua
-- Adapter configuration: language-specific plugins
--
-- LazyVim dap.core calls mason-nvim-dap.setup().
-- ============================================================================

return {
  "jay-babu/mason-nvim-dap.nvim",

  opts = function(_, opts)
    -- All required packages are installed by Mason's main configuration.
    opts.automatic_installation = false
    opts.ensure_installed = {}

    -- Preserve automatic handlers for other installed adapters.
    opts.handlers = opts.handlers or {}

    -- These adapters are already configured elsewhere in Grimory.
    -- Prevent mason-nvim-dap from overwriting those configurations.
    opts.handlers.codelldb = function() end
    opts.handlers.js = function() end
    opts.handlers.delve = function() end
  end,
}
