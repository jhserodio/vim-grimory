-- Test coverage visualization
return {
  "andythigpen/nvim-coverage",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { 
    "Coverage", 
    "CoverageLoad", 
    "CoverageShow", 
    "CoverageHide", 
    "CoverageToggle", 
    "CoverageSummary",
    "CoverageClear",
  },
  keys = {
    { "<leader>tc", "<cmd>Coverage<cr>", desc = "Toggle Coverage" },
    { "<leader>tC", "<cmd>CoverageSummary<cr>", desc = "Coverage Summary" },
    { "<leader>tL", "<cmd>CoverageLoad<cr>", desc = "Load Coverage" },
  },
  opts = {
    auto_reload = true,
    auto_reload_timeout_ms = 500,
    
    -- Language-specific coverage file paths
    lang = {
      -- Go coverage (go test -coverprofile=coverage.out)
      go = {
        coverage_file = vim.fn.getcwd() .. "/coverage.out",
      },
      
      -- Rust coverage (cargo-llvm-cov)
      -- Install: cargo install cargo-llvm-cov
      -- Run: cargo llvm-cov --lcov --output-path coverage.lcov
      rust = {
        coverage_command = "cargo llvm-cov --lcov --output-path coverage.lcov",
        coverage_file = vim.fn.getcwd() .. "/coverage.lcov",
      },
      
      -- C/C++ coverage (gcov/lcov)
      -- Run: gcov *.gcda && lcov --capture --directory . --output-file coverage.info
      c = {
        coverage_file = vim.fn.getcwd() .. "/coverage.info",
      },
      cpp = {
        coverage_file = vim.fn.getcwd() .. "/coverage.info",
      },
      
      -- Java coverage (JaCoCo)
      -- Maven: mvn clean test jacoco:report
      -- Gradle: ./gradlew test jacocoTestReport
      java = {
        coverage_file = vim.fn.getcwd() .. "/target/site/jacoco/jacoco.xml",
      },
      
      -- Haskell coverage (hpc)
      -- stack test --coverage
      haskell = {
        coverage_file = vim.fn.getcwd() .. "/.hpc/index.html",
      },
      
      -- Julia coverage (Coverage.jl)
      julia = {
        coverage_file = vim.fn.getcwd() .. "/coverage/lcov.info",
      },
    },
    
    -- Coverage signs in gutter
    signs = {
      covered = { 
        hl = "CoverageCovered", 
        text = "▎",
        priority = 10,
      },
      uncovered = { 
        hl = "CoverageUncovered", 
        text = "▎",
        priority = 10,
      },
      partial = { 
        hl = "CoveragePartial", 
        text = "▎",
        priority = 10,
      },
    },
    
    -- Summary window configuration
    summary = {
      min_coverage = 80.0, -- Minimum coverage threshold (warn if below)
      width_percentage = 0.7,
      height_percentage = 0.7,
      borders = {
        topleft = "╭",
        topright = "╮",
        top = "─",
        left = "│",
        right = "│",
        botleft = "╰",
        botright = "╯",
        bot = "─",
      },
    },
    
    -- Highlights for coverage
    highlights = {
      covered = { fg = "#9ece6a" },   -- Green
      uncovered = { fg = "#f7768e" }, -- Red
      partial = { fg = "#e0af68" },   -- Yellow
    },
  },
  config = function(_, opts)
    require("coverage").setup(opts)
    
    -- Setup custom highlights
    vim.api.nvim_set_hl(0, "CoverageCovered", { fg = "#9ece6a", bg = "#2d3640" })
    vim.api.nvim_set_hl(0, "CoverageUncovered", { fg = "#f7768e", bg = "#3d2633" })
    vim.api.nvim_set_hl(0, "CoveragePartial", { fg = "#e0af68", bg = "#3d3626" })
  end,
}
