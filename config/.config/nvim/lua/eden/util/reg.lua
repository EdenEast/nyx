local M = {}

local function get_winopts()
  local ui = vim.api.nvim_list_uis()[1]
  return {
    relative = "editor",
    width = math.floor(ui.width * 0.8),
    height = math.floor(ui.height * 0.8),
    row = math.floor(ui.height * 0.1),
    col = math.floor(ui.width * 0.1),
    style = "minimal",
    border = "single",
  }
end

local function getchar()
  local i = vim.fn.getchar()
  return vim.fn.nr2char(i)
end

local function create_register_list()
  local registers = { '"', "-", "#", "=", "/", "*", "+", ":", ".", "%", "#" }
  for i = 0, 9 do
    table.insert(registers, tostring(i))
  end
  for i = 97, 122 do
    table.insert(registers, string.char(i))
  end
  return registers
end

local function create_register_items()
  local items = {}

  local registers = create_register_list()
  for _, register in ipairs(registers) do
    local content = vim.fn.getreg(register)
    local regtype = vim.fn.getregtype(register)

    local entry = {
      register = register,
      content = content,
      regtype = regtype,
    }

    table.insert(items, entry)
  end

  return items
end

local function save_data(file, data)
  local content = vim.fn.json_encode(data)
  local fd = io.open(file, "w")
  if not fd then
    vim.notify("Unable to open file for writing: " .. file)
    return
  end

  fd:write(content)
  io.close(fd)
end

local function load_data(file)
  local fd = io.open(file, "r")
  if not fd then
    vim.notify("Unable to open file for reading: " .. file)
    return {}
  end

  local content = fd:read("*a")
  io.close(fd)

  return vim.fn.json_decode(content)
end

function M.edit(reg)
  local char
  if not reg then
    print("Select register: ")
    char = getchar()
  else
    char = reg
  end

  local buffer = M.create_edit_buffer(char)

  local winopts = get_winopts()
  vim.api.nvim_open_win(buffer, true, winopts)
  vim.api.nvim_win_set_buf(0, buffer)
end

function M.create_edit_buffer(register)
  local bufnr = vim.api.nvim_create_buf(false, true)

  local regtype = vim.fn.getregtype(register)
  local content = vim.fn.getreg(register)
  content = type(regtype) == "string" and content:gsub("\n", "\\n") or content

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, { content })
  vim.api.nvim_set_option_value("modifiable", true, { buf = bufnr })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
  vim.api.nvim_buf_set_name(bufnr, "editing @" .. register)

  -- Set keymaps to close the buffer
  local delete_buf = function() vim.api.nvim_buf_delete(bufnr, { unload = true }) end
  vim.keymap.set("n", "<escape>", delete_buf, { buffer = bufnr })
  vim.keymap.set("n", "<c-c>", delete_buf, { buffer = bufnr })
  vim.keymap.set("n", "q", delete_buf, { buffer = bufnr })

  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    buffer = bufnr,
    callback = function(buf_opts)
      local buf_content = table.concat(vim.api.nvim_buf_get_lines(buf_opts.buf, 0, -1, true))
      local newcontent = buf_content:gsub("\\n", "\n")
      vim.fn.setreg(register, newcontent, regtype)

      vim.api.nvim_win_close(0, true)
    end,
  })

  return bufnr
end

-- local items = create_register_items()
--
-- vim.ui.select(items, {
--   prompt = "Select register: ",
--   format_item = function(item) return string.format([["%s  %s]], item.register, item.content) end,
-- }, function(register, _) print(register) end)

-- rename register
-- save register
-- load register

return M
