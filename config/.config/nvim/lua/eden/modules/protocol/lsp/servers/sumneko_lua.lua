local nlsp = require("lspconfig")

local M = {}

M.setup = function(config, _, opts)
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  config.cmd = { "lua-language-server" } -- nix installed wraps all of the comamnd line args needed
  config.root_dir = function(filename, _)
    local cwd = vim.fn.getcwd()
    if string.match(cwd, "nyx/config/.config") then
      return cwd
    end

    local util = nlsp.util
    return util.find_git_ancestor(filename) or util.path.dirname(filename)
  end

  config.settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim", "P", "edn" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  }

  -- This used to be used for nvim-lsp-installer when it was setting the cmd
  -- Now it just changes the path variable instead.
  if opts.cmd then
    config.cmd = opts.cmd
  end

  if opts.cmd_env then
    config.cmd_env = opts.cmd_env
  end

  return config
end

return M
