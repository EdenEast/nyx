local nnoremap = vim.keymap.nnoremap
local xnoremap = vim.keymap.xnoremap
local onoremap = vim.keymap.xnoremap

local M = {}

local anoremap = function(opt)
  nnoremap(opt)
  xnoremap(opt)
  onoremap(opt)
end

local enable_qwerty = function()
  -- Movement keys
  anoremap { 'h', 'h' }
  anoremap { 'j', 'j' }
  anoremap { 'k', 'k' }
  anoremap { 'l', 'l' }

  anoremap { 'm', 'm' }
  anoremap { 'n', 'n' }
  anoremap { 'e', 'e' }
  anoremap { 'i', 'i' }
end

-- Note: This is for Colemak-DH mode
local enable_colemak = function()
  -- Movement keys
  anoremap { 'm', 'h' }
  anoremap { 'n', 'j' }
  anoremap { 'e', 'k' }
  anoremap { 'i', 'l' }

  -- Insert keys
  nnoremap { 'h', 'i' }

  -- Next search
  nnoremap { 'l', 'n' }

  -- End
  nnoremap { 'k', 'e' }

  -- Marks
  nnoremap { 'j', 'm' }
end

local setup = function()
  if vim.g.colemak_mode_initialized then
    return
  end

  if vim.g.colemak_mode == nil then
    vim.g.colemak_mode = false
  end

  if vim.g.colemak_mode then
    colemak_mode()
  end

  vim.cmd [[command! ColemakToggle lua require('plugin.colemak').toggle()]]
  vim.cmd [[command! ColemakEnable lua require('plugin.colemak').enable()]]
  vim.cmd [[command! ColemakDisable lua require('plugin.colemak').disable()]]

  nnoremap { '<leader>tc', ':ColemakToggle<cr>' }

  vim.g.colemak_mode_initialized = true
end

M.enable = function()
  if vim.g.colemak_mode then
    return
  end

  vim.g.colemak_mode = true
  enable_colemak()
end

M.disable = function()
  if not vim.g.colemak_mode then
    return
  end

  vim.g.colemak_mode = false
  enable_qwerty()
end

M.toggle = function()
  vim.g.colemak_mode = not vim.g.colemak_mode
  if vim.g.colemak_mode then
    enable_colemak()
  else
    enable_qwerty()
  end
end

setup()

return M
