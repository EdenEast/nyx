local M = {}

M.plugins = {
  { "tpope/vim-commentary" }, -- Language agnostic comment motions
  { "ggandor/lightspeed.nvim" }, -- Jump to any location specified by two characters
  { "junegunn/vim-easy-align" }, -- Align text
  { "machakann/vim-sandwich" }, -- Search/select/edit sandwiched textobjects (surrond)
  { "christoomey/vim-sort-motion" }, -- Vim mapping for sorting a range of text
  { "glts/vim-textobj-comment" }, -- Text objects for comments
  { "wellle/targets.vim" }, -- Add text objects for pair, quote, seperator, argument, and tag
  { "kana/vim-textobj-user" }, -- Create own user text objects
}

M.after = function()
  require("lightspeed").setup({
    jump_to_unique_chars = { safety_timeout = 400 },
    match_only_the_start_of_same_char_seqs = true,
    limit_ft_matches = 5,
  })

  -- ---------------------------------------------------

  edn.keymap({
    mode = "xn",
    {
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      { "ga", "<Plug>(EasyAlign)" },
    },
  })

  -- ---------------------------------------------------

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

  edn.keymap({
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

return M
