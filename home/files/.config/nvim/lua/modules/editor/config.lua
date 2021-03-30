local config = {}

function config.peartree()
  -- I get disorented when the closing brace does not get inserted
  vim.g.pear_tree_repeatable_expand = false
  vim.g.pear_tree_smart_openers = true
  vim.g.pear_tree_smart_closers = true
  vim.g.pear_tree_smart_backspace = true
end

function config.nvim_colorizer()
  require 'colorizer'.setup {
    css = { rgb_fn = true; };
    lua = { names = false; };
    sass = { rgb_fn = true; };
    scss = { rgb_fn = true; };
    stylus = { rgb_fn = true; };
    tmux = { names = false; };
    vim = { names = true; };
    'javascript';
    'javascriptreact';
    'typescript';
    'typescriptreact';
    html = {
      mode = 'foreground';
    }
  }
end

function config.lessspace()
  vim.g.lessspace_normal = false
end

function config.editorconfig()
  vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*', 'scp://.*' }
end

function config.firenvim()
  vim.o.laststatus = 0
  vim.bo.filetype = 'markdown'
end

function config.rooter()
  vim.g.rooter_patterns = { '.git', '.git/', '.root', '.root/' }
end

function config.telescope()
  require('modules.editor.telescope')
end


return config
