local util = require('util')

local function setup()
  vim.g.lightline = {
    colorscheme = 'wombat',
    active = {
      left = {
        {'mode', 'paste'},
        {'fugitive', 'readonly', 'filename', 'modified'}
      },
      right = {
        { 'lineinfo', 'percent' },
        { 'lspstatus', 'cocstatus'},
        { 'method', 'filetype' },
      }
    },
    component = {
      lineinfo = '%3l:%-2v',
    },
    component_type = {
      readonly = 'error',
      linter_warnings = 'warning',
      linter_errors = 'error',
    },
    component_function = {
      filename  = 'eden#lightline#filename',
      readonly  = 'eden#lightline#read_only',
      fugitive  = 'eden#lightline#fugitive',
      method    = 'eden#lightline#vista_nearest_func',
      cocstatus = 'coc#status',
      lspstatus = 'eden#lightline#lsp',
      currentfunction = 'CocCurrentFunction',
    },
  }

  local autocmds = {
    lightline = {
      { 'User', 'CocStatusChange,CocDiagnosticChange', [[call lightline#update()]] }
    }
  }
  util.create_augroups(autocmds)
end

return {
  setup = setup
}
