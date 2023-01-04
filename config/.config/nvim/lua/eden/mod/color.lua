return {
  {
    "nvim-colortils/colortils.nvim",
    cmd = "Colortils",
    config = function()
      require("colortils").setup()
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
