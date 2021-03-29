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

return util
