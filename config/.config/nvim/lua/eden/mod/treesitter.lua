return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      -- Setting clang as the compiler to use as pre this solution
      -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#troubleshooting
      -- NOTE: Had issues with clang and nix installed build-essentials and gcc and it works
      -- require("nvim-treesitter.install").compilers = { "gcc", "clang", "cl" }
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "rust", "vim", "vimdoc", "query" },

        sync_install = false,
        auto_install = true,

        highlight = { enable = true },
        indent = { enable = true },
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
}
