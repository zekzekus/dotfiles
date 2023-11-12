local vim = vim
local opt = vim.opt

vim.g.mapleader = ' '
vim.gmaplocalleader = ' '

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- use spaces for tabs and whatnot
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

-- vim.keymap.set('n', '<BS>', ':nohlsearch<CR>')

vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = false})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- opt.shell = "/usr/bin/env bash"
opt.number = true
opt.hidden = true
opt.signcolumn="number"
opt.cursorline = true
opt.modeline = false
opt.splitbelow = true
opt.splitright = true
opt.wildignorecase = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.tags:append(".git/tags_file")
opt.undodir = vim.fn.getenv("HOME") .. "/.nvimtmp"
opt.directory = vim.fn.getenv("HOME") .. "/.nvimtmp"
opt.completeopt = "menuone,noinsert,noselect"
opt.showbreak = "↪ "
opt.listchars  =  "tab:│ ,eol:↵,nbsp:␣,trail:⋅,extends:⟩,precedes:⟨,space:⋅"
opt.grepprg=[[rg --vimgrep --no-heading --smart-case --glob "!tags" --hidden --glob "!.git"]]
opt.termguicolors = true
opt.inccommand = "split"
opt.shortmess:remove("F")
opt.laststatus = 3
opt.updatetime = 1000
opt.wrap = false
