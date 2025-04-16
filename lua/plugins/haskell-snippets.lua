return {
  "mrcjkb/haskell-snippets.nvim",
  dependencies = { "L3MON4D3/LuaSnip" },
  ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  config = function()
    local haskell_snippets = require("haskell-snippets").all
    require("luasnip").add_snippets("haskell", haskell_snippets, { key = "haskell" })
  end,
}
