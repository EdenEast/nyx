local M = {}

M.exec_file = function()
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  vim.cmd("silent! write")

  if ft == "lua" then
    vim.cmd("luafile %")
  elseif ft == "python" then
    vim.cmd("!python %")
  elseif ft == "vim" then
    vim.cmd("source %")
  end
end

-- Open url cross platform
M.open_url = function(url)
  local plat = edn.platform
  if plat.is_windows then
    vim.cmd([[:execute 'silent !start ]] .. url .. "'")
  elseif plat.is_wsl then
    vim.cmd([[:execute 'silent !powershell.exe start ]] .. url .. "'")
  elseif plat.is_mac then
    vim.cmd([[:execute 'silent !open ]] .. url .. "'")
  elseif plat.is_linux then
    vim.cmd([[:execute 'silent !xdg-open ]] .. url .. "'")
  else
    print("Unknown platform. Cannot open url")
  end
end

M.open_url_under_cursor = function()
  local cword = vim.fn.expand("<cWORD>")

  -- Remove surronding quotes if exist
  local url = string.gsub(cword, [[.*['"](.*)['"].*$]], "%1")

  -- If string starts with https://
  if string.match(url, [[^https://.*]]) then
    return util.open_url(url)
  end

  -- If string matches `user/repo`
  if string.match(url, [[.*/.*]]) then
    return util.open_url("https://github.com/" .. url)
  end
end

return M
