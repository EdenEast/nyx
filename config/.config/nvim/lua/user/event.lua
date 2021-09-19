local global = require("core.global")

vim.aug({
  packer = {
    {
      "BufWritePost",
      string.format("%s/lua/modules/*.lua", global.confighome),
      "lua require('core.pack').auto_compile()",
    },
  },

  bufs = {
    { "BufWritePre", "/tmp/*", "setlocal noundofile" },
    { "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
    { "BufWritePre", "MERGE_MSG", "setlocal noundofile" },
    { "BufWritePre", "*.tmp,*.bak", "setlocal noundofile" },
    { "BufRead", "*.orig", "setlocal readonly" },
  },

  wins = {
    -- Highlight current line only on focused window
    {
      "WinEnter,BufEnter,InsertLeave",
      "*",
      [[if ! &cursorline && &filetype !~# '^\(dashboard\|startify\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
    },
    {
      "WinLeave,BufLeave,InsertEnter",
      "*",
      [[if &cursorline && &filetype !~# '^\(dashboard\|startify\|clap_\)' && ! &pvw | setlocal nocursorline | endif]],
    },
    -- Equalize window dimensions when resizing vim window
    { "VimResized", "*", [[tabdo wincmd =]] },
    -- Force write shada on leaving nvim
    { "VimLeave", "*", [[if has('nvim') | wshada! | else | wviminfo! | endif]] },
    -- Check if file changed when its window is focus, more eager than 'autoread'
    { "FocusGained", "checktime" },
  },

  yank = {
    { "TextYankPost", "*", [[silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=300})]] },
  },

  whitespace = {
    { "BufWinEnter", "*", "match Error /\\s\\+%#@<!$/" },
    { "InsertEnter", "*", "match Error /\\s\\+%#@<!$/" },
    { "InsertLeave", "*", "match Error /\\s\\+$/" },
  },

  linereturn = {
    { "BufReadPost", "*", [[if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif]] },
  },

  numtoggoe = {
    { "BufEnter,FocusGained,InsertLeave", "*", [[lua require('core.util').set_relnumber()]] },
    { "BufLeave,FocusLost,InsertEnter", "*", [[lua require('core.util').set_no_relnumber()]] },
  },
})
