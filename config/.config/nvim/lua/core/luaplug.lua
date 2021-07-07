local M = {}

M.do_filetype = function(filetype)
  local ftplugins = vim.api.nvim_get_runtime_file(string.format("ftplugin/%s.lua", filetype), true)

  local f_env = setmetatable({
    -- Override print, so the prints still go through, otherwise it's confusing for people
    print = vim.schedule_wrap(print),
  }, {
    -- Buf default back read/write to whatever is going on in the global landscape
    __index = _G,
    __newindex = _G,
  })

  for _, file in ipairs(ftplugins) do
    local f = loadfile(file)
    if not f then
      vim.api.nvim_err_writeln("Unable to load file: " .. file)
    else
      local ok, msg = pcall(setfenv(f, f_env))

      if not ok then
        vim.api.nvim_err_writeln("Error while processing file: " .. file .. "\n" .. msg)
      end
    end
  end
end

M.source = function()
  for _, mod in ipairs(vim.api.nvim_get_runtime_file("lua/plugin/**/*.lua", true)) do
    local ok, msg = pcall(loadfile(mod))

    if not ok then
      print("Failed to load: ", mod)
      print("\t", msg)
    end
  end
end

M.setup = function()
  M.source()

  vim.augroup({
    luaplug = {
      { "Filetype", "*", ":lua require('core.luaplug').do_filetype(vim.fn.expand('<amatch>'))" },
    },
  })
end

return M
