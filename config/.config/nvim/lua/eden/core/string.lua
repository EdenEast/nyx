--- These are some functions that the default lua string object should have just had

---Check if a string starts with a sub string
---
---# Example
---   local value = "Hello, World!"
---   string.starts_with(value, "Hello") -- true
---@param str string
---@param starts string
---@return boolean
function string.starts_with(str, starts) return str:sub(1, #starts) == starts end

---Check if a string end with a sub string
---
---# Example
---   local value = "Hello, World!"
---   string.ends_with(value, "World!") -- true
---@param str string
---@param ends string
---@return boolean
function string.ends_with(str, ends) return ends == "" or str:sub(-#ends) == ends end

---Strip quotes from string
---
---# Example
---   assert([[https://github.com]], strip_quotes([['https://github.com']]))
---@param str string
---@return string
function string.strip_quotes(str)
  if string.sub(str, 1, 1) == '"' or string.sub(str, 1, 1) == "'" then
    local quoteType = string.sub(str, 1, 1)
    if string.sub(str, -1) == quoteType then return string.sub(str, 2, -2) end
  end
  return str
end
