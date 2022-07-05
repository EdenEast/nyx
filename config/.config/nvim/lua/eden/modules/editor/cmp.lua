local cmp = require("cmp")
local types = require("cmp.types")
local pairs = require("nvim-autopairs.completion.cmp")

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local config = {
  completion = {
    completeopt = "menu,menuone,noinsert",
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
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-o>"] = cmp.mapping.complete(),
    ["<cr>"] = cmp.mapping(
      cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      { "i", "c" }
    ),
    -- ["<tab>"] = cmp.config.disable,

    -- Testing
    ["<c-q>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "luasnip" },
    { name = "treesitter" },
    {
      name = "buffer",
      keyword_length = 5,
      option = {
        get_bufnr = function() -- all buffers
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    { name = "crates" }, -- crates does check if file is a `Cargo.toml` file
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,

      -- copied from cmp-under, but I don't think I need the plugin for this.
      -- I might add some more of my own.
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find("^_+")
        local _, entry2_under = entry2.completion_item.label:find("^_+")
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,

      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  view = {
    entries = { name = "custom", selection_order = "top_down" },
  },
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
}

-- For filetype specific overrides see ftplugin folder

cmp.setup(config)
cmp.event:on("confirm_done", pairs.on_confirm_done())

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline({
    ["<Up>"] = {
      c = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
    },
    ["<Down>"] = {
      c = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
    },
  }),
  sources = cmp.config.sources({
    { name = "cmdline" },
  }, {
    { name = "path" },
  }),
})
