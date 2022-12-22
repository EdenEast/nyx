return {
  "mfussenegger/nvim-dap",
  config = function()
    require("eden.mod.dap.setup")
  end,
  event = "VeryLazy",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "jbyuki/one-small-step-for-vimkind",
  },
}
