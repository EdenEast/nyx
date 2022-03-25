local M = {}

function M.map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.nmap(lhs, rhs, opts)
  vim.keymap.set("n", lhs, rhs, opts)
end

function M.imap(lhs, rhs, opts)
  vim.keymap.set("i", lhs, rhs, opts)
end

function M.vmap(lhs, rhs, opts)
  vim.keymap.set("v", lhs, rhs, opts)
end

function M.xmap(lhs, rhs, opts)
  vim.keymap.set("x", lhs, rhs, opts)
end

function M.cmap(lhs, rhs, opts)
  vim.keymap.set("c", lhs, rhs, opts)
end

function M.tmap(lhs, rhs, opts)
  vim.keymap.set("t", lhs, rhs, opts)
end

return M
