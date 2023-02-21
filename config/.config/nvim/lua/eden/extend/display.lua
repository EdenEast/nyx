local Display = {}

function Display.new()
  local self = setmetatable({}, {
    __index = Display,
  })
  self.instance = nil
  self.use_headings = true
  return self
end

function Display:open(force)
  if self.instance then
    if not force then
      return
    end
  end

  local original_buf = vim.api.nvim_get_current_buf()
  local original_win = vim.api.nvim_get_current_win()
  vim.cmd("100vnew [scratch]")
  self.instance = {
    buf = vim.api.nvim_get_current_buf(),
    win = vim.api.nvim_get_current_win(),
    ns = vim.api.nvim_create_namespace("eden.scratch_display"),
  }
  self.marks = {}
  vim.api.nvim_buf_set_option(self.instance.buf, "modifiable", false)
  vim.wo.previewwindow = true
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.bo.buftype = "nofile"
  vim.bo.undofile = false
  vim.api.nvim_set_current_win(original_win)
  vim.api.nvim_set_current_buf(original_buf)
  vim.api.nvim_buf_set_keymap(self.instance.buf, "n", "x", "", {
    callback = function()
      edn.display:clear()
    end,
    noremap = true,
  })
  vim.api.nvim_buf_set_keymap(self.instance.buf, "n", "q", "", {
    callback = function()
      edn.display:close()
    end,
    noremap = true,
  })
end

---@param f function
function Display:_modify_buffer(f)
  vim.api.nvim_buf_set_option(self.instance.buf, "modifiable", true)
  f()
  vim.api.nvim_buf_set_option(self.instance.buf, "modifiable", false)
end

function Display:write_with_header(header, ...)
  if not self.instance then
    self:open()
  end

  if self.use_headings then
    self:_modify_buffer(function()
      local lines = vim.api.nvim_buf_line_count(self.instance.buf)
      local mark = vim.api.nvim_buf_set_extmark(self.instance.buf, self.instance.ns, lines - 1, 0, {
        virt_lines = { { { header, "Title" } } },
      })
    end)
  end
  self:write(...)
end

function Display:write(...)
  if not self.instance then
    self:open()
  end

  local t = { ... }
  self:_modify_buffer(function()
    for _, v in ipairs(t) do
      local lines = vim.split(vim.inspect(v), "\n")
      vim.api.nvim_buf_set_lines(self.instance.buf, -1, -1, true, lines)
    end
  end)
end

function Display:clear()
  if not self.instance then
    return
  end

  vim.api.nvim_buf_set_option(self.instance.buf, "modifiable", true)
  local marks = vim.api.nvim_buf_get_extmarks(self.instance.buf, self.instance.ns, 0, -1, {})
  for _, mark in ipairs(marks) do
    vim.api.nvim_buf_del_extmark(self.instance.buf, self.instance.ns, mark[1])
  end
  vim.api.nvim_buf_set_lines(self.instance.buf, 0, -1, true, {})
  vim.api.nvim_buf_set_option(self.instance.buf, "modifiable", false)
end

function Display:close()
  vim.api.nvim_win_close(self.instance.win, true)
  vim.api.nvim_buf_delete(self.instance.buf, { force = true })
  self.instance = nil
end

function Display:toggle_headings()
  self.use_headings = not self.use_headings
end

return Display
