augroup LuaHighlight
  autocmd!
  autocmd TextYankPost * lua vim.highlight.on_yank {
        \ higroup = "Substitute",
        \ timeout = 200,
        \ on_macro = true
        \ }
augroup END
