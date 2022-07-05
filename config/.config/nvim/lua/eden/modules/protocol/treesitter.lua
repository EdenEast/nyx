vim.api.nvim_command("set foldmethod=expr")
vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")

local deps = {
  "nvim-ts-context-commentstring",
  "nvim-treesitter-textobjects",
  "nvim-ts-autotag",
}

if not edn.platform.is_windows then
  table.insert(deps, "nvim-treesitter-context")
end
require("eden.lib.defer").immediate_load(deps)

vim.cmd([[packadd nvim-ts-context-commentstring]])
vim.cmd([[packadd nvim-treesitter-textobjects]])
vim.cmd([[packadd nvim-ts-autotag]])

-- Setting clang as the compiler to use as pre this solution
-- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#troubleshooting
-- NOTE: Had issues with clang and nix installed build-essentials and gcc and it works
require("nvim-treesitter.install").compilers = { "gcc", "clang", "cl" }
require("nvim-treesitter.configs").setup({
  autotag = { enable = true },
  highlight = { enable = true, disable = { "yaml" } },
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
    -- "haskell",
    "javascript",
    "json",
    "lua",
    "nix",
    "python",
    "query",
    "regex",
    "rust",
    "toml",
    "typescript",
    "tsx",
    "yaml",
  },
})

if not edn.platform.is_windows then
  vim.cmd([[packadd nvim-treesitter-context]])
  require("treesitter-context").setup()
end
