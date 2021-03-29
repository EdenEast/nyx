local util = require('core.util')

local search = {
  ignorecase = true,               -- ignore case in search
  incsearch  = true,               -- do incremental searching
  smartcase  = true,               -- use case sensitive search if capital letter is present
  inccommand = 'split',            -- line preview of :s results
  wildmenu   = true,               -- show options as list when switching buffers etc
  wildmode   = 'longest:full,full' -- shell-like autocomplete to unambiguous portions
}

return search
