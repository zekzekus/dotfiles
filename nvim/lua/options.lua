local opt = vim.opt

opt.shell = "/usr/bin/env bash"
opt.mouse="a"
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
opt.tags:append(".git/tags")
opt.undodir = vim.fn.getenv("HOME") .. "/.nvimtmp"
opt.directory = vim.fn.getenv("HOME") .. "/.nvimtmp"
opt.completeopt = "menuone,noinsert,noselect"
opt.showbreak = "↪ "
opt.listchars  =  "tab:│ ,eol:↵,nbsp:␣,trail:⋅,extends:⟩,precedes:⟨,space:⋅"
opt.grepprg=[[rg --vimgrep --no-heading --smart-case --glob "!tags" --hidden --glob "!.git"]]
opt.statusline = [[%w%q 【 %f%M%R%H 】%=%{(&paste==0?'':'〖P〗')} 《 %Y 》〔%l ↕ %L ↕ %c〕 ┇ %%%p ┇ %{zek#listinfos()}]]
opt.termguicolors = true
opt.inccommand = "split"
opt.shortmess:remove("F")
