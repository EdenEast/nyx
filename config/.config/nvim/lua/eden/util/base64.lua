-- https://devforum.roblox.com/t/base64-encoding-and-decoding-in-lua/1719860

local base64 = {}

local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

base64.enc = function(data)
  return (
    (data:gsub(".", function(x)
      local r, t = "", x:byte()
      for i = 8, 1, -1 do
        r = r .. (t % 2 ^ i - t % 2 ^ (i - 1) > 0 and "1" or "0")
      end
      return r
    end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
      if #x < 6 then return "" end
      local c = 0
      for i = 1, 6 do
        c = c + (x:sub(i, i) == "1" and 2 ^ (6 - i) or 0)
      end
      return chars:sub(c + 1, c + 1)
    end) .. ({ "", "==", "=" })[#data % 3 + 1]
  )
end

base64.dec = function(data)
  data = string.gsub(data, "[^" .. chars .. "=]", "")
  return (
    data
      :gsub(".", function(x)
        if x == "=" then return "" end
        local r, f = "", (chars:find(x) - 1)
        for i = 6, 1, -1 do
          r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
        end
        return r
      end)
      :gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if #x ~= 8 then return "" end
        local c = 0
        for i = 1, 8 do
          c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
      end)
  )
end

return base64
