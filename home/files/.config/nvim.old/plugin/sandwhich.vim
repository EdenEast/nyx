" Note: This is in the plugin folder instead of the after as sandwich and sneak
" have some issues integrating. Sandwich overrides the sneak mapping. I want to
" remap sandwich keys to vim-surround keys before the after mappings are applied
" for vim-sneak.
"
" Use surround.vim keymappings instead of the default for sandwich. This is
" required as there are conflicts with other optional plugins like vim-sneak
"
" https://github.com/machakann/vim-sandwich/wiki/Introduce-vim-surround-keymappings
runtime macros/sandwich/keymap/surround.vim

" Text objects to select a text surrounded by brackets or user-specified characters.
xmap is <Plug>(textobj-sandwich-query-i)
xmap as <Plug>(textobj-sandwich-query-a)
omap is <Plug>(textobj-sandwich-query-i)
omap as <Plug>(textobj-sandwich-query-a)

" Text objects to select the nearest surrounded text automatically.
xmap iss <Plug>(textobj-sandwich-auto-i)
xmap ass <Plug>(textobj-sandwich-auto-a)
omap iss <Plug>(textobj-sandwich-auto-i)
omap ass <Plug>(textobj-sandwich-auto-a)

" Text objects to select a text surrounded by user-specified characters.
xmap im <Plug>(textobj-sandwich-literal-query-i)
xmap am <Plug>(textobj-sandwich-literal-query-a)
omap im <Plug>(textobj-sandwich-literal-query-i)
omap am <Plug>(textobj-sandwich-literal-query-a)
