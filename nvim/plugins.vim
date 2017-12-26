function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim/plugged')

" programming
Plug 'tpope/vim-fugitive'
Plug 'roxma/nvim-completion-manager'
Plug 'autozimu/LanguageClient-neovim', {'tag': 'binary-*-x86_64-apple-darwin' }

" editing
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'farmergreg/vim-lastplace'
Plug 'Shougo/junkfile.vim'

" navigating
Plug 'tpope/vim-vinegar'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-grepper'
Plug 'tpope/vim-unimpaired'
Plug 'christoomey/vim-tmux-navigator'
Plug 'szw/vim-smartclose'
Plug 'Shougo/denite.nvim', {'do': function('DoRemote')}

" vim interface
Plug 'morhetz/gruvbox'

" python
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}

" javascript / JSON
Plug 'tpope/vim-jdaddy', {'for': 'json'}
Plug 'neoclide/vim-jsx-improve', {'for': 'javascript'}

" haskell
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}


" rust-lang
Plug 'rust-lang/rust.vim', {'for': 'rust'}

" go lang
Plug 'fatih/vim-go', {'for': 'go'}

" misc
Plug 'diepm/vim-rest-console', {'for': 'rest'}
Plug 'Shougo/vimproc.vim', {'do': 'make'}

call plug#end()
