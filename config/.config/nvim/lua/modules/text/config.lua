local config = {}

function config.lightspeed()
  require("lightspeed").setup({
    jump_to_first_match = true,
    jump_on_partial_input_safety_timeout = 400,
    highlight_unique_chars = false,
    grey_out_search_area = true,
    match_only_the_start_of_same_char_seqs = true,
    limit_ft_matches = 5,
  })
end

function config.easyalign()
  vim.keymap({
    mode = "xn",
    {
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      { "ga", "<Plug>(EasyAlign)" },
    },
  })
end

function config.sandwich()
  -- Note: This is in the plugin folder instead of the after as sandwich and sneak
  -- have some issues integrating. Sandwich overrides the sneak mapping. I want to
  -- remap sandwich keys to vim-surround keys before the after mappings are applied
  -- for vim-sneak.
  --
  -- Use surround.vim keymappings instead of the default for sandwich. This is
  -- required as there are conflicts with other optional plugins like vim-sneak
  --
  -- https://github.com/machakann/vim-sandwich/wiki/Introduce-vim-surround-keymappings
  vim.cmd("runtime macros/sandwich/keymap/surround.vim")

  vim.keymap({
    mode = "xo",
    {
      -- Text objects to select a text surrounded by brackets or user-specified characters.
      { "is", "<Plug>(textobj-sandwich-query-i)" },
      { "as", "<Plug>(textobj-sandwich-query-a)" },

      -- Text objects to select the nearest surrounded text automatically.
      { "iss", "<Plug>(textobj-sandwich-auto-i)" },
      { "ass", "<Plug>(textobj-sandwich-auto-a)" },

      -- Text objects to select a text surrounded by user-specified characters.
      { "im", "<Plug>(textobj-sandwich-literal-query-i)" },
      { "am", "<Plug>(textobj-sandwich-literal-query-a)" },
    },
  })
end

function config.sideways()
  vim.keymap({
    mode = "xo",
    {
      { "aa", "<Plug>SidewaysArgumentTextobjA" },
      { "ia", "<Plug>SidewaysArgumentTextobjI" },
    },
  })
end

return config
