local curwin = vim.api.nvim_get_current_win

local map = {
  left = {
    key = "h",
    split = "v",
  },
  down = {
    key = "j",
    split = "s",
  },
  up = {
    key = "k",
    split = "s",
  },
  right = {
    key = "l",
    split = "v",
  },
}

local function wincmd(key)
  vim.cmd("wincmd " .. key)
end

-- Window movement and management
-- Move to the window in the direction or create a new split
local function winmove(direction)
  local d = map[direction]
  if not d then
    error("Unknown direction: " .. direction)
  end

  local start = curwin()
  wincmd(d.key)
  if start == curwin() then
    wincmd(d.split)
    wincmd(d.key)
  end
end

return setmetatable({}, {
  __call = function(_, direction)
    winmove(direction)
  end,
})
