local M = {}

local buf = nil
local content = {}

---@return number bufnr
local function create_buffer()
  local bufnr = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
  vim.api.nvim_buf_set_name(bufnr, "DPrint")

  return bufnr
end

function M.clear()
  if not buf then return end
  content = {}
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, {})
end

function M.print(...)
  for _, v in ipairs({ ... }) do
    if type(v) == "table" then
      content[#content + 1] = vim.inspect(v)
    else
      table.insert(content, tostring(v))
    end
  end
end

function M.open()
  if not buf then buf = create_buffer() end

  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, content)
end

function M.open()
  if not buf then buf = create_buffer() end

  vim.api.nvim_buf_set_lines(buf, 0, -1, true, content)
  vim.api.nvim_set_current_buf(buf)
end

local buffer = create_buffer()

return M
