local function setup()
  vim.g.dashboard_default_executive = 'fzf'
  vim.g.dashboard_session_directory = vim.g.session_dir
  vim.api.nvim_exec(
    'autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2',
    false
  )
end

return {
  setup = setup
}
