-- Use the Android browser; retain the original Markdown Preview plugin.
return {
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      if vim.fn.executable("termux-open-url") == 1 then
        vim.g.mkdp_browser = "termux-open-url"
      end
    end,
  },
}
