-- Language-specific snippets for main languages
return {
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    opts = function(_, opts)
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local sn = ls.snippet_node

      -- Helper function to get current year
      local function get_year()
        return os.date("%Y")
      end

      -- Helper function to get filename
      local function get_filename()
        return vim.fn.expand("%:t:r")
      end

      -- Rust snippets
      ls.add_snippets("rust", {
        -- Test function
        s("test", {
          t({ "#[test]", "fn " }),
          i(1, "test_name"),
          t({ "() {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
        -- Async test
        s("atest", {
          t({ "#[tokio::test]", "async fn " }),
          i(1, "test_name"),
          t({ "() {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
        -- Result return type
        s("res", {
          t("Result<"),
          i(1, "T"),
          t(", "),
          c(2, { t("Box<dyn Error>"), t("anyhow::Error"), i(nil, "Error") }),
          t(">"),
        }),
        -- Derive common traits
        s("derive", {
          t("#[derive(Debug, Clone"),
          c(1, { t(""), t(", PartialEq"), t(", Eq"), t(", PartialEq, Eq, Hash") }),
          t(")]"),
        }),
        -- Main function
        s("main", {
          t({ "fn main() {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
        -- Impl block
        s("impl", {
          t("impl "),
          i(1, "Type"),
          t({ " {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
      })

      -- Go snippets
      ls.add_snippets("go", {
        -- Test function
        s("test", {
          t("func Test"),
          i(1, "Name"),
          t({ "(t *testing.T) {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
        -- Error check
        s("iferr", {
          t({ "if err != nil {", "    " }),
          c(1, {
            t("return err"),
            sn(nil, { t("return "), i(1), t(", err") }),
            sn(nil, { t("t.Fatal(err)") }),
            sn(nil, { t("log.Fatal(err)") }),
          }),
          t({ "", "}" }),
        }),
        -- HTTP handler
        s("handler", {
          t("func "),
          i(1, "Handler"),
          t({ "(w http.ResponseWriter, r *http.Request) {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
        -- Goroutine
        s("go", {
          t("go func() {"),
          t({ "", "    " }),
          i(0),
          t({ "", "}()" }),
        }),
        -- Main function
        s("main", {
          t({ 'package main', '', 'func main() {', '    ' }),
          i(0),
          t({ '', '}' }),
        }),
      })

      -- Haskell snippets
      ls.add_snippets("haskell", {
        -- Module header
        s("mod", {
          t("module "),
          f(get_filename),
          t({ "", "  ( " }),
          i(1, "exports"),
          t({ "", "  ) where", "", "" }),
          i(0),
        }),
        -- Type signature
        s("sig", {
          i(1, "function"),
          t(" :: "),
          i(2, "Type"),
          t({ "", "" }),
          f(function(args)
            return args[1][1]
          end, { 1 }),
          t(" "),
          i(0),
        }),
        -- Data type
        s("data", {
          t("data "),
          i(1, "Type"),
          t(" = "),
          i(2, "Constructor"),
          i(0),
        }),
        -- QuickCheck property
        s("prop", {
          t("prop_"),
          i(1, "name"),
          t(" :: "),
          i(2, "Property"),
          t({ "", "prop_" }),
          f(function(args)
            return args[1][1]
          end, { 1 }),
          t({ " = ", "  " }),
          i(0),
        }),
      })

      -- Java snippets
      ls.add_snippets("java", {
        -- Test method
        s("test", {
          t({ "@Test", "public void test" }),
          i(1, "Name"),
          t({ "() {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
        -- Main method
        s("main", {
          t({ "public static void main(String[] args) {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
        -- Class
        s("class", {
          t("public class "),
          f(get_filename),
          t({ " {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
        -- Constructor
        s("ctor", {
          t("public "),
          f(get_filename),
          t("("),
          i(1),
          t({ ") {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
      })

      -- C/C++ snippets
      ls.add_snippets("cpp", {
        -- Header guard
        s("guard", {
          t("#ifndef "),
          f(function()
            return vim.fn.expand("%:t:r"):upper() .. "_H"
          end),
          t({ "", "#define " }),
          f(function()
            return vim.fn.expand("%:t:r"):upper() .. "_H"
          end),
          t({ "", "", "" }),
          i(0),
          t({ "", "", "#endif // " }),
          f(function()
            return vim.fn.expand("%:t:r"):upper() .. "_H"
          end),
        }),
        -- Test case
        s("test", {
          t("TEST("),
          i(1, "TestSuite"),
          t(", "),
          i(2, "TestName"),
          t({ ") {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
        -- Namespace
        s("ns", {
          t("namespace "),
          i(1, "name"),
          t({ " {", "", "" }),
          i(0),
          t({ "", "", "} // namespace " }),
          f(function(args)
            return args[1][1]
          end, { 1 }),
        }),
        -- Class
        s("class", {
          t("class "),
          i(1, "Name"),
          t({ " {", "public:", "    " }),
          i(0),
          t({ "", "};" }),
        }),
      })

      -- Julia snippets
      ls.add_snippets("julia", {
        -- Test set
        s("testset", {
          t('@testset "'),
          i(1, "description"),
          t({ '" begin', '    ' }),
          i(0),
          t({ '', 'end' }),
        }),
        -- Function
        s("fn", {
          t("function "),
          i(1, "name"),
          t("("),
          i(2, "args"),
          t({ ")", "    " }),
          i(0),
          t({ "", "end" }),
        }),
        -- Module
        s("mod", {
          t("module "),
          i(1, "Name"),
          t({ "", "", "" }),
          i(0),
          t({ "", "", "end # module" }),
        }),
        -- Type definition
        s("type", {
          t("struct "),
          i(1, "Name"),
          t({ "", "    " }),
          i(0),
          t({ "", "end" }),
        }),
      })

      return opts
    end,
  },
}
