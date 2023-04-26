local function bmap(lhs, rhs, opts)
  local mode = opts.mode or "n"
  opts.mode = nil
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

return {
  {
    "saecki/crates.nvim",
    event = { "BufReadPre Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-cmp" },
    init = function()
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = vim.api.nvim_create_augroup("eden_crates_cmp_source_cargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          require("cmp").setup.buffer({ sources = { { name = "crates" } } })

          bmap("K", function() require("crates").show_popup() end, { desc = "Help" })
          bmap("<localleader>p", function() require("crates").show_popup() end, { desc = "Toggle" })
          bmap("<localleader>t", function() require("crates").toggle() end, { desc = "Toggle" })
          bmap("<localleader>r", function() require("crates").reload() end, { desc = "Reload" })

          bmap("<localleader>f", function() require("crates").show_features_popup() end, { desc = "Features" })
          bmap("<localleader>v", function() require("crates").show_versions_popup() end, { desc = "Versions" })
          bmap("<localleader>d", function() require("crates").show_dependencies_popup() end, { desc = "Dependencies" })

          bmap("<localleader>u", function() require("crates").update_crate() end, { desc = "Update crate" })
          bmap("<localleader>U", function() require("crates").upgrade_crate() end, { desc = "Upgrade crate" })
          bmap(
            "<localleader>u",
            function() require("crates").update_crates() end,
            { desc = "Update crate", mode = "v" }
          )
          bmap(
            "<localleader>U",
            function() require("crates").upgrade_crates() end,
            { desc = "Upgrade crate", mode = "v" }
          )

          bmap("<localleader>a", function() require("crates").update_all_crates() end, { desc = "Update all crate" })
          bmap("<localleader>A", function() require("crates").upgrade_all_crates() end, { desc = "Upgrade all crate" })

          bmap("<localleader>H", function() require("crates").open_homepage() end, { desc = "Homepage" })
          bmap("<localleader>R", function() require("crates").open_repository() end, { desc = "Repository" })
          bmap("<localleader>D", function() require("crates").open_documentation() end, { desc = "Documentation" })
          bmap("<localleader>C", function() require("crates").open_crates_io() end, { desc = "Creates IO" })
        end,
      })
    end,
    config = function() require("crates").setup() end,
  },

  {
    "LhKipp/nvim-nu",
    ft = { "nu" },
    build = ":TSInstall nu",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  {
    "imsnif/kdl.vim",
    ft = "kdl",
  },

  {
    "NoahTheDuke/vim-just",
    ft = "just",
  },

  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
    ft = { "markdown", "vimwiki" },
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
  },

  {
    "tigion/nvim-asciidoc-preview",
    ft = { "asciidoc" },
    cmd = { "AsciiDocPreview" },
  },
}
