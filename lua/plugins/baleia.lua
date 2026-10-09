return {
  "m00qek/baleia.nvim",
  opts = {
    line_starts_at = 3,
  },
  config = function(_, opts)
    vim.g.conjure_baleia = require("baleia").setup(opts)

    vim.api.nvim_create_user_command("BaleiaColorize", function()
      vim.g.conjure_baleia.once(vim.api.nvim_get_current_buf())
    end, { bang = true })

    vim.api.nvim_create_user_command("BaleiaLogs", vim.g.conjure_baleia.logger.show, { bang = true })
  end,
}
