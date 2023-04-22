local dap = require("dap")
local dutils = require("dap.utils")
local util = require("eden.mod.dap.util")

local function rust_crate()
  local metadata_json = vim.fn.system("cargo metadata --format-version 1 --no-deps")
  local metadata = vim.fn.json_decode(metadata_json)
  local target_dir = metadata.target_directory

  local results = {}
  for _, package in ipairs(metadata.packages) do
    for _, target in ipairs(package.targets) do
      if vim.tbl_contains(target.kind, "bin") then table.insert(results, target_dir .. "/debug/" .. target.name) end
    end
  end

  if #results == 1 then return results[1] end
  return util.user_select("Select target:", results)
end

local function lldb_init_commands()
  local sysroot = vim.fn.system("rustc --print sysroot"):gsub("\n", "")
  local path = sysroot .. "/lib/rustlib/etc"
  local lookup = string.format([[command script import "%s"/lldb_lookup.py]], path)
  local commands = string.format([[command source "%s"/lldb_commands]], path)
  local result = {
    lookup,
    commands,
  }

  return result
end

dap.adapters.lldb_rust = {
  name = "lldb",
  type = "executable",
  attach = {
    pidProperty = "pid",
    pidSelect = "ask",
  },
  command = "lldb-vscode",
  env = util.pass_env({
    LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
  }),
  initCommands = lldb_init_commands(),
}

dap.configurations.rust = {
  {
    name = "Debug Crate",
    type = "lldb_rust",
    request = "launch",
    program = function() return rust_crate() end,
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
