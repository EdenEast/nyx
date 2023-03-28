local U = require("eden.util")
local map = vim.keymap.set

-- Read the current line and execute that in your $SHELL.  The resulting output
-- of the command will replace the line that you were on. This is very handy.
-- Also I dont use Ex mode.
map("n", "Q", [[!!$SHELL <cr>]])

map("n", "<localleader><localleader>", "<cmd>write<cr>", { desc = "Write" })

-- better up/down
--
-- 'j' and 'k' moves up and down visible lines in editor not actual lines.
-- This is noticable when text wraps to next line.
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Switch to the preveous buffer in the window
map("n", "<leader><leader>", [[<c-^>\"zz]], { desc = "Prev buffer" })

-- Move to window using the <ctrl> hjkl keys
-- if vim.env.TMUX == nil and vim.env.ZELLIJ == nil then
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
-- end

-- -- Resize window using <ctrl> arrow keys
-- map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
-- map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
-- map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- -- Move Lines
-- map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
-- map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
-- map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
-- map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
-- map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Move buffers
map("n", "[b", "<cmd>bprevious<cr>", { silent = true, desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { silent = true, desc = "Next buffer" })

-- Move quickfix
map("n", "[q", "<cmd>cprev<cr>", { silent = true, desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { silent = true, desc = "Next quickfix" })

-- Move tabs
map("n", "[t", "<cmd>tabprev<cr>", { silent = true, desc = "Prev tab" })
map("n", "]t", "<cmd>tabnext<cr>", { silent = true, desc = "Next tab" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

map("n", "<leader>ul", "<cmd>Lazy<cr>", { desc = "Lazy" })

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- TODO: Center when searching?
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Prev search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Center cursor when using page jumps
map("n", "<c-d>", "<c-d>zz")
map("n", "<c-u>", "<c-u>zz")
map("n", "<c-f>", "<c-f>zz")
map("n", "<c-b>", "<c-b>zz")

-- Map Y to be the same as D and C
map({ "n", "x" }, "Y", "yg_")

-- Keep selection when indent/outdent
map("x", ">", ">gv")
map("x", "<", "<gv")

-- Visual select last pasted value
map("n", "gp", "`[v`]")

-- Clone paragraph
map("n", "cp", [[vap:t'><cr>(j]])

-- Redirect change operation to blackhole register
map({ "n", "x" }, "c", [["_c]])
map({ "n", "x" }, "C", [["_C]])

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")
map("v", "+", "g<C-a>")
map("v", "-", "g<C-x>")

-- Execute last command
map("n", [[\]], ":<c-u><up><cr>")

-- Pipe all blank line deletions to the blackhole register
map("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true, silent = true })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Toggle options
map("n", "<leader>uf", require("eden.mod.lsp.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>us", function() U.toggle("spell") end, { desc = "Toggle Spell" })
map("n", "<leader>uw", function() U.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ud", U.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() U.toggle("conceallevel", false, { 0, conceallevel }) end, { desc = "Toggle Conceal" })

-- Save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Open quickfix and location list
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- Quit
map("n", "<leader>qw", "<cmd>w<cr>", { desc = "Write buffer" })
map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit buffer" })
map("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit all" })

-- Exit terminal mode to normal mode
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- Windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- Misc
map("n", "<F1>", function() require("eden.util").execute_file() end, { desc = "Execute file" })
