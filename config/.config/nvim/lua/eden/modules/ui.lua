local M = {}

M.plugins = {
  {
    "shadmansaleh/lualine.nvim",
    config = [[require('eden.modules.ui.lualine')]],
    requires = { "nvim-lua/lsp-status.nvim" },
  },
  {
    "glepnir/dashboard-nvim",
    cond = [[vim.g.started_by_firenvim]],
  },
}

M.before = function()
  vim.g.dashboard_custom_header = {
    "███████╗██████╗ ███████╗███╗   ██╗",
    "██╔════╝██╔══██╗██╔════╝████╗  ██║",
    "█████╗  ██║  ██║█████╗  ██╔██╗ ██║",
    "██╔══╝  ██║  ██║██╔══╝  ██║╚██╗██║",
    "███████╗██████╔╝███████╗██║ ╚████║",
    "╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═══╝",
  }
  vim.g.dashboard_default_executive = "telescope"
  vim.g.dashboard_custom_section = {
    a = { description = { "  Recently Used Files" }, command = "Telescope oldfiles" },
    b = { description = { "  Find File          " }, command = "Telescope find_files" },
    c = { description = { "  Load Last Session  " }, command = "SessionLoad" },
    d = { description = { "  Find Word          " }, command = "Telescope live_grep" },
    e = { description = { "  File Browser       " }, command = "Telescope file_browser" },
  }
  vim.g.dashboard_custom_footer = { "github.com/EdenEast" }
end

return M
