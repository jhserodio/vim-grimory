-- bootstrap lazy.nvim, LazyVim and the original Grimory plugins
require("config.lazy")

-- Keep clipboard commands and workflow automations.
require("config.clipboard")
require("config.workflow")

-- Read-only diagnostics for Termux dependencies.
require("android.doctor").setup()
