local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  dependencies = {
    "romgrk/nvim-treesitter-context",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}

M.config = function()
  -- Setting clang as the compiler to use as pre this solution
  -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#troubleshooting
  -- NOTE: Had issues with clang and nix installed build-essentials and gcc and it works
  require("nvim-treesitter.install").compilers = { "gcc", "clang", "cl" }
  require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    playground = { enable = true },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
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
      config = {
        c = "// %s",
        lua = "-- %s",
        nix = "# %s",
      },
    },
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "c_sharp",
      "comment",
      "cpp",
      "go",
      "javascript",
      "json",
      "lua",
      "nix",
      "python",
      "regex",
      "rust",
      "toml",
      "typescript",
      "tsx",
    },
  })

  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

  if not edn.platform.is.win then
    require("treesitter-context").setup()
  end

  local parser = require("nvim-treesitter.parsers").get_parser_configs()
  parser.vhs = {
    install_info = {
      url = "https://github.com/charmbracelet/tree-sitter-vhs",
      files = { "src/parser.c" },
      branch = "main",
    },
    filetype = "vhs",
  }
end

return M
