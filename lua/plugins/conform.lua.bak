-- Grimory: project-aware formatting with LazyVim + conform.nvim.
-- Do not redefine the plugin's config() or call conform.setup() here.

local project_configs = {
  "deno.json",
  "deno.jsonc",
  "biome.json",
  "biome.jsonc",
  ".biome.json",
  ".biome.jsonc",
  "dprint.json",
  "dprint.jsonc",
  ".dprint.json",
  ".dprint.jsonc",
}

local config_to_formatter = {
  ["deno.json"] = "deno_fmt",
  ["deno.jsonc"] = "deno_fmt",
  ["biome.json"] = "biome",
  ["biome.jsonc"] = "biome",
  [".biome.json"] = "biome",
  [".biome.jsonc"] = "biome",
  ["dprint.json"] = "dprint",
  ["dprint.jsonc"] = "dprint",
  [".dprint.json"] = "dprint",
  [".dprint.jsonc"] = "dprint",
}

local function configured_formatter(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)

  if filename == "" then
    return nil
  end

  local configs = vim.fs.find(project_configs, {
    path = vim.fs.dirname(filename),
    upward = true,
    type = "file",
  })

  if #configs == 0 then
    return nil
  end

  return config_to_formatter[vim.fs.basename(configs[1])]
end

-- Select project formatter first; fall back to available Prettier binary.
local function project_formatter(allowed)
  return function(bufnr)
    local selected = configured_formatter(bufnr)
    local formatters = {}

    if selected and allowed[selected] then
      formatters[#formatters + 1] = selected
    end

    formatters[#formatters + 1] = "prettierd"
    formatters[#formatters + 1] = "prettier"
    formatters.stop_after_first = true

    return formatters
  end
end

local web_formatter = project_formatter({
  deno_fmt = true,
  biome = true,
  dprint = true,
})

local document_formatter = project_formatter({
  deno_fmt = true,
  dprint = true,
})

return {
  "stevearc/conform.nvim",

  keys = {
    { "<leader>cn", "<cmd>ConformInfo<cr>", desc = "Conform Info" },
  },

  -- Mutate LazyVim's opts; keep its own config and format-on-save logic.
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    local ft = opts.formatters_by_ft

    -- Lua / shell: explicit entries help validate this file independently.
    ft.lua = { "stylua" }
    ft.sh = { "shfmt" }

    -- JavaScript / TypeScript / React.
    ft.javascript = web_formatter
    ft.javascriptreact = web_formatter
    ft.typescript = web_formatter
    ft.typescriptreact = web_formatter

    -- Markup and styles.
    ft.astro = { "prettier" }
    ft.html = document_formatter
    ft.css = web_formatter
    ft.scss = { "prettierd", "prettier", stop_after_first = true }
    ft.less = { "prettierd", "prettier", stop_after_first = true }
    ft.vue = { "prettierd", "prettier", stop_after_first = true }
    ft.svelte = { "prettierd", "prettier", stop_after_first = true }

    -- Documents / config files.
    ft.json = web_formatter
    ft.jsonc = web_formatter
    ft.yaml = document_formatter
    ft.markdown = document_formatter
    ft["markdown.mdx"] = { "prettierd", "prettier", stop_after_first = true }

    -- Compiled languages.
    ft.rust = { "rustfmt" }
    ft.c = { "clang-format" }
    ft.cpp = { "clang-format" }
    ft.objc = { "clang-format" }
    ft.objcpp = { "clang-format" }
    ft.go = { "goimports", "gofmt", stop_after_first = true }

    -- Leave formatter installation and save hooks to the existing setup.
  end,
}
