return {
  "folke/which-key.nvim",
  config = function()
    local wk = require("which-key")

    vim.opt.timeoutlen = 300

    wk.setup({
      plugins = {
        spelling = {
          enabled = true,
        },
      },
    })

    wk.register({
      b = { name = "+buffer" },
      c = { name = "+code" },
      d = { name = "+debug" },
      f = { name = "+find", g = { name = "+git" } },
      g = { name = "+git" },
      t = { name = "+toggle" },
      ["1"] = "which_key_ignore",
      ["2"] = "which_key_ignore",
      ["3"] = "which_key_ignore",
      ["4"] = "which_key_ignore",
      ["5"] = "which_key_ignore",
      ["6"] = "which_key_ignore",
      ["7"] = "which_key_ignore",
      ["8"] = "which_key_ignore",
      ["9"] = "which_key_ignore",
    }, { prefix = "<leader>" })
  end,
}
