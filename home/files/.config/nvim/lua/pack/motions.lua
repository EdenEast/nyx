local use = require('packer').use

use 'tpope/vim-commentary'        -- Language agnostic comment motions
use 'junegunn/vim-easy-align'
use 'machakann/vim-sandwich'      -- Search/select/edit sandwiched textobjects (surrond)
use 'christoomey/vim-sort-motion'
use 'glts/vim-textobj-comment'    -- Text objects for comments
use 'wellle/targets.vim'          -- Add text objects for pair, quote, seperator, argument, and tag
use 'wellle/line-targets.vim'     -- Add - object for line 'da-'
use 'kana/vim-textobj-user'       -- Create own user text objects
use 'AndrewRadev/sideways.vim'    -- Move the item under the cursor left or right, where an "item" is defined by a delimiter.
