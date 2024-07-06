return {
  "nvim-neotest/neotest",
  optional = true,
  dependencies = {
    "jfpedroza/neotest-elixir",
    "mrcjkb/neotest-haskell",
    "nvim-neotest/neotest-go",
  },
  opts = function(_, opts)
    opts.adapters = opts.adapters or {}
    vim.list_extend(opts.adapters, {
      require("rustaceanvim.neotest"),
      require("rustaceanvim.neotest"),
      ["neotest-elixir"] = {},
    })
  end,
}
