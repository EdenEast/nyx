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
          bmap("<leader>mp", function() require("crates").show_popup() end, { desc = "Toggle" })
          bmap("<leader>mt", function() require("crates").toggle() end, { desc = "Toggle" })
          bmap("<leader>mr", function() require("crates").reload() end, { desc = "Reload" })

          bmap("<leader>mf", function() require("crates").show_features_popup() end, { desc = "Features" })
          bmap("<leader>mv", function() require("crates").show_versions_popup() end, { desc = "Versions" })
          bmap("<leader>md", function() require("crates").show_dependencies_popup() end, { desc = "Dependencies" })

          bmap("<leader>mu", function() require("crates").update_crate() end, { desc = "Update crate" })
          bmap("<leader>mU", function() require("crates").upgrade_crate() end, { desc = "Upgrade crate" })
          bmap("<leader>mu", function() require("crates").update_crates() end, { desc = "Update crate", mode = "v" })
          bmap("<leader>mU", function() require("crates").upgrade_crates() end, { desc = "Upgrade crate", mode = "v" })

          bmap("<leader>ma", function() require("crates").update_all_crates() end, { desc = "Update all crate" })
          bmap("<leader>mA", function() require("crates").upgrade_all_crates() end, { desc = "Upgrade all crate" })

          bmap("<leader>mH", function() require("crates").open_homepage() end, { desc = "Homepage" })
          bmap("<leader>mR", function() require("crates").open_repository() end, { desc = "Repository" })
          bmap("<leader>mD", function() require("crates").open_documentation() end, { desc = "Documentation" })
          bmap("<leader>mC", function() require("crates").open_crates_io() end, { desc = "Creates IO" })
        end,
      })
    end,
    config = function() require("crates").setup() end,
  },
}
