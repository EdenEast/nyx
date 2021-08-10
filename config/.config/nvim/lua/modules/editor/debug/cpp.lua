local dap = require("dap")
local dutils = require("dap.utils")
local util = require("modules.editor.debug.util")

-- lldb adapter is defined in rust

dap.configurations.c = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return util.basic_file_path()
    end,
    args = {},
  },
  {
    -- If you get an "Operation not permitted" error using this, try disabling YAMA:
    --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    name = "Attach",
    type = "lldb",
    request = "attach",
    pid = dutils.pick_process,
    args = {},
  },
}

dap.configurations.cpp = dap.configurations.c
