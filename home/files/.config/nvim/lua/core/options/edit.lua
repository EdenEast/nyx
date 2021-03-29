local fo = vim.o.formatoptions
local keyword = vim.o.iskeyword

local edit = {
  autoindent    = true,                -- maintain indent of current line
  backspace     = 'indent,start,eol',  -- allow unrestricted backspaceing in insert mode
  clipboard     = 'unnamedplus',       -- use '+' register for all yanks, and deletes
  expandtab     = true,                -- always use spaces instead of tabs
  formatoptions = fo
              .. 'j'                   -- remove comment leader when joning comments
              .. 'n',                  -- smart auto indenting inside numbered lists
  hidden        = true,                -- allows you to hide buffers with unsaved changes without being prompted
  iskeyword     = keyword
              .. '-'                   -- treat - seperated words as a word object
              .. '_',                  -- treat _ seperated words as a word object
  linebreak     = true,                -- wrap long lines at characters in 'breakat'
  modelines     = 5,                   -- scan this many lines looking for modeline
  mouse         = 'a',                 -- automatically enable mouse usage
  joinspaces    = true,                -- don't autoinsert two spaces after '.', '?', '!' for join command
  shiftround    = true,                -- always indent by multiple of shiftwidth
  shiftwidth    = 4,                   -- spaces per tab (when shifting)
  smarttab      = true,                -- <tab><bs> indent/deindent in leading whitespace
  softtabstop   = -1,                  -- use 'shiftwidth' for tab/bs at end of line
  spellcapcheck = '',                  -- dont check for capital letters at the start of sentences
  splitbelow    = true ,               -- open horizontal splits below the current one
  splitright    = true,                -- open vertical splits right of the current one
  switchbuf     = 'usetab',            -- try to reuse windows/tabs when switching buffers
  tabstop       = 4,                   -- spaces per tab as editor defualt
  textwidth     = 120,                 -- automatically hard wrap at 120 columns by default
  whichwrap     = 'b,h,l,s,<,>,[,],~', -- allow <BS>/h/l/<Left>/<Right>/<Space>, ~ to cross line boundaries
  -- wildcharm     = '<C-z>',             -- substitute for 'wildchar' (<Tab>) in macros
}

return edit

