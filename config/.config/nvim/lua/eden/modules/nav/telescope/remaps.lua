local fmt = string.format

TelescopeMapArgs = TelescopeMapArgs or {}

local function map(key, func, opts, map_opts)
  local map_key = vim.api.nvim_replace_termcodes(key .. func, true, true, true)

  TelescopeMapArgs[map_key] = opts or {}

  local rhs = fmt(
    "<cmd>lua require('%s')['%s'](TelescopeMapArgs['%s'])<cr>",
    "eden.modules.nav.telescope",
    func,
    map_key
  )

  local default_map_opts = {
    noremap = true,
    silent = true,
  }
  map_opts = vim.tbl_deep_extend("force", map_opts or {}, default_map_opts)

  nmap(key, rhs, map_opts)
end

-- Configuration files quick access
map("<leader>fn", "edit_dotfiles", {}, { desc = "Dotfiles" })
map("<leader>fN", "edit_neovim", {}, { desc = "Neovim" })

-- Searches
map("<leader>fp", "projects", {}, { desc = "Projects" })
map("<leader>fr", "live_grep", {}, { desc = "Grep" })
map("<leader>fh", "help_tags", {}, { desc = "Help" })

-- Files
map("<leader>fd", "git_files", {}, { desc = "Git files" })
map("<leader>ff", "fd", {}, { desc = "Files" })
map("<leader>fo", "oldfiles", {}, { desc = "Old files" })

-- Utility
map("<leader>fR", "reloader", {}, { desc = "Reload lua module" })
map("<leader>fB", "builtin", {}, { desc = "Builtins" })

-- Add binding to paste with <c-r> like normal insert mode
augroup("telescope", {
  {
    event = "FileType",
    pattern = "TelescopePrompt",
    exec = "inoremap <buffer> <silent> <C-r> <C-r>",
  },
})

return map
