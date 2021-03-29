if !has('nvim') || g:eden_use_builtin_lsp == 0
  finish
endif

" Diagnostic settings ---------------------------------------------------------
let g:diagnostic_enable_virtual_text = 1
let g:space_before_virtual_text = 2
" Dont show diagnostic while in insert mode
let g:diagnostic_insert_delay = 1

" Have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300

" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()

call sign_define('LspDiagnosticsErrorSign', {'text' : '🗙', 'texthl' : 'RedHover'})
call sign_define('LspDiagnosticsWarningSign', {'text' : '➤', 'texthl' : 'YellowHover'})
call sign_define('LspDiagnosticsInformationSign', {'text' : '🛈', 'texthl' : 'WhiteHover'})
call sign_define('LspDiagnosticsHintSign', {'text' : '❗', 'texthl' : 'CocHintHighlight'})

" Completion settings ---------------------------------------------------------
let g:completion_auto_change_source = 1
let g:completion_confirm_key = ""
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_chain_complete_list  = {
  \ 'vim': [
  \    {'mode': '<c-n>'},
  \    {'mode': '<c-p>'}
  \ ],
  \ 'lua': [
  \    {'mode': '<c-n>'},
  \    {'mode': '<c-p>'}
  \ ],
  \ 'default': [
  \    {'complete_items': ['lsp', 'snippet']},
  \    {'complete_items': ['path'], 'triggered_only': ['/']},
  \    {'mode': '<c-n>'},
  \    {'mode': '<c-p>'}
  \ ]}

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
set completeopt=menuone,noinsert

" Avoid showing message extra message when using completion
set shortmess+=c

" Mappings and utility functions ----------------------------------------------

" Use return to confirm completion
imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
                 \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :  "\<CR>"

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Manually trigger completion
imap <silent> <c-space> <Plug>(completion_trigger)

" LSP mappings
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap <silent> gy <cmd>lua vim.lsp.buf.type_definition()<cr>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<cr>

nnoremap <silent> ]e <cmd>NextDiagnosticCycle<cr>
nnoremap <silent> [e <cmd>PrevDiagnosticCycle<cr>

nnoremap <silent> <leader>ca <cmd>lua vim.lsp.buf.code_action()<cr>
let g:which_key_map.c.a = 'Code Actions'

nnoremap <silent> <leader>ce <cmd>OpenDiagnostic<cr>
let g:which_key_map.c.e = 'Show Diagnostics'

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

