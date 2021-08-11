local conf = require("modules.text.config")
local text = {}

-- Language agnostic comment motions
text["tpope/vim-commentary"] = {}

-- Jump to any location specified by two characters
text["ggandor/lightspeed.nvim"] = {
  config = conf.lightspeed,
}

--
text["junegunn/vim-easy-align"] = {
  config = conf.easyalign,
}

-- Search/select/edit sandwiched textobjects (surrond)
text["machakann/vim-sandwich"] = {
  config = conf.sandwich,
}

-- Vim mapping for sorting a range of text
text["christoomey/vim-sort-motion"] = {}

-- Text objects for comments
text["glts/vim-textobj-comment"] = {}

-- Add text objects for pair, quote, seperator, argument, and tag
text["wellle/targets.vim"] = {}

-- Create own user text objects
text["kana/vim-textobj-user"] = {}

-- Move the item under the cursor left or right, where an "item" is defined by a delimiter.
text["AndrewRadev/sideways.vim"] = {
  config = conf.sideways,
}

return text
