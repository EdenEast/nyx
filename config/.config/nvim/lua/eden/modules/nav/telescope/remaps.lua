local fmt = string.format

TelescopeMapArgs = TelescopeMapArgs or {}

local function map(key, func, opts, buffer)
  local map_key = vim.api.nvim_replace_termcodes(key .. func, true, true, true)

  TelescopeMapArgs[map_key] = opts or {}

  local mode = "n"
  local rhs = fmt(
    "<cmd>lua require('%s')['%s'](TelescopeMapArgs['%s'])<cr>",
    "eden.modules.nav.telescope",
    func,
    map_key
  )

  local map_opts = {
    noremap = true,
    silent = true,
  }

  if not buffer then
    vim.api.nvim_set_keymap(mode, key, rhs, map_opts)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_opts)
  end
end

-- Configuration files quick access
map("<leader>fn", "edit_dotfiles")
map("<leader>fN", "edit_neovim")

-- Searches
map("<leader>fp", "projects")
map("<leader>fr", "live_grep")
map("<leader>fh", "help_tags")

-- Files
map("<leader>fd", "git_files")
map("<leader>ff", "fd")
map("<leader>fo", "oldfiles")

-- Lsp
map("<leader>fs", "lsp_workspace_symbols")

-- Utility
map("<leader>fR", "reloader")
map("<leader>fB", "builtin")

vim.api.nvim_exec(
  [[
    augroup telescope
        autocmd!
        autocmd FileType TelescopePrompt inoremap <buffer> <silent> <C-r> <C-r>
    augroup END]],
  false
)
return map
