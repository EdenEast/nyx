local M = {
  rust = function()
    vim.cmd(
      [[autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request { ]]
        .. [[aligned = true, prefix = " » " ]]
        .. [[} ]]
    )
  end,
}

return setmetatable(M, {
  __index = function()
    return function() end
  end,
})
