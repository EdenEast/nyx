return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<leader>fe",
        function() require("neo-tree.command").execute({ toggle = true, dir = require("eden.util").get_root() }) end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>fE",
        function() require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() }) end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    },
    deactivate = function() vim.cmd([[Neotree close]]) end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        ---@diagnostic disable-next-line: param-type-mismatch
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then require("neo-tree") end
      end
    end,
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
        config = function()
          require("window-picker").setup({
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              -- ignore file and buffer types
              bo = {
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                buftype = { "terminal", "quickfix" },
              },
            },
            other_win_hl_color = "#e35e4f",
          })
        end,
      },
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          hide_dotfiles = false,
          bind_to_cwd = false,
          follow_current_file = {
            enable = true,
          },
        },
        window = {
          mappings = {
            ["<space>"] = "none",
            ["<2-LeftMouse>"] = "open_with_window_picker",
            ["<cr>"] = "open_with_window_picker",
            ["w"] = "open_with_window_picker",
            ["S"] = "split_with_window_picker",
            ["s"] = "vsplit_with_window_picker",
            ["h"] = "close_node",
            ["l"] = "open",
            ["L"] = "focus_preview",
            ["<left>"] = "close_node",
            ["<right>"] = "open",
          },
        },
        default_component_configs = {
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
        },
      })
    end,
  },

  -- search/replace in multiple files
  {
    "windwp/nvim-spectre",
    cmd = { "Spectre" },
    keys = {
      {
        "<leader>sr",
        function() require("spectre").open() end,
        desc = "Replace in files (Spectre)",
      },
    },
  },

  -- references
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set(
          "n",
          key,
          function() require("illuminate")["goto_" .. dir .. "_reference"](false) end,
          { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer }
        )
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },

  -- toggle terminal
  {
    "akinsho/nvim-toggleterm.lua",
    cmd = { "ToggleTerm" },
    keys = {
      {
        "<c-space>",
        function() _G.eden_toggle_terminal("default") end,
        { desc = "Toggle term" },
      },
    },
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal

      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 20
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        direction = "horizontal",
        shade_terminals = vim.o.background == "dark",
        float_opts = {
          border = "double",
          highlights = {
            background = "DarkenedPanel",
            border = "DarkenedPanel",
          },
        },
      })

      local shell = require("eden.core.platform").is.win and "powershell -NoLogo" or vim.o.shell

      local terminals = {}

      terminals.default = Terminal:new({
        cmd = shell,
        direction = "horizontal",
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(
            term.bufnr,
            "t",
            "<c-space>",
            [[<C-\><C-n><cmd>lua eden_toggle_terminal('default')<cr>]],
            { noremap = true, silent = true }
          )
        end,
      })

      _G.eden_toggle_terminal = function(name) terminals[name]:toggle() end
    end,
  },

  -- view color codes
  {
    "NvChad/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    keys = {
      { "<leader>uC", "<cmd>ColorizerToggle<cr>", desc = "Colorizer" },
    },
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

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            vim.cmd.cprev()
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            vim.cmd.cnext()
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    keys = {
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },

  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    keys = { { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" } },
  },

  {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- qwerty
      { "<M-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
      { "<M-j>", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
      { "<M-k>", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
      { "<M-l>", function() require("harpoon"):list():select(4) end, desc = "Harpoon 3" },
      -- colemak
      { "<M-n>", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
      { "<M-e>", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
      { "<M-i>", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
      { "<M-o>", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },

      { "<M-a>", function() require("harpoon"):list():append() end, desc = "Harpoon add" },
      {
        "<leader>uh",
        function()
          local h = require("harpoon")
          h.ui:toggle_quick_menu(h:list())
        end,
        desc = "Harpoon",
      },
    },
    config = function()
      require("harpoon").setup({})
      -- require("harpoon").setup({
      --   menu = {
      --     width = function() return math.max(60, math.floor(vim.api.nvim_win_get_width(0) * 0.8)) end,
      --   },
      -- })
    end,
  },
}
