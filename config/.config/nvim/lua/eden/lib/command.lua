local M = {}

local function err(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local function validate_command(name, command, opts)
  vim.validate({
    name = { name, "string" },
    command = { command, { "string", "function" } },
    opts = { opts, "table", true },
  })
end

---Create a user command
---@param name string
---@param command string|function
---@param opts table|nil
function M.cmd(name, command, opts)
  local ok, errmsg = pcall(validate_command, name, command, opts)
  if not ok then
    err(errmsg)
    return
  end

  opts = opts or {}

  if opts.buffer then
    local buffer = type(opts.buffer) == "number" and opts.buffer or 0
    opts.buffer = nil
    ok, errmsg = pcall(vim.api.nvim_buf_create_user_command, buffer, name, command, opts)
    if not ok then
      err(errmsg)
    end
  else
    ok, errmsg = pcall(vim.api.nvim_create_user_command, name, command, opts)
    if not ok then
      err(errmsg)
    end
  end
end

_G.command = M.cmd

return M
