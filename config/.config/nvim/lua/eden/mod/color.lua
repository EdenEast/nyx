return {
  {
    "nvim-colortils/colortils.nvim",
    cmd = "Colortils",
    keys = "<leader>tC",
    config = function()
      require("colortils").setup()
      nmap("<leader>tC", "<cmd>:ColorizerToggle<cr>", { desc = "colors" })
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    config = function()
      require("colorizer").setup({
        filetypes = {
          "html",
          "css",
          "sass",
          "vim",
          "typescript",
          "typescriptreact",
          "lua",
        },
        user_default_options = {
          names = false,
        },
      })
    end,
  },
}
