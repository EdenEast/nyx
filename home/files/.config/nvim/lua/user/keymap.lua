local keymap = vim.keymap;
local nnoremap, xnoremap = keymap.nnoremap, keymap.xnoremap

-- 'j' and 'k' moves up and down visible lines in editor not actual lines
-- This is noticable when text wraps to next line
nnoremap { 'j', 'gj' }
nnoremap { 'k', 'gk' }

-- Witn colemak having 'hjkl' all not on the home row, and all on the right
-- index finger, having a 'nav' layer helpr with navigation
keymap.map{ '<left>',  'h' }
keymap.map{ '<down>',  'j' }
keymap.map{ '<up>',    'k' }
keymap.map{ '<right>', 'l' }

-- Map Y to be the same as D and C
nnoremap { 'Y', 'y$' }
xnoremap { 'Y', 'y$' }

-- Center search
nnoremap { 'n', 'nzz' }
nnoremap { 'N', 'Nzz' }

-- Switch between the last two buffers
nnoremap { '<leader><leader>', '<c-^>' }
vim.which_leader['space'] = 'prev-buffer'

-- Keep selection when indent/outdent
xnoremap { '>', '>gv' }
xnoremap { '<', '<gv' }

-- Search for selected text
xnoremap { '*', '"xy/<c-r><cr>' }

-- Toggle highlight search
nnoremap { '<leader>th', [[(&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"]] }

nnoremap { '<leader>w', [[:<c-u>w<cr>]] }
vim.which_leader['w'] = 'write-file'
nnoremap { '<leader>q', [[:<c-u>q<cr>]] }
vim.which_leader['q'] = 'quit-file'

-- Jump list -------------------------------------------------------------------
-- Because currently in alacritty we cannot tell the difference between <tab>
-- and <c-i> mapping <m-i> and <m-o> to go forward and backwards in the jump list
--
-- https://vi.stackexchange.com/a/23344
nnoremap { '<m-i>', '<c-i>' }
nnoremap { '<m-o>', '<c-o>' }

nnoremap { '[t',':tabprevious<cr>' }
vim.which_prev['t'] = 'tab'
nnoremap { ']t',':tabnext<cr>' }
vim.which_next['t'] = 'tab'

-- Move around splits without having to press <C-w> before each movement"
nnoremap { '<c-h>', '<c-w>h' }
nnoremap { '<c-j>', '<c-w>j' }
nnoremap { '<c-k>', '<c-w>k' }
nnoremap { '<c-l>', '<c-w>l' }

-- Exec current file
nnoremap { '<F1>', ":lua require('core.util').exec_file()<cr>" }
nnoremap { '<F2>', ":lua require('core.util').open_url_under_cursor()<cr>" }
nnoremap { '<F3>', ":lua require('core.pack').reload_plugins()<cr>" }

