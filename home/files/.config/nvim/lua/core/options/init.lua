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
