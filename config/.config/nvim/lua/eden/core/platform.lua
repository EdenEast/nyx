local M = {}

local uname = vim.loop.os_uname()

local arch_aliases = {
  ["x86_64"] = "x64",
  ["i386"] = "x86",
  ["i686"] = "x86", -- x86 compat
  ["aarch64"] = "arm64",
  ["aarch64_be"] = "arm64",
  ["armv8b"] = "arm64", -- arm64 compat
  ["armv8l"] = "arm64", -- arm64 compat
}

M.arch = arch_aliases[uname.machine] or uname.machine
M.sysname = uname.sysname

local cached_features = {
  ["win"] = vim.fn.has("win32") == 1,
  ["win32"] = vim.fn.has("win32") == 1,
  ["win64"] = vim.fn.has("win64") == 1,
  ["mac"] = vim.fn.has("mac") == 1,
  ["unix"] = vim.fn.has("unix") == 1,
  ["linux"] = vim.fn.has("linux") == 1,
  ["wsl"] = vim.fn.has("wsl") == 1,
}

---@type table<string, boolean>
M.is = setmetatable({}, {
  __index = function(_, key)
    local os, arch = unpack(vim.split(key, "_", { plain = true }))
    if not cached_features[os] then return false end

    if arch and arch ~= M.arch then return false end

    return true
  end,
})

return M
