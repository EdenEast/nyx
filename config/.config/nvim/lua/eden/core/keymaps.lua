local U = require("eden.util")
local map = vim.keymap.set
local fmt = string.format

local function t(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

-- Set a mapping for localleader so that which-key registers a trigger for localleader.
-- Currently it is set to write the buffer as a shortcut.
map("n", "<localleader><localleader>", "<cmd>write<cr>", { desc = "Write" })

-- This helps when using colemak's nav cluster
map("n", "<left>", "h", { remap = true })
map("n", "<down>", "j", { remap = true })
map("n", "<up>", "k", { remap = true })
map("n", "<righh>", "l", { remap = true })

-- Movement -------------------------------------------------------------------

-- Better up / down
--
-- Move by 'display lines' instead of 'logical lines'. If v:count is provided
-- it will jump by logical lines. If v:count is greater than 5 it will create
-- a jump list entry.
map({ "n", "x" }, "j", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj']], { expr = true, silent = true })
map({ "n", "x" }, "k", [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk']], { expr = true, silent = true })

-- Better n / N
--
-- Make sure that n searches forward regardless of '/', '?', '#', or '?'.
-- Search results are centered with `zzzv`.
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ "n", "x", "o" }, "n", [[(v:searchforward ? 'n' : 'N') . 'zzzv']], { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "N", [[(v:searchforward ? 'N' : 'n') . 'zzzv']], { expr = true, desc = "Prev search result" })

-- Center jump movements
map({ "n" }, "{", "{zz")
map({ "n" }, "}", "}zz")

-- Center cursor when using page jumps
map("n", "<c-d>", "<c-d>zz")
map("n", "<c-u>", "<c-u>zz")
map("n", "<c-f>", "<c-f>zz")
map("n", "<c-b>", "<c-b>zz")

-- Switch to the preveous buffer in the window
map("n", "<leader><leader>", [[<c-^>\"zz]], { desc = "Prev buffer" })

-- Move buffers
map("n", "[b", "<cmd>bprevious<cr>", { silent = true, desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { silent = true, desc = "Next buffer" })

-- Move quickfix
map("n", "[q", "<cmd>cprev<cr>", { silent = true, desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { silent = true, desc = "Next quickfix" })

-- Move tabs
map("n", "[t", "<cmd>tabprev<cr>", { silent = true, desc = "Prev tab" })
map("n", "]t", "<cmd>tabnext<cr>", { silent = true, desc = "Next tab" })

-- Window movement ------------------------------------------------------------

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

-- Macros and registers -------------------------------------------------------

-- Replay last marco. The normal use case for this would be `qq` to record a
-- macro and then `Q` to quickly replay it (if `q` was the last used macro).
map("n", "Q", "@@")

-- Execute "@" macro over visual line selections
map("x", "Q", [[:'<,'>:normal @@<CR>]])

-- Allows you to visually select a section and then hit @ to run a macro on all lines
-- https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db#.3dcn9prw6
-- Taken from: https://github.com/ahmedelgabri/dotfiles/blob/3c52dc684c3bbcac5ea249ba3d9964b36e87797e/config/nvim/plugin/mappings.lua#L140-L147
vim.cmd([[function! ExecuteMacroOverVisualRange()
  echo '@'.getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction]])

map("x", "@", ":<C-u>call ExecuteMacroOverVisualRange()<CR>")

-- Execute normal command on last search results
map("n", "gG", function()
  local input = t(fmt(":g/%s/normal ", vim.fn.getreg("/")))
  vim.api.nvim_input(input)
end, { desc = "Normal cmd on search results" })

-------------------------------------------------------------------------------

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Map Y to be the same as D and C
map({ "n", "x" }, "Y", "yg_")

-- Keep selection when indent/outdent
map("x", ">", ">gv")
map("x", "<", "<gv")

-- Visual select last pasted value
map("n", "gp", "`[v`]", { desc = "Select last paste" })

-- Clone paragraph
map("n", "cp", [[vap:t'><cr>(j]])

-- Redirect change operation to blackhole register
map({ "n", "x" }, "c", [["_c]])
map({ "n", "x" }, "C", [["_C]])

-- Pipe all blank line deletions to the blackhole register
map("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true, silent = true })

-- Execute last command
map("n", [[\]], ":<c-u><up><cr>")

-- Search for word under cursor
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")
map("v", "+", "g<C-a>")
map("v", "-", "g<C-x>")

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Read the current line and execute that line in your $SHELL. Thte reuslting
-- output will replace the curent line that was being executed.
map("n", "<leader>X", [[!!$SHELL <cr>]])

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

map("n", "<f2>", function()
  vim.cmd.write()
  vim.cmd.colorscheme(vim.g.colors_name)
end, { desc = "Reload colorscheme" })

map("n", "<leader>re", function() require("eden.util.reg").edit() end, { desc = "Edit" })
map("n", "<leader>ul", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>ui", "<cmd>Inspect<cr>", { desc = "Inspect" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- Toggle options
map("n", "<leader>ut", require("eden.core.theme").toggle, { desc = "Toggle transparency" })
map("n", "<leader>uf", require("eden.mod.lsp.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>us", function() U.toggle("spell") end, { desc = "Toggle Spell" })
map("n", "<leader>uw", function() U.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ud", U.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() U.toggle("conceallevel", false, { 0, conceallevel }) end, { desc = "Toggle Conceal" })

-- Copy and paste with shift/ctrl insert this is a combo key on my keybooard
map("n", "<C-Insert>", [["*yy]], { desc = "Copy" })
map("i", "<C-Insert>", [[<esc>"*yygi]], { desc = "Copy" })

map("n", "<S-Insert>", [["*p]], { desc = "Paste" })
map("i", "<S-Insert>", [[<c-r>*]], { desc = "Paste" })

-- Save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map({ "i", "v", "n", "s" }, "<C-x>", "<cmd>x<cr><esc>", { desc = "Save/close file" })

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

-- Move windows in therminal
map("t", "<c-h>", "<c-\\><c-n><c-w>h")
map("t", "<c-j>", "<c-\\><c-n><c-w>j")
map("t", "<c-k>", "<c-\\><c-n><c-w>k")
map("t", "<c-l>", "<c-\\><c-n><c-w>l")

-- Windows
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- Misc
map("n", "<F1>", function() require("eden.util").execute_file() end, { desc = "Execute file" })
map("n", "gb", function() require("eden.util").open_url_under_cursor() end, { desc = "Open under cursor" })

map("n", "<leader><cr>", "<cmd>messages<cr>", { desc = "Messages" })
