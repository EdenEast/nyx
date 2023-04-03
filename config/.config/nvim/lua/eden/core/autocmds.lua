local function augroup(name) return vim.api.nvim_create_augroup("eden_" .. name, { clear = true }) end

-- Check if file changed when its window is focus, more eager than 'autoread'
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = augroup("highlight_yank"),
  callback = function() vim.highlight.on_yank() end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- match trailing whitespace when in normal mode
local group_trailing_whitespace = augroup("trailing_whitespace")
vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertEnter" }, {
  group = group_trailing_whitespace,
  command = "match Error /\\s\\+%#@<!$/",
})

-- unmatch trailing whitespace when in inser mode
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  group = augroup("trailing_whitespace"),
  command = "match Error /\\s\\+$/",
})

-- set cursorline only in the current pane
local group_cursor_line = augroup("cursor_line")
vim.api.nvim_create_autocmd({ "WinEnter", "InsertLeave" }, {
  group = group_cursor_line,
  callback = function() require("eden.util").set_cursor_line(true) end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "InsertEnter" }, {
  group = group_cursor_line,
  callback = function() require("eden.util").set_cursor_line(false) end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
