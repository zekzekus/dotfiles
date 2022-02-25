local metals = prequire("metals")

if not metals then
  return
end

local function buf_set_keymap(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opts = { noremap = true, silent = true }

buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
buf_set_keymap('n', 'K', '<cmd>Lspsaga hover_doc<cr>', opts)
buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
buf_set_keymap('n', '<C-s>', '<cmd>Lspsaga signature_help<cr>', opts)
buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
buf_set_keymap('n', '<space>rn', '<cmd>Lspsaga rename<cr>', opts)
buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
buf_set_keymap('n', '<space>e', '<cmd>Lspsaga show_line_diagnostics<cr>', opts)
buf_set_keymap('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<cr>', opts)
buf_set_keymap('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<cr>', opts)
buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)
