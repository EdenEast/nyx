local fmt = string.format

local M = {}

M.user_select = function(prompt, options)
  local choices = { prompt }
  for i, line in ipairs(options) do
    if string.len(line) > 0 then table.insert(choices, fmt("%d %s", i, line)) end
  end

  local choice = vim.fn.inputlist(choices)
  if choice < 1 or choice > #options then return nil end

  return options[choice]
end

M.basic_file_path = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end

M.pass_env = function(additional)
  local vars = additional or {}
  for k, v in pairs(vim.fn.environ()) do
    table.insert(vars, fmt("%s=%s", k, v))
  end
  return vars
end

return M
