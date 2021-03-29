local nnoremap = vim.keymap.nnoremap

if vim.fn.executable('fd') then
  vim.api.nvim_command([[ let $FZF_DEFAULT_COMMAND = 'fd --type f --follow --hidden --exclude ".git/*"' ]])
elseif vim.fn.executable('rg') then
  vim.api.nvim_command([[ let $FZF_DEFAULT_COMMAND = 'rg --files --smart-case --hidden --follow --glob "!.git/*"' ]])
  vim.api.nvim_command([[ let &grepprg='rg\ --vimgrep' ]])
end


nnoremap { '<leader>fd', ':<c-u>Files!<cr>' }
nnoremap { '<leader>fg', ':<c-u>GFiles!<cr>' }
nnoremap { '<leader>fc', ':<c-u>Commands<cr>' }
nnoremap { '<leader>fh', ':<c-u>Helptags<cr>' }
nnoremap { '<leader>fH', ':<c-u>History<cr>' }

nnoremap { '//', ':<c-u>BLines!<cr>' }
nnoremap { '??', ':<c-u>Rg!<cr>' }

