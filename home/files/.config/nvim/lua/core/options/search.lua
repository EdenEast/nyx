local backskip = vim.o.backupskip
local wignore = vim.o.wildignore

local search = {
  backupskip = backskip            -- prevent bsb's watch mode from getting confused
            .. '*.re,*.rei',
  ignorecase = true,               -- ignore case in search
  incsearch  = true,               -- do incremental searching
  smartcase  = true,               -- use case sensitive search if capital letter is present
  inccommand = 'split',            -- line preview of :s results
  wildignore = wignore             -- patters to ignore during file-navigation
            .. '*.o,*.rej',
  wildmenu   = true,               -- show options as list when switching buffers etc
  wildmode   = 'longest:full,full' -- shell-like autocomplete to unambiguous portions
}

return search
