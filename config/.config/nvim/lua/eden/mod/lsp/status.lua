-- Not used anymore

local nvim_status = require("lsp-status")
local status = {}

status.select_symbol = function(cursor_pos, symbol)
  if symbol.valueRange then
    local value_range = {
      ["start"] = {
        character = 0,
        line = vim.fn.byte2line(symbol.valueRange[1]),
      },
      ["end"] = {
        character = 0,
        line = vim.fn.byte2line(symbol.valueRange[2]),
      },
    }

    return require("lsp-status.util").in_range(cursor_pos, value_range)
  end
end

status.activate = function(register)
  nvim_status.config({
    select_symbol = status.select_symbol,
    kind_labels = require("eden.mod.lsp.kind").icons,

    indicator_errors = "",
    indicator_warnings = "",
    indicator_info = "🛈",
    indicator_hint = "!",
    indicator_ok = "",
    spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
    status_symbol = " ◦", -- ~ ◉ ⭗
    diagnostics = vim.g.current_statusline == "lualine",
  })

  local should_register = true
  if type(register) == "boolean" then
    should_register = register
  end

  if should_register then
    nvim_status.register_progress()
  end
end

status.on_attach = function(client)
  nvim_status.on_attach(client)

  if client.server_capabilities.documentSymbolProvider then
    -- TODO: edn.au handle buffer
    vim.cmd([[augroup lsp_status]])
    vim.cmd([[  autocmd CursorHold,BufEnter <buffer> lua require('lsp-status').update_current_function()]])
    vim.cmd([[augroup END]])
  end
end

status.capabilities = nvim_status.capabilities

return status
