-- TODO: Remove when https://github.com/neovim/neovim/pull/13479 lands
local opts_info = vim.api.nvim_get_all_options_info()
local opt =
  setmetatable(
  {},
  {
    __index = vim.o,
    __newindex = function(_, key, value)
      vim.o[key] = value
      local scope = opts_info[key].scope
      if scope == "win" then
        vim.wo[key] = value
      elseif scope == "buf" then
        vim.bo[key] = value
      end
    end
  }
)

local bind = function(tbl)
	for name, value in pairs(tbl) do
		vim.o[name] = value
	end
end

local options = {}

function options:init()
	bind(require('core.options.cached'))
	bind(require('core.options.edit'))
	bind(require('core.options.search'))
	bind(require('core.options.visual'))
end

return options
