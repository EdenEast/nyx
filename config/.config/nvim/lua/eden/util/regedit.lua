local M = {}

-- https://github.com/kylechui/nvim-surround/blob/ec2dc7671067e0086cdf29c2f5df2dd909d5f71f/lua/nvim-surround/init.lua#L52
function M.execute_edit_register(char)
  if not char then
    print("no char passed")
    return
  end

  local register_content = vim.fn.getreg(char)

  local bufn = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufn, 0, -1, true, { register_content })
  vim.api.nvim_set_option_value("filetype", "regedit", {
    buf = bufn,
  })

  local delete_buf = function() vim.api.nvim_buf_delete(bufn, { unload = true }) end
  vim.keymap.set("n", "<escape>", delete_buf, { buffer = bufn })
  vim.keymap.set("n", "<c-c>", delete_buf, { buffer = bufn })

  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)
  local width = math.floor(win_width * 0.8)
  local col = math.floor((win_width * 0.2) / 2)
  local opts = {
    relative = "win",
    width = width,
    height = 1,
    col = col,
    row = math.floor(win_height / 2),
    anchor = "NW",
    border = "rounded",
    style = "minimal",
  }

  vim.api.nvim_open_win(bufn, true, opts)

  vim.api.nvim_create_augroup("eden_register_edit", { clear = true })
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = bufn,
    callback = function()
      local content = vim.api.nvim_buf_get_text(bufn, 0, 0, -1, -1, {})
      vim.fn.setreg(char, table.concat(content))

      -- cleanup autocmds
      local autocmds = vim.api.nvim_get_autocmds({ group = "eden_register_edit" })
      for _, cmd in ipairs(autocmds) do
        vim.api.nvim_del_autocmd(cmd.id)
      end
      vim.api.nvim_del_augroup_by_name("eden_register_edit")
    end,
  })
end

function M.apply_config()
  local expr_map = function() M.map()
end

-- Add delimiters around a motion.
---@param args { selection: selection, delimiters: delimiter_pair, line_mode: boolean }
---@return "g@"|nil
function M.edit_register(args)
  if not args.selection then
    vim.go.operatorfunc = "v:lua.require'eden.util.regedit'.edit_register_callback"
    return "g@"
  end
end

function M.edit_register_callback() end

return M
