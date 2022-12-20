local M = {
  "mfussenegger/nvim-dap",
  config = function()
    require("eden.modules.protocol.dap")
  end,
  event = "VeryLazy",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "jbyuki/one-small-step-for-vimkind",
  },
}

return M
