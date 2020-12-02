local util = {}

--- Create an autocmd with group and table provided
---@param definiton A table defining a group and autocmds
---Example:
-- local autocmds = {
--    startup = {
--      { "VimEnter", "*", [[lua require('something')]] }
--    }
-- }
util.create_augroups = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup '..group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

--- extends table with depth
util.deep_extend = function(policy, ...)
  local result = {}
  local function helper(policy, k, v1, v2)
    if type(v1) ~= 'table' or type(v2) ~= 'table' then
      if policy == 'error' then
        error('Key ' .. vim.inspect(k) .. ' is already present with value ' .. vim.inspect(v1))
      elseif policy == 'force' then
        return v2
      else
        return v1
      end
    else
      return deep_extend(policy, v1, v2)
    end
  end

  for _, t in ipairs({...}) do
    for k, v in pairs(t) do
      if result[k] ~= nil then
        result[k] = helper(policy, k, result[k], v)
      else
        result[k] = v
      end
    end
  end

  return result
end

return util
