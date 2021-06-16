local util = require('core.util')
local opt = vim.opt

local formatopts = {
  opt.formatoptions,
  'j',                  -- remove comment leader when joning comments
  'n',                  -- smart auto indenting inside numbered lists
}

local keywords = {
  opt.iskeyword,
  '-',                  -- treat - seperated words as a word object
  '_',                  -- treat _ seperated words as a word object
}

opt.autoindent    = true                -- maintain indent of current line
opt.backspace     = 'indent,start,eol'  -- allow unrestricted backspaceing in insert mode
opt.clipboard     = 'unnamedplus'       -- use '+' register for all yanks, and deletes
opt.expandtab     = true                -- always use spaces instead of tabs
opt.formatoptions = util.join(formatopts, '')
opt.hidden        = true                -- allows you to hide buffers with unsaved changes without being prompted
opt.iskeyword     = util.join(keywords, ',')
opt.linebreak     = true                -- wrap long lines at characters in 'breakat'
opt.modelines     = 5                   -- scan this many lines looking for modeline
opt.mouse         = 'a'                 -- automatically enable mouse usage
opt.joinspaces    = true                -- don't autoinsert two spaces after '.', '?', '!' for join command
opt.shiftround    = true                -- always indent by multiple of shiftwidth
opt.shiftwidth    = 4                   -- spaces per tab (when shifting)
opt.smarttab      = true                -- <tab><bs> indent/deindent in leading whitespace
opt.softtabstop   = -1                  -- use 'shiftwidth' for tab/bs at end of line
opt.spellcapcheck = ''                  -- dont check for capital letters at the start of sentences
opt.splitbelow    = true                -- open horizontal splits below the current one
opt.splitright    = true                -- open vertical splits right of the current one
opt.switchbuf     = 'usetab'            -- try to reuse windows/tabs when switching buffers
opt.tabstop       = 4                   -- spaces per tab as editor defualt
opt.textwidth     = 120                 -- automatically hard wrap at 120 columns by default
opt.whichwrap     = 'b,h,l,s,<,>,[,],~' -- allow <BS>/h/l/<Left>/<Right>/<Space>, ~ to cross line boundaries
-- wildcharm     = '<C-z>',             -- substitute for 'wildchar' (<Tab>) in macros

