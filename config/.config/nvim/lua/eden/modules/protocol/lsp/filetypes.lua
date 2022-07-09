local M = {
  rust = function()
    vim.cmd(
      [[autocmd BufEnter,BufWritePost <buffer> :lua require("eden.modules.protocol.lsp.extensions.inlay_hints").request({aligned = true, prefix = " » "}) ]]
    )
  end,

  lua = function()
    local filter = function(clients)
      return vim.tbl_filter(function(client)
        return client.name ~= "sumneko_lua"
      end, clients)
    end
    require("eden.modules.protocol.lsp.extensions.format").add_ft_filter("lua", filter, false)
  end,
}

return setmetatable(M, {
  __index = function()
    return function() end
  end,
})
