local util = require('core.util')
local opt = vim.opt

opt.ignorecase = true                -- ignore case in search
opt.incsearch  = true                -- do incremental searching
opt.smartcase  = true                -- use case sensitive search if capital letter is present
opt.inccommand = 'split'             -- line preview of :s results
opt.wildmenu   = true                -- show options as list when switching buffers etc
opt.wildmode   = 'longest:full,full' -- shell-like autocomplete to unambiguous portions

