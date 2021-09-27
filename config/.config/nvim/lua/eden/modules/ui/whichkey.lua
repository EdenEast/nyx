local wk = require("which-key")

vim.opt.timeoutlen = 300

wk.setup()
wk.register({
  ["space"] = "prev-buffer",
  ["!"] = "force-quit",
  w = "write-file",
  q = "quit-file",
  b = {
    name = "+buffer",
    e = "sort-extension",
    d = "sort-directory",
    l = "next",
    h = "prev",
    q = "quit",
  },
  c = {
    name = "+code",
    e = "list-diagnostics",
    -- f = "format",
    n = "rename",
  },
  d = {
    name = "+debug",
    b = "toggle-breakpoint",
    B = "conditional-breakpoint",
    c = "continue",
    d = "run-last",
    h = "hover",
    j = "step-into",
    J = "down-callstack",
    k = "step-out",
    K = "up-callstack",
    l = "step-over",
    m = "log-breakpoint",
    q = "disconnect",
    Q = "restart",
    u = "toggle-ui",
  },
  f = {
    name = "+find",
    b = "buffers",
    B = "buitins",
    d = "git-files",
    e = "file-explorer",
    f = "files",
    h = "help",
    q = "quickfix",
    Q = "locallist",
    r = "grep",
    s = "symbols",
    g = {
      name = "+git",
      b = "branches",
      c = "commits",
      l = "local-commits",
      s = "status",
    },
  },
  g = {
    name = "+git",
    a = "add-file",
    b = "blame-file",
    c = "create-commit",
    d = "diff-file",
    m = "commit-under-cursor",
    n = "neogit",
    p = "diff-pick",
    h = {
      name = "+hunk",
      b = "blame",
      p = "preview",
      r = "reset",
      s = "stage",
      u = "unstage",
    },
  },
  t = {
    name = "+toggle",
    e = "file-explorer",
    g = "git-blame-line",
    h = "search-highlight",
    n = "line-number",
    z = "zen",
  },
  x = {
    name = "+trouble",
    d = "document-diagnostics",
    l = "local-list",
    q = "quickfix",
    w = "workspace-diagnostics",
    x = "toggle",
  },
  ["1"] = "which_key_ignore",
  ["2"] = "which_key_ignore",
  ["3"] = "which_key_ignore",
  ["4"] = "which_key_ignore",
  ["5"] = "which_key_ignore",
  ["6"] = "which_key_ignore",
  ["7"] = "which_key_ignore",
  ["8"] = "which_key_ignore",
  ["9"] = "which_key_ignore",
}, {
  prefix = "<leader>",
})