local M = {}

M.plugins = {
  {
    "nvim-telescope/telescope.nvim",
    opt = true,
    setup = function()
      require("eden.lib.defer").add("telescope.nvim", 70)
    end,
    config = function()
      require("eden.modules.nav.telescope.setup")
    end,
    requires = {
      { "nvim-lua/popup.nvim", opt = true },
      { "nvim-lua/plenary.nvim", opt = true },
      { "nvim-telescope/telescope-fzy-native.nvim", opt = true },
      { "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua", opt = true }, opt = true },
    },
  },

  {
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("eden.modules.nav.nvimtree")
    end,
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
    keys = { "<leader>te" },
  },

  -- {
  --   "folke/trouble.nvim",
  --   config = function()
  --     require("eden.modules.nav.trouble")
  --   end,
  --   requires = "kyazdani42/nvim-web-devicons",
  -- },

  {
    "theprimeagen/harpoon",
    requires = "nvim-lua/plenary.nvim",
    disable = true,
    config = function()
      require("eden.modules.nav.harpoon")
    end,
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
