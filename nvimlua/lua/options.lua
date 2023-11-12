local vim = vim
local opt = vim.opt

-- opt.shell = "/usr/bin/env bash"
vim.g.python3_host_prog = '$HOME/.virtualenvs/neovim3/bin/python'

-- opt.mouse = "a"
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
opt.clipboard = "unnamedplus"

vim.g.smartclose_set_default_mapping = 0
vim.g.UltiSnipsExpandTrigger='<C-j>'
vim.g.UltiSnipsJumpForwardTrigger="<C-j>"
vim.g.UltiSnipsJumpBackwardTrigger="<C-k>"

-- vim.cmd([[ ]])
