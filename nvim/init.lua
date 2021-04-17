vim.o.shell = "/usr/bin/env bash"

require("plugins")

vim.cmd[[packadd cfilter]]

vim.o.mouse="a"
vim.wo.number = true
vim.o.hidden = true
vim.wo.signcolumn="number"
vim.wo.cursorline = true
vim.bo.modeline = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.wildignorecase = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.wo.foldmethod = "indent"
vim.wo.foldlevel = 99
vim.o.errorformat = vim.o.errorformat .. ",%f"
vim.o.tags = vim.o.tags .. ",.git/tags"
vim.o.undodir = vim.fn.getenv("HOME") .. "/.nvimtmp"
vim.o.directory = vim.fn.getenv("HOME") .. "/.nvimtmp"
vim.cmd[[set undofile]]
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.showbreak = "↪ "
vim.o.listchars  =  "tab:│ ,eol:↵,nbsp:␣,trail:⋅,extends:⟩,precedes:⟨,space:⋅"
vim.o.grepprg=[[rg --vimgrep --no-heading --smart-case --glob "!tags" --hidden --glob "!.git"]]
vim.o.statusline = [[%w%q 【 %f%M%R%H 】%=%{(&paste==0?'':'〖P〗')} 《 %Y 》〔%l ↕ %L ↕ %c〕 ┇ %%%p ┇ %{zek#listinfos()}]]
vim.o.termguicolors = true
vim.o.inccommand = "split"
vim.cmd[[colorscheme nord]]

vim.g.zek_has_replied = false
vim.api.nvim_exec([[
	augroup general_au
		autocmd!
		autocmd VimResized      *                     :wincmd =
		" autocmd ColorScheme     *                     call zek#post_colorscheme()
		autocmd CmdlineLeave    :                     call zek#autoreply()
		autocmd BufEnter        *                     lua require'completion'.on_attach()
		autocmd QuickFixCmdPost cgetexpr,cexpr        cwindow
		autocmd TermOpen * setlocal nonumber norelativenumber
	augroup END
]], false)

vim.g.netrw_liststyle = 3
vim.g.vitality_fix_focus = 0
vim.g.fzf_preview_window = ''

vim.g.completion_chain_complete_list = {
  default = {
    { complete_items = { 'lsp' } },
    { complete_items = { 'buffers' } },
    { complete_items = { 'tags' } },
    { mode = { '<c-p>' } },
    { mode = { '<c-n>' } }
  },
}
require('gitsigns').setup()

require("keybindings")
