vim.cmd([[
  packadd vim-vsnip
  packadd vim-vsnip-integ
  packadd friendly-snippets
]])

vim.opt.completeopt = { "menuone", "noselect" }

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholdersr
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t("<C-n>")
  elseif vim.fn["vsnip#available"](1) == 1 then
    return t("<Plug>(vsnip-expand-or-jump)")
  elseif check_back_space() then
    return t("<Tab>")
  else
    return vim.fn["compe#complete"]()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t("<C-p>")
  elseif vim.fn["vsnip#jumpable"](-1) == 1 then
    return t("<Plug>(vsnip-jump-prev)")
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t("<S-Tab>")
  end
end

require("nvim-autopairs.completion.compe").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
})

require("compe").setup({
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "always",
  source = {
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    orgmode = true,
    path = true,
    spell = true,
    treesitter = true,
    vsnip = true,
    emoji = {
      filetypes = { "markdown", "text" },
      priority = 0,
    },
  },
})

edn.keymap({
  mode = "i",
  expr = true,
  {
    { "<Tab>", "v:lua.tab_complete()", expr = true },
    { "<Tab>", "v:lua.tab_complete()", expr = true },
    { "<S-Tab>", "v:lua.s_tab_complete()", expr = true },
    { "<S-Tab>", "v:lua.s_tab_complete()", expr = true },
    { "<C-Space>", [[compe#complete()]], expr = true },
  },
})
