local util = require('core.util')
local nmap = util.nmap

if vim.fn.executable('fd') then
  vim.api.nvim_command([[ let $FZF_DEFAULT_COMMAND = 'fd --type f --follow --hidden --exclude ".git/*"' ]])
elseif vim.fn.executable('rg') then
  vim.api.nvim_command([[ let $FZF_DEFAULT_COMMAND = 'rg --files --smart-case --hidden --follow --glob "!.git/*"' ]])
  vim.api.nvim_command([[ let &grepprg='rg\ --vimgrep' ]])
end


nmap('<leader>fd', ':<c-u>Files!<cr>')
nmap('<leader>fg', ':<c-u>GFiles!<cr>')
nmap('<leader>fc', ':<c-u>Commands<cr>')
nmap('<leader>fh', ':<c-u>Helptags<cr>')
nmap('<leader>fH', ':<c-u>History<cr>')

nmap('//', ':<c-u>BLines!<cr>')
nmap('??', ':<c-u>Rg!<cr>')

