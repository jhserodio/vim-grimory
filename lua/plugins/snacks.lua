return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Desabilitar bigfile para evitar conflitos
    bigfile = { enabled = false },
    -- Desabilitar statuscolumn se causar problemas
    statuscolumn = { enabled = false },
    -- Configurar notifier
    notifier = { enabled = true },
    -- Configurar quickfile
    quickfile = { enabled = true },
    -- Outras configurações
    dashboard = {
      preset = {
        pick = function(cmd, opts)
          return LazyVim.pick(cmd, opts)()
        end,
        header = [[
      ██╗   ██╗███╗   ██╗ █████╗ ████████╗ ██████╗ ██████╗ 
      ██║   ██║████╗  ██║██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗
      ██║   ██║██╔██╗ ██║███████║   ██║   ██║   ██║██████╔╝
      ╚██╗ ██╔╝██║╚██╗██║██╔══██║   ██║   ██║   ██║██╔══██╗
       ╚████╔╝ ██║ ╚████║██║  ██║   ██║   ╚██████╔╝██║  ██║
        ╚═══╝  ╚═╝  ╚═══╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝
                                                          
      _.zZ SERODIO - SOFTWARE CRAFTER ZZ._
        
      ⚔   ☩  ⚔
        
      Carambolas Never Die Edition
      ]],

        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
