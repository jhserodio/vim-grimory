-- Read-only Termux dependency report; no installs or clipboard writes.
local M = {}

local groups = {
  { "Editor / search", { "nvim", "git", "rg", "fd", "fzf" } },
  { "Native builders", { "clang", "clang++", "make", "cmake", "tree-sitter" } },
  { "LSP / languages", {
    "clangd", "rust-analyzer", "cargo", "node", "npm",
    "vtsls", "typescript-language-server", "gopls", "go",
    "lua-language-server", "bash-language-server",
  } },
  { "Formatters", { "stylua", "shfmt", "prettier", "clang-format",
    "rustfmt", "goimports", "gofmt" } },
  { "Debugger adapters", { "codelldb", "js-debug-adapter", "dlv" } },
  { "Android integration", {
    "termux-clipboard-set", "termux-clipboard-get", "termux-open-url",
  } },
}

function M.show()
  local version = vim.version()
  local lines = {
    "# Grimory Android Doctor",
    "",
    "Checks PATH presence only; does not prove binaries actually work.",
    "Missing optional tools do not prevent Neovim from starting.",
    "",
    string.format("Neovim: %d.%d.%d", version.major, version.minor, version.patch),
    "Termux PREFIX: " .. (vim.env.PREFIX or "(not set)"),
    "tmux: " .. (vim.env.TMUX and "active" or "inactive"),
    "Clipboard provider: " .. tostring(vim.g.clipboard or "(unset)"),
    "Clipboard option: " .. vim.o.clipboard,
    "",
  }
  for _, group in ipairs(groups) do
    lines[#lines + 1] = "## " .. group[1]
    for _, exe in ipairs(group[2]) do
      lines[#lines + 1] = (vim.fn.executable(exe) == 1 and "[OK] " or "[--] ") .. exe
    end
    lines[#lines + 1] = ""
  end
  lines[#lines + 1] = "Next: :checkhealth, :ConformInfo, :Telescope find_files"
  lines[#lines + 1] = "Test clipboard roundtrip and native DAP adapters separately."
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.cmd("botright 18split")
  vim.api.nvim_win_set_buf(0, buf)
  vim.bo[buf].filetype = "markdown"
end

function M.setup()
  vim.api.nvim_create_user_command("AndroidDoctor", M.show, {
    desc = "Inspect native Termux dependencies without changing anything",
  })
end

return M
