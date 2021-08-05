local dap = require("dap")
local fmt = string.format

local nnoremap = vim.keymap.nnoremap

local function get_file(prompt, path)
  return function()
    path = path or ""
    return vim.fn.input(prompt, vim.fn.getcwd() .. "/" .. path, "file")
  end
end

local function user_select(prompt, options)
  local choices = { prompt }
  for i, line in pairs(options) do
    if string.len(line) > 0 then
      table.insert(choices, fmt("%d %s", i, line))
    end

    local choice = vim.fn.inputlist(choices)
    if choice < 1 or choice > #options then
      return nil
    end

    return options[choice]
  end
end

local function find_exec_files(prompt, path, ignore_paths)
  return function()
    local ignores = ignore_paths or {}

    local cmd = { "fd", ".", path, "-t", "x" }
    for _, i in pairs(ignores) do
      table.insert(cmd, "-E")
      table.insert(cmd, i)
    end

    local output = vim.fn.system(cmd)
    local lines = vim.split(output, "\n")
    return user_select(prompt, lines)
  end
end

local function rust_crate()
  local metadata_json = vim.fn.system("cargo metadata --format-version 1 --no-deps")
  local metadata = vim.fn.json_decode(metadata_json)
  local target_dir = metadata.target_directory

  local results = {}
  for _, package in ipairs(metadata.packages) do
    for _, target in ipairs(package.targets) do
      if vim.tbl_contains(target.kind, "bin") then
        table.insert(results, target_dir .. "/debug/" .. target.name)
      end
    end
  end

  if #results == 1 then
    return results[1]
  end

  return user_select("Select target:", results)
end

-- Settings -------------------------------------------------------------------

-- setup ui
require("dapui").setup()

dap.set_log_level = "TRACE"

vim.g.dap_virtual_text = true

vim.fn.sign_define("DapBreakpointRejected", { text = "ﰸ", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpoint", { text = "⬤", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "➔", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

-- Adaptors -------------------------------------------------------------------

dap.adapters.lldb = {
  name = "lldb",
  type = "executable",
  attach = {
    pidProperty = "pid",
    pidSelect = "ask",
  },
  command = "lldb-vscode",
  env = {
    LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
  },
}

-- Configurations -------------------------------------------------------------

dap.configurations.rust = {
  {
    name = "Debug Crate",
    type = "lldb",
    request = "launch",
    program = function()
      return rust_crate()
    end,
  },
}

-- Mappings -------------------------------------------------------------------

-- Debug actions
nnoremap({ "<F5>", [[<cmd>lua require('dap').continue()<cr>]] })
nnoremap({ "<F10>", [[<cmd>lua require('dap').step_over()<cr>]] })
nnoremap({ "<F11>", [[<cmd>lua require('dap').step_into()<cr>]] })
nnoremap({ "<F12>", [[<cmd>lua require('dap').step_out()<cr>]] })

nnoremap({ "<leader>dc", [[<cmd>lua require('dap').continue()<cr>]] })
nnoremap({ "<leader>dl", [[<cmd>lua require('dap').step_over()<cr>]] })
nnoremap({ "<leader>dj", [[<cmd>lua require('dap').step_into()<cr>]] })
nnoremap({ "<leader>dk", [[<cmd>lua require('dap').step_out()<cr>]] })

nnoremap({ "<leader>bK", [[<cmd>lua require('dap').up()<cr>]] })
nnoremap({ "<leader>bJ", [[<cmd>lua require('dap').down()<cr>]] })

nnoremap({ "<F9>", [[<cmd>lua require('dap').toggle_breakpoint()<cr>]] })
nnoremap({ "<leader>db", [[<cmd>lua require('dap').toggle_breakpoint()<cr>]] })
nnoremap({ "<leader>dB", [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]] })
nnoremap({ "<leader>dm", [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]] })

nnoremap({ "<leader>dd", [[<cmd>lua require('dap').run_last()<cr>]] })
nnoremap({ "<leader>dq", [[<cmd>lua require('dap').diconnect()<cr>]] })
nnoremap({ "<leader>dQ", [[<cmd>lua require('dap').diconnect({restart = true})<cr>]] })

nnoremap({ "<leader>du", [[<cmd>lua require('dapui').toggle()<cr>]] })
