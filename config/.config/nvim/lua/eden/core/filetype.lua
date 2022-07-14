local overrides = {
  literal = {
    justfile = "just",
    Justfile = "just",
  },
}

local function init()
  local pack = require("eden.core.pack")
  pack.ensure("nathom", "filetype.nvim", function()
    require("filetype").setup({
      overrides = overrides,
    })
    vim.g.did_load_filetypes = 1
  end)
end

init()
