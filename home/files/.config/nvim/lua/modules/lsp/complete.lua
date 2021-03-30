local inoremap = vim.keymap.inoremap
local snoremap = vim.keymap.snoremap

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
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
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

inoremap { '<C-Space>', [[compe#complete()]], expr = true }
inoremap { '<CR>',      [[compe#confirm('<CR>')]], expr = true }
inoremap { '<C-Space>', [[compe#complete()]], expr = true, buffer = true }
inoremap { '<CR>',      [[compe#confirm('<CR>')]], expr = true, buffer = true }

inoremap { '<Tab>', [[vim:lua.tab_complete()]], expr = true }
snoremap { '<Tab>', [[vim:lua.tab_complete()]], expr = true }
inoremap { '<S-Tab>', [[vim:lua.s_tab_complete()]], expr = true }
snoremap { '<S-Tab>', [[vim:lua.s_tab_complete()]], expr = true }

-- vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", {expr = true})
-- vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<cr>')", {expr = true})
-- vim.api.nvim_buf_set_keymap(0, "i", "<C-Space>", "compe#complete()", {expr = true})
-- vim.api.nvim_buf_set_keymap(0, "i", "<CR>", "compe#confirm('<cr>')", {expr = true})

-- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})


