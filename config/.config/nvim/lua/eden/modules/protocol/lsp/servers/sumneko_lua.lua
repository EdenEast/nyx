local nlsp = require("lspconfig")

local M = {}

M.setup = function(config, _, opts)
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
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim", "P", "edn" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  }

  if opts.cmd then
    config.cmd = opts.cmd
  end

  return config
end

return M
