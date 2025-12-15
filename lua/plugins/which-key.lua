return {
  "folke/which-key.nvim",
  opts = {
    preset = "modern",
    spec = {
      { "<BS>", desc = "Decrement Selection", mode = "x" },
      { "<c-space>", desc = "Increment Selection", mode = { "x", "n" } },
      -- Enhanced group descriptions with icons
      { "<leader>a", group = "ai", icon = "󰚩" },
      { "<leader>b", group = "buffer", icon = "" },
      { "<leader>c", group = "code", icon = "" },
      { "<leader>d", group = "debug", icon = "" },
      { "<leader>f", group = "file/find", icon = "" },
      { "<leader>g", group = "git", icon = "" },
      { "<leader>gh", group = "hunks", icon = "" },
      { "<leader>q", group = "quit/session", icon = "" },
      { "<leader>s", group = "search", icon = "" },
      { "<leader>t", group = "test", icon = "󰙨" },
      { "<leader>u", group = "ui", icon = "" },
      { "<leader>w", group = "windows", icon = "" },
      { "<leader>x", group = "diagnostics/quickfix", icon = "󱖫" },
      { "[", group = "prev", icon = "" },
      { "]", group = "next", icon = "" },
      { "g", group = "goto", icon = "" },
      { "z", group = "fold", icon = "" },
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    layout = {
      spacing = 3,
      align = "left",
    },
  },
}
