local overrides = {
  literal = {
    justfile = "just",
    Justfile = "just",
  },
  extensions = {
    tl = "teal",
  },
}

local function init()
  local pack = require("eden.core.pack")
  pack.ensure("nathom", "filetype.nvim", {
    callback = function()
      require("filetype").setup({
        overrides = overrides,
      })
      vim.g.did_load_filetypes = 1
    end,
  })
end

init()
