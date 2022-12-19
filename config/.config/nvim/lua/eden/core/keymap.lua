require("eden.lib.keymap")

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

-- Center cursor when using page jumps
nmap("<c-d>", "<c-d>zz")
nmap("<c-u>", "<c-u>zz")
nmap("<c-f>", "<c-f>zz")
nmap("<c-b>", "<c-b>zz")


-- Switch between the last two buffers
nmap("<leader><leader>", [[<c-^>\"zz]], { desc = "Last buffer" })

-- Keep selection when indent/outdent
xmap(">", ">gv")
xmap("<", "<gv")

-- Visual select last pasted value
nmap("gp", "`[v`]")

-- Search for selected text
xmap("*", '"xy/<c-r><cr>')

-- Clone paragraph
nmap("cp", [[vap:t'><cr>(j]])

-- Redirect change and `x` operation to blackhole register
kmap({ "n", "x" }, "c", [["_c]])
kmap({ "n", "x" }, "C", [["_C]])

-- Increment/decrement
nmap("+", "<C-a>")
nmap("-", "<C-x>")
vmap("+", "g<C-a>")
vmap("-", "g<C-x>")

-- Execute last command
nmap([[\]], ":<c-u><up><cr>")

nmap("dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true, silent = true })

-- Toggle highlight search
nmap("<leader>th", function()
  vim.opt.hlsearch = not vim.o.hlsearch
end, { desc = "Highlight" })

nmap("<leader>w", [[:<c-u>w<cr>]], { desc = "Write file" })
nmap("<leader>q", [[:<c-u>q<cr>]], { desc = "Quit buffer" })
nmap("<leader>!", [[:<c-u>q!<cr>]], { desc = "Force quit buffer" })

nmap("<leader>tn", function()
  require("eden.core.util").toggle_numbers()
end, { desc = "Number line" })

nmap("<leader>bm", function()
  require("eden.extend.bufmax").toggle()
end, { desc = "Max buffer" })

nmap("<leader>tt", ":Telescope colorscheme<cr>", { desc = "Colorscheme" })

-- Jump list -------------------------------------------------------------------
-- Because currently in alacritty we cannot tell the difference between <tab>
-- and <c-i> mapping <m-i> and <m-o> to go forward and backwards in the jump list
--
-- https://vi.stackexchange.com/a/23344
nmap("<m-i>", "<c-i>")
nmap("<m-o>", "<c-o>")

nmap("[t", ":tabprevious<cr>", { silent = true, desc = "Preveous tab" })
nmap("]t", ":tabnext<cr>", { silent = true, desc = "Next tab" })

nmap("[q", ":cprev<cr>", { silent = true, desc = "Preveous quickfix" })
nmap("]q", ":cnext<cr>", { silent = true, desc = "Next quickfix" })

-- -- Move around splits without having to press <C-w> before each movement"
-- nmap("<A-h>", "<cmd>lua require('eden.extend.winmove')('left')<cr>")
-- nmap("<A-j>", "<cmd>lua require('eden.extend.winmove')('down')<cr>")
-- nmap("<A-k>", "<cmd>lua require('eden.extend.winmove')('up')<cr>")
-- nmap("<A-l>", "<cmd>lua require('eden.extend.winmove')('right')<cr>")

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

nmap("<leader>gB", function()
  require("eden.extend.git").open_in_browser()
end, { desc = "Browse file" })
