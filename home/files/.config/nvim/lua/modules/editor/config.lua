local config = {}

function config.nvim_autopairs()
  require('nvim-autopairs').setup()
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

function config.editorconfig()
  vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*', 'scp://.*' }
end

function config.doge()
  vim.g.doge_enable_mappings = 0
end

function config.firenvim()
  vim.o.laststatus = 0
  vim.bo.filetype = 'markdown'
end

function config.rooter()
  vim.g.rooter_patterns = { '.git', '.git/', '.root', '.root/' }
end

function config.spectre()
  vim.cmd('command! Spectre lua require("spectre").open()')

  require('spectre').setup()
end

return config
