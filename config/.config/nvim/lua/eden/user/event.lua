
augroup("user_events", {
  -- Equalize window dimensions when resizing vim window
  {
    event = "VimResized",
    exec = "tabdo wincmd =",
  },

  -- Check if file changed when its window is focus, more eager than 'autoread'
  {
    event = "FocusGained",
    exec = "checktime",
  },

  -- Check if file changed when its window is focus, more eager than 'autoread'
  {
    event = "TabEnter",
    exec = "ProjectRoot",
  },

  -- Highlight yank with `IncSearch`
  {
    event = "TextYankPost",
    exec = function()
      vim.highlight.on_yank({ hlgroup = "IncSearch", timeout = 300 })
    end,
  },

  -- Match trailing whitespace when in normal mode
  {
    event = { "BufWinEnter", "InsertEnter" },
    exec = "match Error /\\s\\+%#@<!$/",
  },
  {
    event = "InsertLeave",
    exec = "match Error /\\s\\+$/",
  },

  -- Return to last position of buffer after it is read
  {
    event = "BufReadPost",
    exec = [[if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif]],
  },
})
