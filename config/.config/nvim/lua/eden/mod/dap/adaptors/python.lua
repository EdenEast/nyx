local dap = require("dap")
local fmt = string.format

local function call(cmd) return vim.fn.system(cmd):gsub("\n$", "") end

local function get_python_path()
  -- Look for python path in this order:
  -- - $VIRTUAL_ENV env
  -- - venv or .venv in the current folder
  -- - venv or .venv in the git root folder
  -- - system python
  if vim.env.VIRTUAL_ENV then return vim.env.VIRTUAL_ENV end

  local function check_python_path(path)
    local folder_names = { "venv", ".venv" }

    for _, name in ipairs(folder_names) do
      local result = fmt("%s/%s/bin/python", path, name)
      if vim.fn.executable(result) == 1 then return result end
    end
    return nil
  end

  local cwd = vim.fn.getcwd()
  local cwd_result = check_python_path(cwd)
  if cwd_result then return cwd_result end

  if call("git rev-parse --is-inside-work-tree") == "true" then return call("git rev-parse --show-toplevel") end

  local system_py = call("which python")
  return system_py
end

dap.adapters.python = {
  type = "executable",
  command = "python3",
  args = { "-m", "debugpy.adaptor" },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",

    -- executes the current file
    program = "${file}",
    pythonPath = get_python_path(),
  },
}
