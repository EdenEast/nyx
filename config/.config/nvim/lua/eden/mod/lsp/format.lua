local Util = require("eden.util")

local M = {}

M.autoformat = true

function M.toggle()
  if vim.b.autoformat == false then
    vim.b.autoformat = nil
    M.autoformat = true
  else
    M.autoformat = not M.autoformat
  end
  if M.autoformat then
    Util.info("Enabled format on save", { title = "Format" })
  else
    Util.warn("Disabled format on save", { title = "Format" })
  end
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b.autoformat == false then return end
  local ft = vim.bo[buf].filetype
  local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      if have_nls then return client.name == "null-ls" end
      return client.name ~= "null-ls"
    end,
  })
end

function M.on_attach(client, buf)
  -- dont format if client disabled it
  if
    client.config
    and client.config.capabilities
    and client.config.capabilities.documentFormattingProvider == false
  then
    return
  end

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
      buffer = buf,
      callback = function()
        if M.autoformat then M.format() end
      end,
    })
  end
end

return M
