local util = require('core.util')
local opt = vim.opt

local fillchars = {
  'vert:┃',        -- BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
  'fold:·',        -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
}

local highlight = {
  opt.highlight,
  '@:Conceal',     -- ~/@ at end of window, 'showbreak'
  'N:DiffText',    -- make current line number stand out a little
  'c:LineNr',      -- blend vertical separators with line numbers
}

local listchars = {
  'nbsp:⦸',        -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
  'tab:▷┅',        -- WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
  'extends:»',     -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
  'precedes:«',    -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
  'trail:•',       -- BULLET (U+2022, UTF-8: E2 80 A2)
}

local shortmess = {
  opt.shortmess,
  'A',             -- ignore annoying swapfile messages
  'I',             -- no spash screen
  'O',             -- file-read message overrites previous
  'T',             -- truncate non-file messages in middle
  'W',             -- dont echo '[w]/[written]' when writing
  'a',             -- use abbreviations in message '[ro]' instead of '[readonly]'
  'o',             -- overwrite file-written mesage
  't',             -- truncate file messages at start

}

opt.belloff        = 'all'                -- I NEVER want to hear this bell for ANY reason
opt.cursorline     = true                 -- highlight current line
opt.fillchars      = util.join(fillchars, ',')
opt.foldlevelstart = 99                   -- start unfolded
-- opt.highlight      = util.join(highlight, ',') -- TODO: Currently vim.o.highlight is not supported
opt.laststatus     = 2                    -- always show status line
opt.lazyredraw     = true                 -- dont bother updating screen durring macro playback
opt.list           = true                 -- show whitespace
opt.listchars      = util.join(listchars,  ',')
opt.number         = true                 -- dont show numbers by default. if I need it I can toggle with maps
opt.relativenumber = false                -- dont show relnumbers by default. if I need numbers I can toggle with maps
opt.signcolumn     = 'number'             -- always show sign column. currently there is a visual desync when this is auto. (#14195)
opt.scrolloff      = 3                    -- start scrolling 3 lines before edge of view port
opt.shortmess      = util.join(shortmess, '')
opt.showbreak      = '↳ '                 -- downwards arrow with tip rightwards(U+21B3, UTF-8: E2 86 B3)
opt.showcmd        = false                -- dont show extra info at end of command line
opt.showmode       = false                -- I have a status line for this
opt.sidescrolloff  = 3                    -- same as 'scrolloff' but for columns
opt.synmaxcol      = 200                  -- dont bother syntax highlighting long lines
opt.title          = true                 -- the title of the window to 'titlestring'
opt.ttyfast        = true                 -- let vim know that I am using a fast term
opt.virtualedit    = 'block'              -- allow cursor to move where there is no text in visual block mode
opt.visualbell     = false                -- stop beeping for non-error errors, please god

