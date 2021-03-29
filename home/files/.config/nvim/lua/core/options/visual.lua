local util = require('core.util')

local listchars = {
  'nbsp:⦸',        -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
  'tab:▷┅',        -- WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
  'extends:»',     -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
  'precedes:«',    -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
  'trail:•',       -- BULLET (U+2022, UTF-8: E2 80 A2)
}

local shortmess = {
  vim.o.shortmess,
  'A',             -- ignore annoying swapfile messages
  'I',             -- no spash screen
  'O',             -- file-read message overrites previous
  'T',             -- truncate non-file messages in middle
  'W',             -- dont echo '[w]/[written]' when writing
  'a',             -- use abbreviations in message '[ro]' instead of '[readonly]'
  'o',             -- overwrite file-written mesage
  't',             -- truncate file messages at start

}

local visual = {
  belloff = 'all',                 -- I NEVER want to hear this bell for ANY reason
  cursorline = true,               -- highlight current line
  laststatus = 2,                  -- always show status line
  lazyredraw = true,               -- dont bother updating screen durring macro playback
  list = true,                     -- show whitespace
  listchars = util.join(listchars, ','),
  number = true,                   -- show line numbers in gutter
  relativenumber = true,           -- show relative numbers in the gutter
  scrolloff = 3,                   -- start scrolling 3 lines before edge of view port
  sidescrolloff = 3,               -- same as 'scrolloff' but for columns
  shortmess = util.join(shortmess, ''),
  showbreak = '↳ ',                -- downwards arrow with tip rightwards(U+21B3, UTF-8: E2 86 B3)
  showcmd = false,                 -- dont show extra info at end of command line
  showmode = false,                -- I have a status line for this
  synmaxcol = 200,                 -- dont bother syntax highlighting long lines
  title = true,                    -- the title of the window to 'titlestring'
  ttyfast = true,                  -- let vim know that I am using a fast term
  virtualedit = 'block',           -- allow cursor to move where there is no text in visual block mode
  visualbell = false,              -- stop beeping for non-error errors, please god
}

return visual
