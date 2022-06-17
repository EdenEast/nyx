-- nmap("<leader>j", function() require('harpoon.mark') end)
nmap("<leader>h", function()
  require("harpoon.ui").toggle_quick_menu()
end)

nmap("<leader>H", function()
  require("harpoon.mark").add_file()
end)

nmap("<leader>j", function()
  require("harpoon.ui").nav_file(1)
end)

nmap("<leader>k", function()
  require("harpoon.ui").nav_file(2)
end)

nmap("<leader>l", function()
  require("harpoon.ui").nav_file(3)
end)

nmap("<leader>;", function()
  require("harpoon.ui").nav_file(4)
end)
