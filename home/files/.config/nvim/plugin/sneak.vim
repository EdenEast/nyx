let g:sneak#label = 1

" Sneak and vim-sandwich do not play very nicly together. They both map the `s`
" key to either [s]uround [a]round ... or the sneak trigger. I have changed
" sandwich's mapping to use vim-surround style mapping to something more like
" [y]se [s]uround [a]round ... to stop the clash. Doing this does not seem to
" stop s from being mapped away from seak or at least it does not take. Forcing
" seak mappings in the after/plugin section

" nmap s <Plug>Sneak_s
" nmap S <Plug>Sneak_S

" omap z <Plug>Sneak_s
" omap Z <Plug>Sneak_S
