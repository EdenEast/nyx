local options = { "nvimtree", "neotree" }
local choice = 1
return require("eden.mod.filetree." .. options[choice])
