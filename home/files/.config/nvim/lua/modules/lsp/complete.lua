local inoremap = vim.keymap.inoremap
local npairs = require('nvim-autopairs')

vim.opt.completeopt = "menuone,noselect"

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.complete_tab = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.complete_s_tab = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end
_G.complete_confirm = function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      vim.fn["compe#confirm"]()
      return npairs.esc("<c-y>")
    else
      vim.defer_fn(function()
        vim.fn["compe#confirm"]("<cr>")
      end, 20)
      return npairs.esc("<c-n>")
    end
  else
    return npairs.check_break_line_char()
  end
end

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'always';
  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = false;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
  };
}

inoremap { "<Tab>",   "v:lua.complete_tab()",   expr=true }
inoremap { "<Tab>",   "v:lua.complete_tab()",   expr=true }
inoremap { "<S-Tab>", "v:lua.complete_s_tab()", expr=true }
inoremap { "<S-Tab>", "v:lua.complete_s_tab()", expr=true }

inoremap { '<C-Space>', [[compe#complete()]],         expr=true }
inoremap { '<cr>',      [[v:lua.complete_confirm()]], expr=true }

