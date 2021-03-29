local util = require('core.util')
local map  = util.map
local nmap = util.nmap
local xmap = util.xmap
local wmap = util.wmap
local cmap = util.cmap

-- 'j' and 'k' moves up and down visible lines in editor not actual lines
-- This is noticable when text wraps to next line
nmap('j', 'gj')
nmap('k', 'gk')

-- Witn colemak having 'hjkl' all not on the home row, and all on the right
-- index finger, having a 'nav' layer helpr with navigation
map('', '<left>',  'h', {})
map('', '<down>',  'j', {})
map('', '<up>', '   k', {})
map('', '<right>', 'l', {})

-- Map Y to be the same as D and C
nmap('Y', 'y$')
xmap('Y', 'y$')

-- Center search
nmap('n', 'nzz')
nmap('N', 'Nzz')

-- Switch between the last two buffers
nmap('<leader><leader>', '<c-^>')

-- Keep selection when indent/outdent
xmap('>', '>gv')
xmap('<', '<gv')

-- Search for selected text
xmap('*', '"xy/<c-r><cr>')

-- Toggle highlight search
nmap('<leader>th', [[(&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"]])

nmap('<leader>w', [[:<c-u>w<cr>]])
nmap('<leader>q', [[:<c-u>q<cr>]])

-- Jump list -------------------------------------------------------------------
-- Because currently in alacritty we cannot tell the difference between <tab>
-- and <c-i> mapping <m-i> and <m-o> to go forward and backwards in the jump list
--
-- https://vi.stackexchange.com/a/23344
nmap('<m-i>', '<c-i>')
nmap('<m-o>', '<c-o>')

nmap(']t',':tabprevious<cr>')
nmap(']t',':tabNext<cr>')

-- Move around splits without having to press <C-w> before each movement"
nmap('<c-h>', '<c-w>h')
nmap('<c-j>', '<c-w>j')
nmap('<c-k>', '<c-w>k')
nmap('<c-l>', '<c-w>l')

-- Exec current file
nmap('<F1>', ":lua require('core.util').exec_file()<cr>")
nmap('<F2>', ":lua require('core.util').open_url_under_cursor()<cr>")
