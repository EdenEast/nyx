return {
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
      or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
    },
    keys = {
      -- {
      --   "<tab>",
      --   function() return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>" end,
      --   expr = true,
      --   silent = true,
      --   mode = "i",
      -- },
      -- {
      --   "<tab>",
      --   function() require("luasnip").jump(1) end,
      --   mode = "s",
      -- },
      -- {
      --   "<s-tab>",
      --   function() require("luasnip").jump(-1) end,
      --   mode = { "i", "s" },
      -- },

      -- Expansion key
      -- This will expand the current item or jump to the next item within the snippet.
      {
        "<c-k>",
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then ls.expand_or_jump() end
        end,
        mode = { "i", "s" },
        silent = true,
      },

      -- Jump backwards key
      -- This always moves to the previous item within the snippet
      {
        "<c-j>",
        function()
          local ls = require("luasnip")
          if ls.jumpable(-1) then ls.jump(-1) end
        end,
        mode = { "i", "s" },
        silent = true,
      },

      -- Selecting within a list of options.
      -- This is useful for choice nodes
      {
        "<c-l>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then ls.change_choice(1) end
        end,
        mode = { "i", "s" },
        silent = true,
      },
    },
    config = function()
      local ls = require("luasnip")
      local types = require("luasnip.util.types")

      ls.config.set_config({
        -- This tells LuaSnip to remember to keep around the last snippet.
        -- You can jump back into it even if you move outside of the selection
        history = false,

        -- This one is cool cause if you have dynamic snippets, it updates as you type!
        updateevents = "TextChanged,TextChangedI",

        -- Autosnippets:
        enable_autosnippets = true,

        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { " « ", "NonTest" } },
            },
          },
        },
      })

      require("luasnip.loaders.from_vscode").lazy_load()
      for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/eden/mod/snips/ft/*.lua", true)) do
        loadfile(ft_path)()
      end

      -- https://sourcegraph.com/github.com/Cassin01/nvim-conf@48e0511d8899ca87145f7191c83f0e63252b488e/-/blob/after_opt/luasnip.lua
    end,
  },
}
