local is_lazy, _ = pcall(require, "lazy")
if not is_lazy then
require("eden.lib.defer").immediate_load({
  "nvim-dap-virtual-text",
  "nvim-dap-ui",
  "one-small-step-for-vimkind",
})
end

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

nmap("<F5>", [[<cmd>lua require('dap').continue()<cr>]], { desc = "Continue" })
nmap("<F9>", [[<cmd>lua require('dap').toggle_breakpoint()<cr>]], { desc = "Toggle breakpoint" })
nmap("<F10>", [[<cmd>lua require('dap').step_over()<cr>]], { desc = "Step over" })
nmap("<F11>", [[<cmd>lua require('dap').step_into()<cr>]], { desc = "Step into" })
nmap("<F12>", [[<cmd>lua require('dap').step_out()<cr>]], { desc = "Step out" })

nmap("<leader>dc", [[<cmd>lua require('dap').continue()<cr>]], { desc = "Continue" })
nmap("<leader>dl", [[<cmd>lua require('dap').step_over()<cr>]], { desc = "Step over" })
nmap("<leader>dj", [[<cmd>lua require('dap').step_into()<cr>]], { desc = "Step into" })
nmap("<leader>dk", [[<cmd>lua require('dap').step_out()<cr>]], { desc = "Step out" })

nmap("<leader>dK", [[<cmd>lua require('dap').up()<cr>]], { desc = "Move up" })
nmap("<leader>dJ", [[<cmd>lua require('dap').down()<cr>]], { desc = "Move down" })

nmap("<leader>db", [[<cmd>lua require('dap').toggle_breakpoint()<cr>]], { desc = "Toggle breakpoint" })
nmap(
  "<leader>dB",
  [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]],
  { desc = "Conditional breakpoint" }
)
nmap(
  "<leader>dm",
  [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]],
  { desc = "Log breakpoint" }
)

nmap("<leader>dd", [[<cmd>lua require('dap').run_last()<cr>]], { desc = "Run last" })
nmap("<leader>dq", [[<cmd>lua require('dap').disconnect()<cr>]], { desc = "Disconnect" })
nmap("<leader>dQ", [[<cmd>lua require('dap').disconnect({restart = true})<cr>]], { desc = "Restart" })

nmap("<leader>dh", [[<cmd>lua require('dap.ui.widgets').hover()<cr>]], { desc = "Hover" })
nmap("<leader>du", [[<cmd>lua require('dapui').toggle()<cr>]], { desc = "Toggle ui" })
