local global = require('core.global')

local util = {}

util.join = function(tbl, delm)
  local result = tbl[1]
  for i, v in pairs(tbl) do
    if not (i == 1) then
      result = result .. delm .. v
    end
  end

  return result
end

util.exec_line = function()
  local ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local line = vim.api.nvim_get_current_line()

  if ft == 'lua' then
    local cmd = string.format('execute(":lua %s")', line)
    vim.cmd(cmd)
  elseif ft == 'vim' then
    local cmd = 'execute ' .. line
    vim.cmd(cmd)
  end
end

util.exec_file = function()
  local ft = vim.api.nvim_buf_get_option(0, 'filetype')
  vim.cmd('silent! write')

  if ft == 'lua' then
    vim.cmd('luafile %')
  elseif ft == 'vim' then
    vim.cmd('source %')
  end
end

-- Open url cross platform
util.open_url = function(url)
  if global.is_windows then
    vim.cmd([[:execute 'silent !start ]] .. url .. "'")
  elseif global.is_wsl then
    vim.cmd([[:execute 'silent !powershell.exe start ]] .. url .. "'")
  elseif global.is_mac then
    vim.cmd([[:execute 'silent !open ]] .. url .. "'")
  elseif global.is_linux then
    vim.cmd([[:execute 'silent !xdg-open ]] .. url .. "'")
  else
    print('Unknown platform. Cannot open url')
  end
end

util.open_url_under_cursor = function()
  local cword = vim.fn.expand('<cWORD>')

  -- Remove surronding quotes if exist
  local url = string.gsub(cword, [[.*['"](.*)['"].*$]], "%1")

  -- If string starts with https://
  if string.match(url, [[^https://.*]]) then
    return util.open_url(url)
  end

  -- If string matches `user/repo`
  if string.match(url, [[.*/.*]]) then
    return util.open_url('https://github.com/' .. url)
  end
end

return util
