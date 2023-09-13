vim.g.mapleader = " "
vim.g.maplocalleader = ","

local opt = vim.opt

opt.autoindent = true -- maintain indent of current line
opt.breakindent = true -- continue indent visually
opt.belloff = "all" -- I NEVER want to hear this bell for ANY reason
-- opt.clipboard = "unnamedplus" -- use '+' register for all yanks, and deletes, sync with system clipboard
opt.confirm = true -- confirm to save changes before closing modified buffer
opt.completeopt = "menu,menuone,noselect"
opt.cursorline = true -- highlight current line
opt.colorcolumn = { "+1" }
opt.expandtab = true -- always use spaces instead of tabs
-- opt.foldlevelstart = 99 -- start unfolded
opt.foldenable = false
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.hidden = true -- allows you to hide buffers with unsaved changes without being prompted
opt.ignorecase = true -- ignore case in search
opt.inccommand = "split" -- line preview of :s results
opt.incsearch = true -- do incremental searching
opt.joinspaces = true -- don't autoinsert two spaces after '.', '?', '!' for join command
opt.laststatus = 3 -- use global statusline
-- opt.lazyredraw = true -- dont bother updating screen durring macro playback
opt.linebreak = true -- wrap long lines at characters in 'breakat'
opt.list = true -- show whitespace
opt.modelines = 5 -- scan this many lines looking for modeline
opt.mouse = "a" -- automatically enable mouse usage
opt.number = true -- dont show numbers by default. if I need it I can toggle with maps
-- opt.pumblend = 15 -- pseudo-transparency for popup window
opt.relativenumber = false -- dont show relnumbers by default. if I need numbers I can toggle with maps
opt.scrolloff = 3 -- start scrolling 3 lines before edge of view port
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" } -- what to store in the mksession command
opt.shiftround = true -- always indent by multiple of shiftwidth
opt.shiftwidth = 2 -- spaces per tab (when shifting)
opt.showbreak = "↳ " -- downwards arrow with tip rightwards(U+21B3, UTF-8: E2 86 B3)
opt.showcmd = false -- dont show extra info at end of command line
opt.showmode = false -- I have a status line for this
opt.sidescrolloff = 8 -- same as 'scrolloff' but for columns
opt.signcolumn = "number" -- always show sign column. currently there is a visual desync when this is auto. (#14195)
opt.smartcase = true -- use case sensitive search if capital letter is present
opt.smarttab = true -- <tab><bs> indent/deindent in leading whitespace
opt.softtabstop = -1 -- use 'shiftwidth' for tab/bs at end of line
opt.spellcapcheck = "" -- dont check for capital letters at the start of sentences
opt.splitbelow = true -- open horizontal splits below the current one
opt.splitright = true -- open vertical splits right of the current one
opt.switchbuf = "usetab" -- try to reuse windows/tabs when switching buffers
opt.synmaxcol = 200 -- dont bother syntax highlighting long lines
opt.tabstop = 2 -- spaces per tab as editor defualt
opt.termguicolors = true -- use 24bit colors in tui
opt.textwidth = 120 -- automatically hard wrap at 120 columns by default
opt.timeoutlen = 300 -- number of ms to wait for a mapped sequence to complete
opt.title = false -- the title of the window to 'titlestring'
opt.ttyfast = true -- let vim know that I am using a fast term
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
opt.visualbell = false -- stop beeping for non-error errors, please god
opt.wildmenu = true -- show options as list when switching buffers etc
opt.winbar = "%{%v:lua.require'eden.util.winbar'.generate()%}"
opt.undofile = true
opt.undolevels = 10000

opt.breakindentopt = {
  shift = 2, -- wrapped line's beginning will be shifted by the given number of
}

-- https://www.compart.com/en/unicode/U+XXXX (unicode character code)
-- stylua: ignore
opt.fillchars = {
  fold      = "·", -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
  horiz     = "━", -- BOX DRAWINGS HEAVY HORIZONTAL (U+2501, UTF-8: E2 94 81)
  horizdown = "┳", -- BOX DRAWINGS HEAVY DOWN AND HORIZONTAL (U+2533, UTF-8: E2 94 B3)
  horizup   = "┻", -- BOX DRAWINGS HEAVY UP AND HORIZONTAL (U+253B, UTF-8: E2 94 BB)
  vert      = "┃", -- BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
  vertleft  = "┫", -- BOX DRAWINGS HEAVY VERTICAL AND LEFT (U+252B, UTF-8: E2 94 AB)
  vertright = "┣", -- BOX DRAWINGS HEAVY VERTICAL AND RIGHT (U+2523, UTF-8: E2 94 A3)
  verthoriz = "╋", -- BOX DRAWINGS HEAVY VERTICAL AND HORIZONTAL (U+254B, UTF-8: E2 95 8B)
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
