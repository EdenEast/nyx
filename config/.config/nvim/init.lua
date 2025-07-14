if vim.env.NVIM_PROFILE then
  local pack = vim.fn.stdpath("cache") .. "/lazy/pack/profile.nvim"
  vim.opt.rtp:prepend(pack)
  vim.api.nvim_create_autocmd("UiEnter", {
    group = vim.api.nvim_create_augroup("startup_profiler_trace", { clear = true }),
    callback = function()
      local profile = require("profile")
      profile.stop()
      vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
        if filename then
          profile.export(filename)
          vim.notify(string.format("Wrote %s", filename))
        end
      end)
    end,
  })
  local profile = require("profile")
  profile.instrument_autocmds()
  profile.start("*")
end

require("eden.core")
