local config = {}

function config.lightspeed()
  require('lightspeed').setup({
    jump_to_first_match = true,
    jump_on_partial_input_safety_timeout = 400,
    highlight_unique_chars = false,
    grey_out_search_area = true,
    match_only_the_start_of_same_char_seqs = true,
    limit_ft_matches = 5,
  })
end

function config.sneak()
  vim.cmd([[let g:sneak#label = 1]])

  -- Sneak and vim-sandwich do not play very nicly together. They both map the `s`
  -- key to either [s]uround [a]round ... or the sneak trigger. I have changed
  -- sandwich's mapping to use vim-surround style mapping to something more like
  -- [y]se [s]uround [a]round ... to stop the clash. Doing this does not seem to
  -- stop s from being mapped away from seak or at least it does not take. Forcing
  -- seak mappings in the after/plugin section

  -- local keymap = vim.keymap
  -- local onoremap,xnoremap = keymap.onoremap,keymap.xnoremap

  -- nnoremap { 's', '<Plug>Sneak_s' }
  -- nnoremap { 'S', '<Plug>Sneak_S' }

  -- onoremap { 'z', '<Plug>Sneak_s' }
  -- onoremap { 'Z', '<Plug>Sneak_S' }
end

function config.easyalign()
  -- Start interactive EasyAlign in visual mode (e.g. vipga)
  vim.keymap.xnoremap { 'ga', '<Plug>(EasyAlign)' }

  -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
  vim.keymap.nnoremap { 'ga', '<Plug>(EasyAlign)' }
end

function config.sandwich()
  local keymap = vim.keymap
  local onoremap,xnoremap = keymap.onoremap,keymap.xnoremap

  -- Note: This is in the plugin folder instead of the after as sandwich and sneak
  -- have some issues integrating. Sandwich overrides the sneak mapping. I want to
  -- remap sandwich keys to vim-surround keys before the after mappings are applied
  -- for vim-sneak.
  --
  -- Use surround.vim keymappings instead of the default for sandwich. This is
  -- required as there are conflicts with other optional plugins like vim-sneak
  --
  -- https://github.com/machakann/vim-sandwich/wiki/Introduce-vim-surround-keymappings
  vim.cmd('runtime macros/sandwich/keymap/surround.vim')

  -- Text objects to select a text surrounded by brackets or user-specified characters.
  xnoremap { 'is', '<Plug>(textobj-sandwich-query-i)' }
  xnoremap { 'as', '<Plug>(textobj-sandwich-query-a)' }
  onoremap { 'is', '<Plug>(textobj-sandwich-query-i)' }
  onoremap { 'as', '<Plug>(textobj-sandwich-query-a)' }

  -- Text objects to select the nearest surrounded text automatically.
  xnoremap { 'iss', '<Plug>(textobj-sandwich-auto-i)' }
  xnoremap { 'ass', '<Plug>(textobj-sandwich-auto-a)' }
  onoremap { 'iss', '<Plug>(textobj-sandwich-auto-i)' }
  onoremap { 'ass', '<Plug>(textobj-sandwich-auto-a)' }

  -- Text objects to select a text surrounded by user-specified characters.
  xnoremap { 'im', '<Plug>(textobj-sandwich-literal-query-i)' }
  xnoremap { 'am', '<Plug>(textobj-sandwich-literal-query-a)' }
  onoremap { 'im', '<Plug>(textobj-sandwich-literal-query-i)' }
  onoremap { 'am', '<Plug>(textobj-sandwich-literal-query-a)' }
end

function config.sideways()
  local keymap = vim.keymap
  local onoremap,xnoremap = keymap.onoremap,keymap.xnoremap

  onoremap { 'aa', '<Plug>SidewaysArgumentTextobjA' }
  xnoremap { 'aa', '<Plug>SidewaysArgumentTextobjA' }
  onoremap { 'ia', '<Plug>SidewaysArgumentTextobjI' }
  xnoremap { 'ia', '<Plug>SidewaysArgumentTextobjI' }
end

return config
