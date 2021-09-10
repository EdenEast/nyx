local keymap = vim.keymap
local nnoremap, xnoremap, tnoremap = keymap.nnoremap, keymap.xnoremap, keymap.tnoremap

-- 'j' and 'k' moves up and down visible lines in editor not actual lines
-- This is noticable when text wraps to next line
nnoremap({ "j", "gj" })
nnoremap({ "k", "gk" })

-- Witn colemak having 'hjkl' all not on the home row, and all on the right
-- index finger, having a 'nav' layer helpr with navigation
keymap.map({ "<left>", "h" })
keymap.map({ "<down>", "j" })
keymap.map({ "<up>", "k" })
keymap.map({ "<right>", "l" })

-- Map Y to be the same as D and C
nnoremap({ "Y", "yg_" })
xnoremap({ "Y", "yg_" })

-- Center search
nnoremap({ "n", "nzzzv" })
nnoremap({ "N", "Nzzzv" })

-- Switch between the last two buffers
nnoremap({ "<leader><leader>", "<c-^>" })

-- Keep selection when indent/outdent
xnoremap({ ">", ">gv" })
xnoremap({ "<", "<gv" })

-- Search for selected text
xnoremap({ "*", '"xy/<c-r><cr>' })

-- Clone paragraph
nnoremap({ "cp", [[yap<S-}>p]] })

-- Toggle highlight search
nnoremap({
  "<leader>th",
  function()
    vim.opt.hlsearch = not vim.o.hlsearch
  end,
})

nnoremap({ "<leader>w", [[:<c-u>w<cr>]] })
nnoremap({ "<leader>q", [[:<c-u>q<cr>]] })
nnoremap({ "<leader>!", [[:<c-u>q!<cr>]] })

nnoremap({
  "<leader>tn",
  function()
    require("core.util").toggle_numbers()
  end,
})

-- Jump list -------------------------------------------------------------------
-- Because currently in alacritty we cannot tell the difference between <tab>
-- and <c-i> mapping <m-i> and <m-o> to go forward and backwards in the jump list
--
-- https://vi.stackexchange.com/a/23344
nnoremap({ "<m-i>", "<c-i>" })
nnoremap({ "<m-o>", "<c-o>" })

nnoremap({ "[t", ":tabprevious<cr>" })
nnoremap({ "]t", ":tabnext<cr>" })

-- Move around splits without having to press <C-w> before each movement"
nnoremap({ "<c-h>", "<c-w>h" })
nnoremap({ "<c-j>", "<c-w>j" })
nnoremap({ "<c-k>", "<c-w>k" })
nnoremap({ "<c-l>", "<c-w>l" })

-- Exec current file
nnoremap({ "<F1>", ":lua require('core.util').exec_file()<cr>" })
nnoremap({ "<F2>", ":lua require('core.util').open_url_under_cursor()<cr>" })
nnoremap({ "<F3>", ":lua require('core.pack').reload_plugins()<cr>" })

-- Terminal
tnoremap({ "<esc>", [[<c-\><c-n>]] })
tnoremap({ "<c-q>", [[<c-\><c-n>:bdelete!<cr>]] })
tnoremap({ "<c-h>", [[<c-\><c-n><c-w>h]] })
tnoremap({ "<c-j>", [[<c-\><c-n><c-w>j]] })
tnoremap({ "<c-k>", [[<c-\><c-n><c-w>k]] })
tnoremap({ "<c-l>", [[<c-\><c-n><c-w>l]] })
