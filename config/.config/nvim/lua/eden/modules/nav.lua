local M = {}

M.plugins = {
  {
    "nvim-telescope/telescope.nvim",
    opt = true,
    setup = function()
      require("eden.lib.defer").add("telescope.nvim", 70)
    end,
    conf = "nav.telescope.setup",
    requires = {
      { "nvim-lua/popup.nvim", opt = true },
      { "nvim-lua/plenary.nvim", opt = true },
      { "nvim-telescope/telescope-fzy-native.nvim", opt = true },
      { "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua", opt = true }, opt = true },
    },
  },

  {
    "kyazdani42/nvim-tree.lua",
    opt = true,
    setup = function()
      require("eden.lib.defer").add("nvim-tree.lua", 70)
    end,
    conf = "nav.nvimtree",
    requires = "kyazdani42/nvim-web-devicons",
  },

  -- {
  --   "folke/trouble.nvim",
  --   conf = "nav.trouble",
  --   requires = "kyazdani42/nvim-web-devicons",
  -- },

  {
    "theprimeagen/harpoon",
    requires = "nvim-lua/plenary.nvim",
    disable = true,
    conf = "nav.harpoon",
  },
}

M.before = function()
  -- This path comes from the nix. Check my `neovim.nix` file for more information
  local libsql_path = edn.path.join(edn.path.datahome, "lib", "libsqlite3.so")

  -- TODO: Check where sqlite is installed on windows
  if edn.path.exists(libsql_path) then
    vim.g.sqlite_found = true
    vim.g.sqlite_clib_path = edn.path.join(edn.path.datahome, "lib", "libsqlite3.so")
  end
end

M.after = function()
  -- Set the which-key descriptions as these are hidden behind packer lazy loading
  local has_wk, wk = pcall(require, "which-key")
  if has_wk then
    wk.register({
      ["<leader>te"] = "File tree",
    })
  end
end

return M
