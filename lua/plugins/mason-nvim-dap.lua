return {
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = { "mason.nvim", "nvim-dap" },
  cmd = { "DapInstall", "DapUninstall" },
  opts = {
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_installation = true,

    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    handlers = {},

    -- You'll need to check that you have the required things installed
    -- online, please don't ask me how to install them :)
    ensure_installed = {
      -- Update this to ensure that you have the debuggers for the langs you want
    },
  },
  config = function(_, opts)
    local ok, mason_dap = pcall(require, "mason-nvim-dap")
    if ok then
      mason_dap.setup(opts)
    end
  end,
}
