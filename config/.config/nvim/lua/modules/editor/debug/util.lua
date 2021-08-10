local fmt = string.format

local M = {}

M.user_select = function(prompt, options)
  local choices = { prompt }
  for i, line in pairs(options) do
    if string.len(line) > 0 then
      table.insert(choices, fmt("%d %s", i, line))
    end

    local choice = vim.fn.inputlist(choices)
    if choice < 1 or choice > #options then
      return nil
    end

    return options[choice]
  end
end

M.basic_file_path = function()
  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

return M
