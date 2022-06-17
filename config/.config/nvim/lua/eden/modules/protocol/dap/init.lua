local dap = require("dap")

-- Languages
local modules = require("eden.lib.modlist").getmodlist("eden.modules.protocol.dap.adaptors", {})
for _, mod in ipairs(modules) do
  require(mod)
end

-- setup ui
require("dapui").setup()

dap.set_log_level = "TRACE"

require("nvim-dap-virtual-text").setup()

vim.fn.sign_define("DapBreakpointRejected", { text = "ﰸ", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpoint", { text = "⬤", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "➔", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

nmap("<F5>", [[<cmd>lua require('dap').continue()<cr>]])
nmap("<F9>", [[<cmd>lua require('dap').toggle_breakpoint()<cr>]])
nmap("<F10>", [[<cmd>lua require('dap').step_over()<cr>]])
nmap("<F11>", [[<cmd>lua require('dap').step_into()<cr>]])
nmap("<F12>", [[<cmd>lua require('dap').step_out()<cr>]])

nmap("<leader>dc", [[<cmd>lua require('dap').continue()<cr>]])
nmap("<leader>dl", [[<cmd>lua require('dap').step_over()<cr>]])
nmap("<leader>dj", [[<cmd>lua require('dap').step_into()<cr>]])
nmap("<leader>dk", [[<cmd>lua require('dap').step_out()<cr>]])

nmap("<leader>dK", [[<cmd>lua require('dap').up()<cr>]])
nmap("<leader>dJ", [[<cmd>lua require('dap').down()<cr>]])

nmap("<leader>db", [[<cmd>lua require('dap').toggle_breakpoint()<cr>]])
nmap("<leader>dB", [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]])
nmap("<leader>dm", [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]])

nmap("<leader>dd", [[<cmd>lua require('dap').run_last()<cr>]])
nmap("<leader>dq", [[<cmd>lua require('dap').disconnect()<cr>]])
nmap("<leader>dQ", [[<cmd>lua require('dap').disconnect({restart = true})<cr>]])

nmap("<leader>dh", [[<cmd>lua require('dap.ui.widgets').hover()<cr>]])
nmap("<leader>du", [[<cmd>lua require('dapui').toggle()<cr>]])
