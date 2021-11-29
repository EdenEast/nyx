local cmp = require("cmp")
local luasnip = require("luasnip")
local pairs = require("nvim-autopairs.completion.cmp")

vim.opt.completeopt = "menuone,noselect"

local config = {
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  documentation = {
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
  formatting = {
    format = function(entry, vim_item)
      -- load lspkind icons
      vim_item.kind = string.format(
        "%s %s",
        require("eden.modules.protocol.lsp.kind").icons[vim_item.kind],
        vim_item.kind
      )

      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        buffer = "[BUF]",
      })[entry.source.name]

      return vim_item
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-o>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "treesitter" },
    { name = "luasnip" },
    { name = "path" },
    {
      name = "buffer",
      keyword_length = 5,
      option = {
        get_bufnr = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    { name = "crates" }, -- crates does check if file is a `Cargo.toml` file
  },
}

-- For filetype specific overrides see ftplugin folder

cmp.setup(config)
cmp.event:on("confirm_done", pairs.on_confirm_done())
