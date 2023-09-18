local Plat = require("eden.core.platform")
local fmt = string.format

local M = {}

local exec_file_by_type = {
  lua = "luafile %",
  python = "python3 %",
  vim = "source %",
}

function M.execute_file()
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  vim.cmd("silent! write")
  if exec_file_by_type[ft] then vim.cmd(exec_file_by_type[ft]) end
end

---Open a url in the default system browser
---@param url string
function M.open_url(url)
  if Plat.is.wsl then
    os.execute(fmt([[wslview "%s"]], url))
  elseif Plat.is.linux then
    os.execute(fmt([[xdg-open "%s"]], url))
  elseif Plat.is.mac then
    os.execute(fmt([[open "%s"]], url))
  elseif Plat.is.win then
    os.execute(fmt([[start "%s"]], url))
  else
    M.error("Unknown platform, could not determine url opener")
  end
end

function M.open_file_in_browser(file)
  file = file or vim.api.nvim_buf_get_name(0)
  if not string.starts_with(file, "file://") then file = "file://" .. file end

  if Plat.is.wsl then
    vim.cmd(fmt([[:execute '!wslview %s']], file))
  elseif Plat.is.mac then
    vim.cmd(fmt([[:execute '!open %s']], file))
  else
    M.error("Unsupported platform for opening file with browser")
  end
end

---Open the url under cursor
---@return nil
function M.open_url_under_cursor()
  local cword = vim.fn.expand("<cWORD>")
  local url = string.strip_quotes(cword)

  if string.starts_with(url, "https://") then return M.open_url(url) end
  if string.match(url, [[.*/.*]]) then return M.open_url("https://github.com/" .. url) end
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function() fn() end,
  })
end

---@param attach fun(any, number)
function M.on_attach(attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("eden_lsp_attach", { clear = true }),
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      attach(client, buffer)
    end,
  })
end

M.root_patterns = { ".git", "lua" }

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws) return vim.uri_to_fname(ws.uri) end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then roots[#roots + 1] = r end
      end
    end
  end
  table.sort(roots, function(a, b) return #a > #b end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- this will return a function that calls telescope.
-- cwd will default to eden.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

---@param msg string|string[]
---@param opts? LazyNotifyOpts
function M.notify(msg, opts)
  if vim.in_fast_event() then return vim.schedule(function() M.notify(msg, opts) end) end

  opts = opts or {}
  if type(msg) == "table" then
    msg = table.concat(vim.tbl_filter(function(line) return line or false end, msg), "\n")
  end
  local lang = opts.lang or "markdown"
  vim.notify(msg, opts.level or vim.log.levels.INFO, {
    on_open = function(win)
      pcall(require, "nvim-treesitter")
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, lang) then
        vim.bo[buf].filetype = lang
        vim.bo[buf].syntax = lang
      end
    end,
    title = opts.title or "lazy.nvim",
  })
end

---@param msg string|string[]
---@param opts? LazyNotifyOpts
function M.error(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.ERROR
  M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? LazyNotifyOpts
function M.info(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.INFO
  M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? LazyNotifyOpts
function M.warn(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.WARN
  M.notify(msg, opts)
end

---@param msg string|table
---@param opts? LazyNotifyOpts
function M.debug(msg, opts)
  if not require("lazy.core.config").options.debug then return end
  opts = opts or {}
  if opts.title then opts.title = "lazy.nvim: " .. opts.title end
  if type(msg) == "string" then
    M.notify(msg, opts)
  else
    opts.lang = "lua"
    M.notify(vim.inspect(msg), opts)
  end
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return M.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      M.info("Enabled " .. option, { title = "Option" })
    else
      M.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

local enabled = true
function M.toggle_diagnostics()
  enabled = not enabled
  if enabled then
    vim.diagnostic.enable()
    M.info("Enabled diagnostics", { title = "Diagnostics" })
  else
    vim.diagnostic.disable()
    M.warn("Disabled diagnostics", { title = "Diagnostics" })
  end
end

local cursorline_blacklist = {
  ["TelescopePromot"] = true,
}

---@param value boolean
function M.set_cursor_line(value)
  local filetype = vim.bo.filetype
  if cursorline_blacklist[filetype] ~= true then vim.wo.cursorline = value end
end

return M
