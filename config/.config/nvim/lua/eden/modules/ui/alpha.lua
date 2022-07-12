local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

local logo = {
  "                                                     ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  "                                                     ",
}

local function footer()
  local datetime = os.date(" %Y-%m-%d") .. "  -  "
  local author = " " .. os.getenv("USER") .. "  -  "
  local total_plugins = " " .. #vim.tbl_keys(packer_plugins) .. " plugins" .. "  -  "
  local version = vim.version()
  local nvim_version_info = " v" .. version.major .. "." .. version.minor .. "." .. version.patch

  return author .. datetime .. total_plugins .. nvim_version_info
end

dashboard.section.header.val = logo

dashboard.section.buttons.val = {
  dashboard.button("o", "  Open CWD", "<cmd>ene|NvimTreeToggle<CR>"),
  dashboard.button("h", "  Recent Projects", "<cmd>Telescope projects<CR>"),
  dashboard.button("r", "  Recent File", "<cmd>Telescope oldfiles<CR>"),
  dashboard.button("e", "  New file", "<cmd>ene<CR>"),
  dashboard.button("f", "  Find File", "<cmd>Telescope find_files<CR>"),
  dashboard.button("s", "  Configuration", "<cmd>e $MYVIMRC|NvimTreeToggle<CR>"),
  dashboard.button("u", "  Update Plugins", "<cmd>PackerUpdate<CR>"),
  dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
}

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = "Constant"

dashboard.opts = {
  layout = {
    { type = "padding", val = 4 },
    dashboard.section.header,
    { type = "padding", val = 4 },
    dashboard.section.buttons,
    { type = "padding", val = 2 },
    dashboard.section.footer,
  },
  opts = {
    margin = 5,
  },
}

alpha.setup(dashboard.opts)

vim.api.nvim_create_augroup("alpha_tabline", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "alpha_tabline",
  pattern = "alpha",
  command = "set showtabline=0 laststatus=0 noruler",
})

vim.api.nvim_create_autocmd("FileType", {
  group = "alpha_tabline",
  pattern = "alpha",
  callback = function()
    vim.api.nvim_create_autocmd("BufUnload", {
      group = "alpha_tabline",
      buffer = 0,
      command = "set showtabline=1 ruler laststatus=3",
    })
  end,
})
