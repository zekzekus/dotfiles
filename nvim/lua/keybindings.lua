vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = false})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd[[command! -nargs=1 -complete=command -bar -range Zredir call zek#redir(<q-args>, <range>, <line1>, <line2>)]]
vim.cmd[[command! -nargs=+ -complete=file_in_path -bar Zgrep  cgetexpr zek#grep(<f-args>)]]

local kmap = vim.api.nvim_set_keymap
kmap('n', '<leader><space>', [[<cmd>Telescope<cr>]],                { noremap = true, silent = false })
kmap('n', '<leader>ff',      [[<cmd>Telescope find_files<cr>]],     { noremap = true, silent = false })
kmap('n', '<leader>fj',      [[<cmd>Files ~/.cache/junkfile<cr>]],  { noremap = true, silent = false })
kmap('n', '<leader>fs',      [[<cmd>w<cr>]],                        { noremap = true, silent = false })
kmap('n', '<leader>fW',      [[<cmd>%s/\s\+$//<cr>:let @/=''<cr>]], { noremap = true, silent = false })
kmap('n', '<leader>ft',      [[<cmd>NvimTreeToggle<cr>]],           { noremap = true, silent = false })
kmap('n', '<leader>bb',      [[<cmd>Telescope buffers<cr>]],        { noremap = true, silent = false })
kmap('n', '<leader>bd',      [[<cmd>bdelete<cr>]],                  { noremap = true, silent = false })
kmap('n', '<leader><tab>',   [[<cmd>b#<cr>]],                       { noremap = true, silent = false })
kmap('n', '<leader>`',       [[<cmd>b#<cr>]],                       { noremap = true, silent = false })
kmap('n', 'n',               [[nzzzv]],                             { noremap = true, silent = false })
kmap('n', 'N',               [[Nzzzv]],                             { noremap = true, silent = false })
kmap('n', '<bs>',            [[<cmd>nohlsearch<cr>]],               { noremap = true, silent = false })
kmap('n', '<leader>/',       [[:Zgrep<space>]],                     { noremap = true, silent = false })
kmap('n', '<leader>*',       [[:Zgrep<space><c-r><c-w><cr>]],       { noremap = true, silent = false })
kmap('n', '<leader>ss',      [[<cmd>Telescope current_buffer_tags<cr>]],       { noremap = true, silent = false })
kmap('n', '<leader>sl',      [[<cmd>Telescope current_buffer_fuzzy_find<cr>]], { noremap = true, silent = false })
kmap('c', '<c-n>',           [[<down>]],                            { noremap = true, silent = false })
kmap('c', '<c-p>',           [[<up>]],                              { noremap = true, silent = false })
kmap('n', '<leader>qq',      [[<cmd>SmartClose<cr>]],               { noremap = true, silent = true })
kmap('n', '<leader>V',       'V`]',                                 { noremap = true, silent = false })
kmap('i', '<tab>',           [[<Plug>(completion_next_source)]],    { noremap = false, silent = false })
kmap('n', 'cn',              [[*``cgn]],                            { noremap = true, silent = false })
kmap('n', 'cN',              [[*``cgN]],                            { noremap = true, silent = false })
kmap('v', 'cn',              [[g:mc . "``cgn"]],                    { noremap = true, expr = true, silent = false })
kmap('v', 'cN',              [[g:mc . "``cgN"]],                    { noremap = true, expr = true, silent = false })
kmap('n', 'cq',              [[:call zek#setup_cr()<CR>*``qz]],     { noremap = true, silent = false })
kmap('n', 'cQ',              [[:call zek#setup_cr()<CR>#``qz]],     { noremap = true, silent = false })
kmap('v', 'cq',              [[:\<C-u>call zek#setup_cr()\<CR>" . "gv" . g:mc . "``qz]],                            { noremap = true, expr = true, silent = false })
kmap('v', 'cQ',              [[:\<C-u>call zek#setup_cr()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz]], { noremap = true, expr = true, silent = false })

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent = false }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  -- if client.resolved_capabilities.document_highlight then
  --   vim.api.nvim_exec([[
  --     hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
  --     hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
  --     hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
  --     augroup lsp_document_highlight
  --       autocmd! * <buffer>
  --       autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --       autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --     augroup END
  --   ]], false)
  -- end
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "vimls", "vimls", "tsserver", "rust_analyzer" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
local sumneko_root_path = vim.fn.getenv("HOME").."/.local/bin/lua-language-server"
nvim_lsp.sumneko_lua.setup {
  cmd = {sumneko_root_path.."/bin/macOS/lua-language-server", "-E", sumneko_root_path.."/main.lua" };
  on_attach = on_attach,
  settings = {
      Lua = {
          runtime = {
              version = 'LuaJIT',
              path = vim.split(package.path, ';'),
          },
          diagnostics = {
              globals = {'vim'},
          },
          workspace = {
              library = {
                  [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                  [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
              },
          },
      },
  },
}
