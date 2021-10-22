local event = require("eden.core.event")

event.aug({
  user_packer = {
    {
      "BufWritePost",
      "*/lua/eden/modules/*",
      function()
        require("eden.core.pack").auto_compile()
      end,
    },
  },

  user_bufs = {
    { "BufWritePre", "/tmp/*", "setlocal noundofile" },
    { "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
    { "BufWritePre", "MERGE_MSG", "setlocal noundofile" },
    { "BufWritePre", "*.tmp,*.bak", "setlocal noundofile" },
    { "BufRead", "*.orig", "setlocal readonly" },
  },

  wins = {
    -- Highlight current line only on focused window
    {
      { "WinEnter", "BufEnter", "InsertLeave" },
      [[if ! &cursorline && &filetype !~# '^\(dashboard\|startify\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
    },
    {
      { "WinLeave", "BufLeave", "InsertEnter" },
      [[if &cursorline && &filetype !~# '^\(dashboard\|startify\|clap_\)' && ! &pvw | setlocal nocursorline | endif]],
    },
    -- Equalize window dimensions when resizing vim window
    { "VimResized", [[tabdo wincmd =]] },
    -- Force write shada on leaving nvim
    { "VimLeave", [[if has('nvim') | wshada! | else | wviminfo! | endif]] },
    -- Check if file changed when its window is focus, more eager than 'autoread'
    { "FocusGained", "checktime" },
    -- Change project root when switching tabs
    { "TabEnter", [[ProjectRoot]] },
  },

  user_yank = {
    {
      "TextYankPost",
      function()
        vim.highlight.on_yank({ hlgroup = "IncSearch", timeout = 300 })
      end,
    },
  },

  user_whitespace = {
    { "BufWinEnter", "match Error /\\s\\+%#@<!$/" },
    { "InsertEnter", "match Error /\\s\\+%#@<!$/" },
    { "InsertLeave", "match Error /\\s\\+$/" },
  },

  user_linereturn = {
    { "BufReadPost", "*", [[if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif]] },
  },

  user_toggle = {
    {
      { "BufEnter", "FocusGained", "InsertLeave" },
      function()
        require("eden.core.util").set_relnumber()
      end,
    },
    {
      { "BufLeave", "FocusLost", "InsertEnter" },
      function()
        require("eden.core.util").set_no_relnumber()
      end,
    },
  },
})
