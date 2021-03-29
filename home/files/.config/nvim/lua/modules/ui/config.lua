local config = {}

function config.startify()
  vim.api.nvim_exec(
    [[
     autocmd! FileType startify
     autocmd FileType startify set laststatus=0 showtabline=0 | autocmd BufLeave <buffer> set laststatus=2 showtabline=1
     autocmd User Startified setlocal buflisted
    ]],
  false)
end

config.startify()

return config
