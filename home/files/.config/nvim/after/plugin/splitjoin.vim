let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''

" Setting split and join mapping to g keys
" I think of spliting as expanding downwards so that is why split
" is on gJ and join is condencing upwards gK
nmap gK :SplitjoinJoin<cr>
nmap gJ :SplitjoinSplit<cr>
