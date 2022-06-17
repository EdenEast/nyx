-- local keymap = require("eden.core.keymap")

-- 'j' and 'k' moves up and down visible lines in editor not actual lines
-- This is noticable when text wraps to next line
nmap("j", "gj")
nmap("k", "gk")

-- Read the current line and execute that in your $SHELL.  The resulting output of the command will replace the line
-- that you were on. This is very handy. Also I dont use Ex mode.
nmap("Q", [[!!$SHELL <cr>]])

-- Witn colemak having 'hjkl' all not on the home row, and all on the right
-- index finger, having a 'nav' layer help with navigation
nmap("<left>", "h")
nmap("<down>", "j")
nmap("<up>", "k")
nmap("<right>", "l")

-- Map Y to be the same as D and C
kmap({ "n", "x" }, "Y", "yg_")

-- Center search
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

-- Switch between the last two buffers
nmap("<leader><leader>", [[<c-^>\"zz]])

-- Keep selection when indent/outdent
xmap(">", ">gv")
xmap("<", "<gv")

-- Search for selected text
xmap("*", '"xy/<c-r><cr>')

-- Clone paragraph
nmap("cp", [[vap:t'><cr>(j]])

-- Redirect change operation to blackhole register
kmap({ "n", "x" }, "c", [["_c]])
kmap({ "n", "x" }, "C", [["_C]])

-- Toggle highlight search
nmap("<leader>th", function()
  vim.opt.hlsearch = not vim.o.hlsearch
end)

nmap("<leader>w", [[:<c-u>w<cr>]])
nmap("<leader>q", [[:<c-u>q<cr>]])
nmap("<leader>!", [[:<c-u>q!<cr>]])

nmap("<leader>tn", function()
  require("core.util").toggle_numbers()
end)

nmap("<leader>bm", function()
  require("eden.fn.bufmax").toggle()
end)

nmap("<leader>tt", ":Telescope colorscheme<cr>")

-- Jump list -------------------------------------------------------------------
-- Because currently in alacritty we cannot tell the difference between <tab>
-- and <c-i> mapping <m-i> and <m-o> to go forward and backwards in the jump list
--
-- https://vi.stackexchange.com/a/23344
nmap("<m-i>", "<c-i>")
nmap("<m-o>", "<c-o>")

nmap("[t", ":tabprevious<cr>", { silent = true })
nmap("]t", ":tabnext<cr>", { silent = true })

nmap("[q", ":cprev<cr>", { silent = true })
nmap("]q", ":cnext<cr>", { silent = true })

-- -- Move around splits without having to press <C-w> before each movement"
-- nmap("<A-h>", "<cmd>lua require('eden.fn.winmove')('left')<cr>")
-- nmap("<A-j>", "<cmd>lua require('eden.fn.winmove')('down')<cr>")
-- nmap("<A-k>", "<cmd>lua require('eden.fn.winmove')('up')<cr>")
-- nmap("<A-l>", "<cmd>lua require('eden.fn.winmove')('right')<cr>")

-- Exec current file
nmap("<F1>", ":lua require('eden.core.util').exec_file()<cr>")
nmap("<F2>", ":lua require('eden.core.util').open_url_under_cursor()<cr>")
nmap("<F3>", "<cmd>lua require('eden.lib.reload').reload_config()<cr>")

tmap("<esc>", [[<c-\><c-n>]])
tmap("<c-q>", [[<c-\><c-n>:bdelete!<cr>]])
tmap("<c-h>", [[<c-\><c-n><c-w>h]])
tmap("<c-j>", [[<c-\><c-n><c-w>j]])
tmap("<c-k>", [[<c-\><c-n><c-w>k]])
tmap("<c-l>", [[<c-\><c-n><c-w>l]])
