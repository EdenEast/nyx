-- This file is used to override any builtin telescope functions and extend my own

local themes = require("telescope.themes")
local builtin = require("telescope.builtin")
local path = require("eden.core.path")

local M = {}

local function find_with_cwd(cwd, prompt)
  local opts = {
    prompt_title = prompt,
    shorten_path = false,
    hidden = true,
    cwd = cwd,

    layout_strategy = "flex",
    layout_config = {
      width = 0.9,
      height = 0.8,

      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },
  }

  builtin.find_files(opts)
end

-- Open telescope with nyx directory.
function M.edit_dotfiles()
  local cwd = path.join(path.home, ".local", "nyx")
  local prompt = "~ nyx ~"
  find_with_cwd(cwd, prompt)
end

-- Open telescope with neovim's directory.
function M.edit_neovim()
  local cwd = path.confighome
  local prompt = "~ neovim ~"
  find_with_cwd(cwd, prompt)
end

function M.fd()
  local opts = themes.get_ivy({ hidden = false })
  builtin.fd(opts)
end

function M.projects()
  return require("telescope").extensions.projects.projects()
end

function M.live_grep()
  require("telescope.builtin").live_grep({
    previewer = false,
    fzf_separator = "|>",
  })
end

function M.oldfiles()
  if vim.g.sqlite_found then
    require("telescope").extensions.frecency.frecency()
  else
    builtin.oldfiles()
  end
end

function M.diagnostics()
  builtin.diagnostics({
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      width = 0.85,
      vertical = {
        prompt_position = "top",
      },
    },
  })
end

function M.lsp_definitions()
  builtin.lsp_definitions({
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      width = 0.85,
      vertical = {
        prompt_position = "top",
      },
    },
  })
end

function M.lsp_references()
  builtin.lsp_references({
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      width = 0.85,
      vertical = {
        prompt_position = "top",
      },
    },
  })
end

return setmetatable({}, {
  __index = function(_, key)
    if M[key] then
      return M[key]
    end

    local has_extra, extra = pcall(require, "eden.modules.nav.telescope.extras." .. key)
    if has_extra then
      return extra
    end

    if builtin[key] then
      return builtin[key]
    end

    -- Not sure what the mapping wanted so error
    return nil
  end,
})
