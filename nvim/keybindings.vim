nnoremap <space> <nop>
let g:mapleader      = "\<space>"
let g:maplocalleader = '\'

nnoremap <leader><space>  <cmd>Telescope<cr>

" commands
command! -nargs=1 -complete=command      -bar -range Zredir call     zek#redir(<q-args>, <range>, <line1>, <line2>)
command! -nargs=+ -complete=file_in_path -bar        Zgrep  cgetexpr zek#grep(<f-args>)
command! -nargs=+                        -bar        Zfiles cgetexpr system('ff ' . shellescape(<q-args>) . ' .')
command! -nargs=?                        -bar        Zjunk  cgetexpr system('ff ' . shellescape(<q-args>) . ' ~/.cache/junkfile')

" files
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fj :Files ~/.cache/junkfile<cr>
nnoremap <leader>fs :w<cr>
nnoremap <leader>fW :%s/\s\+$//<cr>:let @/=''<CR>
nnoremap <leader>ft <cmd>NvimTreeToggle<cr>

" buffers
nnoremap <leader>bb    <cmd>Telescope buffers<cr>
nnoremap <leader>bd    :bdelete<cr>
nnoremap <leader><tab> :b#<CR>
nnoremap <leader>`     :b#<CR>

" search
nnoremap n          nzzzv
nnoremap N          Nzzzv
nnoremap <BS>       :nohlsearch<cr>
nnoremap <leader>/  :Zgrep<space>
nnoremap <leader>*  :Zgrep<space><c-r><c-w><cr>
nnoremap <leader>ss <cmd>Telescope current_buffer_tags<cr>
nnoremap <leader>sl <cmd>Telescope current_buffer_fuzzy_find<cr>

cnoremap <c-n> <down>
cnoremap <c-p> <up>
nmap <leader>K <Plug>DashSearch

nnoremap <silent><leader>qq :SmartClose<cr>

" Select just pasted text.
nnoremap <leader>V V`]

imap <Tab> <Plug>(completion_next_source)

let g:mc = 'y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>'
nnoremap cn     *``cgn
nnoremap cN     *``cgN
vnoremap <expr> cn g:mc . "``cgn"
vnoremap <expr> cN g:mc . "``cgN"

nnoremap cq       :call zek#setup_cr()<CR>*``qz
nnoremap cQ       :call zek#setup_cr()<CR>#``qz
vnoremap <expr>cq ":\<C-u>call zek#setup_cr()\<CR>" . "gv" . g:mc . "``qz"
vnoremap <expr>cQ ":\<C-u>call zek#setup_cr()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"

lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }
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
EOF
