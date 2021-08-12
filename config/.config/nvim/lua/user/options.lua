local global = require("core.global")
local path = require("core.path")

local opt = vim.opt

local backup = path.join(global.cachehome, "backup")
local swap = path.join(global.cachehome, "swap")
local undo = path.join(global.cachehome, "undo")
local view = path.join(global.cachehome, "view")

path.create(backup)
path.create(swap)
path.create(undo)
path.create(view)

-- Cached directories
opt.backupdir = backup
opt.directory = swap
opt.undodir = undo
opt.undofile = true
opt.viewdir = view

opt.autoindent = true -- maintain indent of current line
opt.belloff = "all" -- I NEVER want to hear this bell for ANY reason
opt.clipboard = "unnamedplus" -- use '+' register for all yanks, and deletes
opt.cursorline = true -- highlight current line
opt.expandtab = true -- always use spaces instead of tabs
opt.foldlevelstart = 99 -- start unfolded
opt.hidden = true -- allows you to hide buffers with unsaved changes without being prompted
opt.ignorecase = true -- ignore case in search
opt.inccommand = "split" -- line preview of :s results
opt.incsearch = true -- do incremental searching
opt.joinspaces = true -- don't autoinsert two spaces after '.', '?', '!' for join command
opt.laststatus = 2 -- always show status line
opt.lazyredraw = true -- dont bother updating screen durring macro playback
opt.linebreak = true -- wrap long lines at characters in 'breakat'
opt.list = true -- show whitespace
opt.modelines = 5 -- scan this many lines looking for modeline
opt.mouse = "a" -- automatically enable mouse usage
opt.number = true -- dont show numbers by default. if I need it I can toggle with maps
-- opt.pumblend = 15 -- pseudo-transparency for popup window
opt.relativenumber = false -- dont show relnumbers by default. if I need numbers I can toggle with maps
opt.scrolloff = 3 -- start scrolling 3 lines before edge of view port
opt.shiftround = true -- always indent by multiple of shiftwidth
opt.shiftwidth = 4 -- spaces per tab (when shifting)
opt.showbreak = "↳ " -- downwards arrow with tip rightwards(U+21B3, UTF-8: E2 86 B3)
opt.showcmd = false -- dont show extra info at end of command line
opt.showmode = false -- I have a status line for this
opt.sidescrolloff = 3 -- same as 'scrolloff' but for columns
opt.signcolumn = "number" -- always show sign column. currently there is a visual desync when this is auto. (#14195)
opt.smartcase = true -- use case sensitive search if capital letter is present
opt.smarttab = true -- <tab><bs> indent/deindent in leading whitespace
opt.softtabstop = -1 -- use 'shiftwidth' for tab/bs at end of line
opt.spellcapcheck = "" -- dont check for capital letters at the start of sentences
opt.splitbelow = true -- open horizontal splits below the current one
opt.splitright = true -- open vertical splits right of the current one
opt.switchbuf = "usetab" -- try to reuse windows/tabs when switching buffers
opt.synmaxcol = 200 -- dont bother syntax highlighting long lines
opt.tabstop = 4 -- spaces per tab as editor defualt
opt.textwidth = 120 -- automatically hard wrap at 120 columns by default
opt.title = true -- the title of the window to 'titlestring'
opt.ttyfast = true -- let vim know that I am using a fast term
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
opt.visualbell = false -- stop beeping for non-error errors, please god
opt.wildmenu = true -- show options as list when switching buffers etc

opt.fillchars = {
  vert = "┃", -- BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
  fold = "·", -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
}

opt.formatoptions = opt.formatoptions -- :help fo-table
  - "a" -- dont autoformat
  - "t" -- dont autoformat my code, have linters for that
  + "c" -- auto wrap comments using textwith
  + "q" -- formmating of comments w/ `gq`
  + "l" -- long lines are not broken up
  + "j" -- remove comment leader when joning comments
  + "r" -- continue comment with enter
  - "o" -- but not w/ o and o, dont continue comments
  + "n" -- smart auto indenting inside numbered lists
  - "2" -- this is not grade school anymore

-- TODO: Currently not supported
-- opt.highlight = opt.highlight
--   + '@:Conceal'  -- ~/@ at end of window, 'showbreak'
--   + 'N:DiffText' -- make current line number stand out a little
--   + 'c:LineNr'   -- blend vertical separators with line numbers

opt.listchars = opt.listchars
  + "nbsp:⦸" -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
  + "tab:▷┅" -- WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
  + "extends:»" -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
  + "precedes:«" -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
  + "trail:•" -- BULLET (U+2022, UTF-8: E2 80 A2)

opt.shortmess = opt.shortmess
  + "A" -- ignore annoying swapfile messages
  + "I" -- no spash screen
  + "O" -- file-read message overrites previous
  + "T" -- truncate non-file messages in middle
  + "W" -- dont echo '[w]/[written]' when writing
  + "a" -- use abbreviations in message '[ro]' instead of '[readonly]'
  + "o" -- overwrite file-written mesage
  + "t" -- truncate file messages at start
  + "c" -- dont show matching messages

opt.whichwrap = opt.whichwrap -- crossing line boundaries
  + "b" -- <BS> N & V
  + "s" -- <Space> N & V
  + "h" -- `h` N & V
  + "l" -- `l` N & V
  + "<" -- <Left> N & V
  + ">" -- <Right> N & V
  + "[" -- <Left> I & R
  + "]" -- <Right> I & R

opt.wildmode = { -- shell-like autocomplete to unambiguous portions
  "longest",
  "list",
  "full",
}
