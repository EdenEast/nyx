local dap = require("dap")
local nnoremap = vim.keymap.nnoremap

-- Languages
require("modules.editor.debug.cpp")
require("modules.editor.debug.lua")
require("modules.editor.debug.rust")

-- setup ui
require("dapui").setup()

dap.set_log_level = "TRACE"

vim.g.dap_virtual_text = true

vim.fn.sign_define("DapBreakpointRejected", { text = "ﰸ", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpoint", { text = "⬤", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "➔", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

nnoremap({ "<F5>", [[<cmd>lua require('dap').continue()<cr>]] })
nnoremap({ "<F10>", [[<cmd>lua require('dap').step_over()<cr>]] })
nnoremap({ "<F11>", [[<cmd>lua require('dap').step_into()<cr>]] })
nnoremap({ "<F12>", [[<cmd>lua require('dap').step_out()<cr>]] })

nnoremap({ "<leader>dc", [[<cmd>lua require('dap').continue()<cr>]] })
nnoremap({ "<leader>dl", [[<cmd>lua require('dap').step_over()<cr>]] })
nnoremap({ "<leader>dj", [[<cmd>lua require('dap').step_into()<cr>]] })
nnoremap({ "<leader>dk", [[<cmd>lua require('dap').step_out()<cr>]] })

nnoremap({ "<leader>dK", [[<cmd>lua require('dap').up()<cr>]] })
nnoremap({ "<leader>dJ", [[<cmd>lua require('dap').down()<cr>]] })

nnoremap({ "<F9>", [[<cmd>lua require('dap').toggle_breakpoint()<cr>]] })
nnoremap({ "<leader>db", [[<cmd>lua require('dap').toggle_breakpoint()<cr>]] })
nnoremap({ "<leader>dB", [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]] })
nnoremap({ "<leader>dm", [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]] })

nnoremap({ "<leader>dd", [[<cmd>lua require('dap').run_last()<cr>]] })
nnoremap({ "<leader>dq", [[<cmd>lua require('dap').disconnect()<cr>]] })
nnoremap({ "<leader>dQ", [[<cmd>lua require('dap').disconnect({restart = true})<cr>]] })

nnoremap({ "<leader>dh", [[<cmd>lua require('dap.ui.widgets').hover()<cr>]] })

nnoremap({ "<leader>du", [[<cmd>lua require('dapui').toggle()<cr>]] })
