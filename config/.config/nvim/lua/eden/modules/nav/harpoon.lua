-- nmap("<leader>j", function() require('harpoon.mark') end)
nmap("<leader>h", function()
  require("harpoon.ui").toggle_quick_menu()
end, { desc = "Show harpoon ui" })

nmap("<leader>H", function()
  require("harpoon.mark").add_file()
end, { desc = "Harpoon add file" })

nmap("<leader>j", function()
  require("harpoon.ui").nav_file(1)
end, { desc = "Harpoon nav 1" })

nmap("<leader>k", function()
  require("harpoon.ui").nav_file(2)
end, { desc = "Harpoon nav 2" })

nmap("<leader>l", function()
  require("harpoon.ui").nav_file(3)
end, { desc = "Harpoon nav 3" })

nmap("<leader>;", function()
  require("harpoon.ui").nav_file(4)
end, { desc = "Harpoon nav 4" })
