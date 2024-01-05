return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "jbyuki/one-small-step-for-vimkind",
    },
    config = function()
      local dap = require("dap")
      dap.set_log_level("TRACE")

      local modules = vim.api.nvim_get_runtime_file("lua/eden/mod/dap/adaptors/*.lua", true)
      for _, mod in ipairs(modules) do
        loadfile(mod)()
      end

      -- ui
      local dapui = require("dapui")
      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- breakpoint style
      vim.fn.sign_define("DapBreakpointRejected", { text = "ﰸ", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpoint", { text = "⬤", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "➔", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    end,
    keys = {
      -- vs/vscode style function mappings
      { "<F5>", function() require("dap").continue() end, desc = "Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Step into" },

      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dl", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dj", function() require("dap").step_into() end, desc = "Step info" },
      { "<leader>dk", function() require("dap").step_out() end, desc = "Step out" },

      { "<leader>dK", function() require("dap").up() end, desc = "Move up" },
      { "<leader>dJ", function() require("dap").down() end, desc = "Move down" },

      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        desc = "Conditional breakpoint",
      },
      {
        "<leader>dm",
        function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
        desc = "Log breakpoint",
      },

      { "<leader>dd", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>dq", function() require("dap").disconnect() end, desc = "Disconnect" },
      { "<leader>dr", function() require("dap").disconnect({ restart = true }) end, desc = "Restart" },

      { "<leader>dh", function() require("dap.ui.widget").hover() end, desc = "Hover" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle ui" },
    },
  },
}
