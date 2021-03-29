if !has('nvim')
  finish
end

execute 'luafile ' . eden#path#join([g:config_root, 'lua', 'plugin.lua'])
command! PackerInstall packadd packer.nvim | lua require('plugin').install()
command! PackerUpdate packadd packer.nvim | lua require('plugin').update()
command! PackerSync packadd packer.nvim | lua require('plugin').sync()
command! PackerClean packadd packer.nvim | lua require('plugin').clean()
command! PackerCompile packadd packer.nvim | lua require('plugin').compile()

nnoremap <F3> :<c-u>PackerCompile<cr>
nnoremap <leader><F3> :<c-u>PackerSync<cr>
