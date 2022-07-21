local M = {
  rust = function(_)
    vim.cmd(
      [[autocmd BufEnter,BufWritePost <buffer> :lua require("eden.modules.protocol.lsp.extensions.inlay_hints").request({aligned = true, prefix = " » "}) ]]
    )
  end,

  lua = function(_)
    local filter = function(client)
      return client.name ~= "sumneko_lua"
    end
    require("eden.modules.protocol.lsp.extensions.format").add_ft_filter("lua", filter, false)
  end,

  cs = function(_)
    nmap("gd", function()
      require("omnisharp_extended").telescope_lsp_definitions()
    end, { buffer = true })
  end,
}

return setmetatable(M, {
  __index = function()
    return function() end
  end,
})
