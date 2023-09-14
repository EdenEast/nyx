return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- Setting clang as the compiler to use as pre this solution
      -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#troubleshooting
      -- NOTE: Had issues with clang and nix installed build-essentials and gcc and it works
      require("nvim-treesitter.install").compilers = { "gcc", "clang", "cl" }
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
        playground = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["ia"] = "@parameter.inner",
              ["aa"] = "@parameter.outer",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
            },
          },
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
          config = {
            c = "// %s",
            lua = "-- %s",
            nix = "# %s",
          },
        },
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "c_sharp",
          "comment",
          "dhall",
          "html",
          "javascript",
          "json",
          "lua",
          "luadoc",
          "luap",
          "markdown",
          "markdown_inline",
          "nix",
          "python",
          "query",
          "regex",
          "rust",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
      })

      local parser = require("nvim-treesitter.parsers").get_parser_configs()
      parser.vhs = {
        install_info = {
          url = "https://github.com/charmbracelet/tree-sitter-vhs",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "vhs",
      }

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },

  {
    "nvim-treesitter/playground",
    keys = {
      {
        "<leader>uH",
        function() require("nvim-treesitter-playground.hl-info").show_hl_captures() end,
        desc = "Highlight groups",
      },
    },
  },
}
