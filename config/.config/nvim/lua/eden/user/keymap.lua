local keymap = require("eden.core.keymap")

keymap({
  silent = false,
  {
    -- 'j' and 'k' moves up and down visible lines in editor not actual lines
    -- This is noticable when text wraps to next line
    { "j", "gj" },
    { "k", "gk" },

    -- Read the current line and execute that in your $SHELL.  The resulting output of the command will replace the line
    -- that you were on. This is very handy. Also I dont use Ex mode.
    { "Q", [[!!$SHELL <cr>]] },

    -- Witn colemak having 'hjkl' all not on the home row, and all on the right
    -- index finger, having a 'nav' layer helpr with navigation
    {
      mode = "_",
      {
        { "<left>", "h" },
        { "<down>", "j" },
        { "<up>", "k" },
        { "<right>", "l" },
      },
    },

    -- Map Y to be the same as D and C
    { "Y", "yg_", mode = "nx" },

    -- Center search
    { "n", "nzzzv" },
    { "N", "Nzzzv" },

    -- Switch between the last two buffers
    { "<leader><leader>", [[<c-^>\"zz]] },

    -- Keep selection when indent/outdent
    { mode = "x", {
      { ">", ">gv" },
      { "<", "<gv" },
    } },

    -- Search for selected text
    { "*", '"xy/<c-r><cr>', mode = "x" },

    -- Clone paragraph
    { "cp", [[vap:t'><cr>{j]] },

    -- Redirect change operation to blackhole register
    { mode = "nx", {
      { "c", [["_c]] },
      { "C", [["_C]] },
    } },

    -- Toggle highlight search
    {
      "<leader>th",
      function()
        vim.opt.hlsearch = not vim.o.hlsearch
      end,
    },

    { "<leader>w", [[:<c-u>w<cr>]] },
    { "<leader>q", [[:<c-u>q<cr>]] },
    { "<leader>!", [[:<c-u>q!<cr>]] },

    {
      "<leader>tn",
      function()
        require("core.util").toggle_numbers()
      end,
    },

    -- Jump list -------------------------------------------------------------------
    -- Because currently in alacritty we cannot tell the difference between <tab>
    -- and <c-i> mapping <m-i> and <m-o> to go forward and backwards in the jump list
    --
    -- https://vi.stackexchange.com/a/23344
    { "<m-i>", "<c-i>" },
    { "<m-o>", "<c-o>" },

    { "[t", ":tabprevious<cr>" },
    { "]t", ":tabnext<cr>" },

    -- Move around splits without having to press <C-w> before each movement"
    { "<A-h>", "<cmd>lua require('eden.fn.winmove')('left')<cr>" },
    { "<A-j>", "<cmd>lua require('eden.fn.winmove')('down')<cr>" },
    { "<A-k>", "<cmd>lua require('eden.fn.winmove')('up')<cr>" },
    { "<A-l>", "<cmd>lua require('eden.fn.winmove')('right')<cr>" },

    -- Exec current file
    { "<F1>", ":lua require('eden.core.util').exec_file()<cr>" },
    { "<F2>", ":lua require('eden.core.util').open_url_under_cursor()<cr>" },
    -- { "<F3>", ":lua require('eden.core.pack').reload_plugins()<cr>" },

    {
      mode = "t",
      {
        -- Terminal
        { "<esc>", [[<c-\><c-n>]] },
        { "<c-q>", [[<c-\><c-n>:bdelete!<cr>]] },
        { "<c-h>", [[<c-\><c-n><c-w>h]] },
        { "<c-j>", [[<c-\><c-n><c-w>j]] },
        { "<c-k>", [[<c-\><c-n><c-w>k]] },
        { "<c-l>", [[<c-\><c-n><c-w>l]] },
      },
    },
  },
})
