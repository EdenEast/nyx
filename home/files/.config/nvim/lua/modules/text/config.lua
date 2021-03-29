local config = {}

function config.sneak()
  vim.cmd([[let g:sneak#label = 1]])

  -- Sneak and vim-sandwich do not play very nicly together. They both map the `s`
  -- key to either [s]uround [a]round ... or the sneak trigger. I have changed
  -- sandwich's mapping to use vim-surround style mapping to something more like
  -- [y]se [s]uround [a]round ... to stop the clash. Doing this does not seem to
  -- stop s from being mapped away from seak or at least it does not take. Forcing
  -- seak mappings in the after/plugin section

  -- local util = require('core.util')
  -- local nmap,omap = util.nmap,util.omap
  -- nmap('s', '<Plug>Sneak_s')
  -- nmap('S', '<Plug>Sneak_S')

  -- omap('z', '<Plug>Sneak_s')
  -- omap('Z', '<Plug>Sneak_S')
end

function config.easyalign()
  local util = require('core.util')
  local nmap,xmap = util.nmap,util.xmap

  -- Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap('ga', '<Plug>(EasyAlign)')

  -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap('ga', '<Plug>(EasyAlign)')
end

function config.sandwich()
  local util = require('core.util')
  local omap,xmap = util.omap,util.xmap
  
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
  xmap('is', '<Plug>(textobj-sandwich-query-i)')
  xmap('as', '<Plug>(textobj-sandwich-query-a)')
  omap('is', '<Plug>(textobj-sandwich-query-i)')
  omap('as', '<Plug>(textobj-sandwich-query-a)')

  -- Text objects to select the nearest surrounded text automatically.
  xmap('iss', '<Plug>(textobj-sandwich-auto-i)')
  xmap('ass', '<Plug>(textobj-sandwich-auto-a)')
  omap('iss', '<Plug>(textobj-sandwich-auto-i)')
  omap('ass', '<Plug>(textobj-sandwich-auto-a)')

  -- Text objects to select a text surrounded by user-specified characters.
  xmap('im', '<Plug>(textobj-sandwich-literal-query-i)')
  xmap('am', '<Plug>(textobj-sandwich-literal-query-a)')
  omap('im', '<Plug>(textobj-sandwich-literal-query-i)')
  omap('am', '<Plug>(textobj-sandwich-literal-query-a)')
end

function config.sideways()
  local util = require('core.util')
  local omap,xmap = util.omap,util.xmap

  omap('aa', '<Plug>SidewaysArgumentTextobjA')
  xmap('aa', '<Plug>SidewaysArgumentTextobjA')
  omap('ia', '<Plug>SidewaysArgumentTextobjI')
  xmap('ia', '<Plug>SidewaysArgumentTextobjI')
end

return config
