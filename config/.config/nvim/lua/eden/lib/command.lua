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

  ok, errmsg = pcall(vim.api.nvim_create_user_command, name, command, opts or {})
  if not ok then
    err(errmsg)
  end
end

_G.command = M.cmd

return M
