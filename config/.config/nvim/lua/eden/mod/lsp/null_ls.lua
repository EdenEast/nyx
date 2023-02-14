local platform = require("eden.core.platform")
local path = require("eden.core.path")
local nls = require("null-ls")
local util = require("null-ls.utils")
local help = require("null-ls.helpers")

local diagnostic = nls.builtins.diagnostics
local formatting = nls.builtins.formatting
-- local hover = nls.builtins.hover
-- local actions = nls.builtins.code_actions

local function exists(bin)
  return vim.fn.exepath(bin) ~= ""
end

local with = {
  shfmt = {
    extra_args = { "-ci", "-i", "2", "-s" },
  },
  stylua = {
    cwd = help.cache.by_bufnr(function(params)
      return util.root_pattern(".git", "stylua.toml")(params.bufname)
    end),
    extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
  },
  vale = {
    extra_args = { "--config", path.join(path.home, ".config", "vale", "config.ini") },
  },
  write_good = {
    filetypes = { "markdown", "text" },
  },
}

-- These are added in my neovim.nix module
local sources = {
  -- general
  formatting.trim_newlines,
  formatting.trim_whitespace,
}

if not platform.is.win then
  sources = {
    -- general
    formatting.trim_newlines,
    formatting.trim_whitespace,

    -- js,ts
    formatting.prettierd,

    -- sh
    diagnostic.shellcheck,
    formatting.shfmt.with(with.shfmt),

    -- lua
    -- diagnostic.selene.with(with.selene),
    formatting.stylua.with(with.stylua),
  }
end

local function check(bin, value)
  if exists(bin) then
    table.insert(sources, value)
  end
end

if platform.is.win then
  -- js,ts
  check("prettierd", formatting.prettierd)

  -- sh
  check("shellcheck", diagnostic.shellcheck)
  check("shfmt", formatting.shfmt.with(with.shfmt))

  --lua
  -- check("selene", diagnostic.selene.with(with.selene))
  check("stylua", formatting.stylua.with(with.stylua))
end

-- markdown, text
-- check("vale", diagnostic.vale.with(with.vale))
check("proselint", diagnostic.proselint)

nls.setup({
  sources = sources,
  debounce = 1000,
  default_timeout = 3000,
  fallback_severity = vim.diagnostic.severity.WARN,
  on_attach = function(client)
    if client.server_capabilities.documentFormattingProvider then
      augroup("LspAutoFormatting", {
        event = "BufWritePre",
        buffer = true,
        exec = function()
          require("eden.mod.lsp.extensions.format").format()
        end,
      })
    end
  end,
})
