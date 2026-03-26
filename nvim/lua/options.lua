local vim = vim
local opt = vim.opt

opt.shell = '/usr/bin/env bash'
opt.number = true
opt.hidden = true
opt.signcolumn='number'
opt.cursorline = true
opt.modeline = false
opt.splitbelow = true
opt.splitright = true
opt.wildignorecase = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.foldmethod = 'indent'
opt.foldlevel = 99
opt.tags:append('.git/tags_file')
opt.undodir = vim.fn.getenv('HOME') .. '/.nvimtmp'
opt.directory = vim.fn.getenv('HOME') .. '/.nvimtmp'
opt.completeopt = 'menuone,noinsert,noselect'
opt.showbreak = '↪ '
opt.listchars  =  'tab:│ ,eol:↵,nbsp:␣,trail:⋅,extends:⟩,precedes:⟨,space:⋅'
opt.grepprg=[[rg --vimgrep --no-heading --smart-case --glob '!tags' --hidden --glob '!.git']]
opt.termguicolors = true
opt.inccommand = 'split'
opt.shortmess:remove('F')
opt.laststatus = 3
opt.updatetime = 1000
opt.wrap = false
opt.pumborder = 'single'
opt.winborder = 'rounded'

local restore_cursor_group = vim.api.nvim_create_augroup('zek_restore_cursor', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  group = restore_cursor_group,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= '' then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local row = mark[1]
    if row <= 1 or row > vim.api.nvim_buf_line_count(args.buf) then
      return
    end

    pcall(vim.api.nvim_win_set_cursor, 0, mark)
  end,
})
