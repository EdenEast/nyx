local global = require("core.global")
local Terminal = require("toggleterm.terminal").Terminal

require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 20
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  direction = "horizontal",
  float_opts = {
    border = "double",
    highlights = {
      background = "DarkenedPanel",
      border = "DarkenedPanel",
    },
  },
})

local shell = global.is_windows and "powershell -NoLogo" or vim.o.shell

local terminals = {}

terminals.default = Terminal:new({
  cmd = shell,
  direction = "horizontal",
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(
      term.bufnr,
      "t",
      "<c-space>",
      [[<C-\><C-n><cmd>lua toggle_terminal('default')<cr>]],
      { noremap = true, silent = true }
    )
  end,
})

_G.toggle_terminal = function(name)
  terminals[name]:toggle()
end

vim.keymap({ "<c-space>", [[<cmd>lua toggle_terminal('default')<cr>]] })
