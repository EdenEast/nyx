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

vim.api.nvim_exec([[
    augroup telescope
        autocmd!
        autocmd FileType TelescopePrompt inoremap <buffer> <silent> <C-r> <C-r>
    augroup END]], false)

-- edn.keymap("<leader>f", {
--   { "f", [[<cmd>Telescope find_files<cr>]] },
--   { "d", [[<cmd>Telescope git_files<cr>]] },
--   { "r", [[<cmd>Telescope live_grep<cr>]] },
--   { "s", [[<cmd>Telescope lsp_workspace_symbols<cr>]] },
--   { "b", [[<cmd>Telescope buffers<cr>]] },
--   { "B", [[<cmd>Telescope builtin<cr>]] },
--   { "h", [[<cmd>Telescope help_tags<cr>]] },
--   { "e", [[<cmd>Telescope file_browser<cr>]] },
--   { "q", [[<cmd>Telescope quickfix<cr>]] },
--   { "Q", [[<cmd>Telescope loclist<cr>]] },
--   {
--     "g",
--     {
--       { "b", [[<cmd>Telescope git_branches<cr>]] },
--       { "c", [[<cmd>Telescope git_commits<cr>]] },
--       { "l", [[<cmd>Telescope git_bcommits<cr>]] },
--       { "s", [[<cmd>Telescope git_status<cr>]] },
--     },
--   },
-- })

return map
