local util = {}

util.join = function(tbl, delm)
  local result = tbl[1]
  for i, v in pairs(tbl) do
    if not (i == 1) then
      result = result .. delm .. v
    end
  end

  return result
end

util.map = function(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then options = tim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Window maps
util.wmap = function(mode, lhs, rhs, opts)
  return map(mode, lhs, '<cmd>wincmd '..rhs..'<CR>', opts)
end

util.nmap = function(lhs, rhs, opts)
  return map('n', lhs, rhs, opts)
end

util.imap = function(lhs, rhs, opts)
  return map('i', lhs, rhs, opts)
end

util.xmap = function(lhs, rhs, opts)
  return map('x', lhs, rhs, opts)
end

util.tmap = function(lhs, rhs, opts)
  return map('t', lhs, rhs, opts)
end

util.cmap = function(lhs, rhs)
  -- { silent } need to be false to work
  return map('c', lhs, rhs, { silent = false })
end

return util
