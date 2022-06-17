local remap = {
  samuraiRed = "#c94f6d",
}

local overrides = {
  NvimTreeNormal = { link = "NormalFloat" },
  NvimTreeNormalNC = { link = "NormalFloat" },
}

require("kanagawa").setup({
  overrides = overrides,
  colors = remap,
})
