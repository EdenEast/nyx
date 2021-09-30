local dap = require("dap")

-- Languages
local modules = edn.path.modlist("eden.modules.protocol.dap.adaptors")
for _, mod in ipairs(modules) do
  require(mod)
end

-- setup ui
require("dapui").setup()

dap.set_log_level = "TRACE"

vim.g.dap_virtual_text = true

vim.fn.sign_define("DapBreakpointRejected", { text = "ﰸ", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpoint", { text = "⬤", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "➔", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

edn.keymap({
  { "<F5>", [[<cmd>lua require('dap').continue()<cr>]] },
  { "<F9>", [[<cmd>lua require('dap').toggle_breakpoint()<cr>]] },
  { "<F10>", [[<cmd>lua require('dap').step_over()<cr>]] },
  { "<F11>", [[<cmd>lua require('dap').step_into()<cr>]] },
  { "<F12>", [[<cmd>lua require('dap').step_out()<cr>]] },
  {
    "<leader>d",
    {
      { "c", [[<cmd>lua require('dap').continue()<cr>]] },
      { "l", [[<cmd>lua require('dap').step_over()<cr>]] },
      { "j", [[<cmd>lua require('dap').step_into()<cr>]] },
      { "k", [[<cmd>lua require('dap').step_out()<cr>]] },

      { "K", [[<cmd>lua require('dap').up()<cr>]] },
      { "J", [[<cmd>lua require('dap').down()<cr>]] },

      { "b", [[<cmd>lua require('dap').toggle_breakpoint()<cr>]] },
      { "B", [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]] },
      { "m", [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]] },

      { "d", [[<cmd>lua require('dap').run_last()<cr>]] },
      { "q", [[<cmd>lua require('dap').disconnect()<cr>]] },
      { "Q", [[<cmd>lua require('dap').disconnect({restart = true})<cr>]] },

      { "h", [[<cmd>lua require('dap.ui.widgets').hover()<cr>]] },

      { "u", [[<cmd>lua require('dapui').toggle()<cr>]] },
    },
  },
})
