require("eden.lib.defer").immediate_load({
  "nvim-ts-context-commentstring",
  "nvim-treesitter-textobjects",
})

-- Setting clang as the compiler to use as pre this solution
-- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#troubleshooting
-- NOTE: Had issues with clang and nix installed build-essentials and gcc and it works
require("nvim-treesitter.install").compilers = { "gcc", "clang", "cl" }
require("nvim-treesitter.configs").setup({
  parser_install_dir = require("eden.core.path").cachehome,
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

-- vim.api.nvim_command("set foldmethod=expr")
-- vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")

if not edn.platform.is_windows then
  require("eden.lib.defer").immediate_load({ "nvim-treesitter-context" })
  require("treesitter-context").setup()
end
