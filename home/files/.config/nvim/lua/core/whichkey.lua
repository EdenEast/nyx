local has_wk, wk = pcall(require, 'which-key')

local register = function(_, keys, value)
  if has_wk then wk.register({[keys] = value}) end
end

return setmetatable({}, {__call = register})
