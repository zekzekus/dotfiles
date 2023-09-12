# My Personal Configuration Files

## NEOVIM

* Fully (almost) configured with lua
* I always use latest HEAD build of Neovim
* Package manager: [lazy.nvim](https://github.com/folke/lazy.nvim)
* Main static language support comes from builtin treesitter (WARNING: tries to build [ALL parsers](https://github.com/zekzekus/dotfiles/blob/master/nvim/lua/config/treesitter.lua#L8)!)
* Dynamic language support comes from builtin LSP client
* [Mason](https://github.com/williamboman/mason.nvim) to install language servers (any language server installed with mason will be initialized when needed)
* [Keybindings](https://github.com/zekzekus/dotfiles/blob/master/nvim/lua/keybindings.lua)
* Additional keybindings when a LSP client attached: [https://github.com/zekzekus/dotfiles/blob/master/nvim/lua/config/lsp-zero.lua](here)
* [Plugins](https://github.com/zekzekus/dotfiles/blob/master/nvim/lua/plugins.lua)

## VIM

* Much simpler compared to my Neovim configuration
* I always use latest HEAD build of Neovim
* Package manager: [vim.plug](https://github.com/junegunn/vim-plug)
* Static language support comes from [polyglot](https://github.com/sheerun/vim-polyglot)

### Installation (might be outdated or missing information)

#### MacOS

* Install `Neovim` (I prefer HEAD).
        
        $ brew install neovim --HEAD

* For Neovim it is recommended to use separated virtual python environments for editor's own needs (I use Fish shell and virtualfish). For any shell, these virtual environments must be located under `~/.virtualenvs/`.

        $ vf new --python=python3 neovim3
        (neovim3) $ pip install pynvim

* Clone repository to any place you prefer.

        $ git clone https://github.com/zekzekus/dotfiles.git

* Create symbolic links.

        $ cd $HOME
        $ cd .config
        $ ln -s /path/to/dotfiles/nvim .

* Create necessary directories.

        $ cd $HOME
        $ mkdir .nvimtmp

* First run will give errors. Ignore them.

        $ nvim

* execute `:Lazy install` command.

* Install necessary OS packages.

        $ brew install universal-ctags ripgrep the_silver_searcher fzf
        $ brew install tavianator/tap/bfs

## TMUX Configuration

### Mac OS X

- Install the `tmux` and `reattach-to-user-namespace` packages using Homebrew

        $ brew install tmux
        $ brew install reattach-to-user-namespace

- Create a symbolic link to `dotfiles/tmux/tmux.conf`

        ln -s /path/to/repo/dotfiles/tmux/tmux.conf ~/.tmux.conf

- Run tmux

    `$ tmux`

### Debian/Ubuntu

- Install the `xsel` and `tmux` packages

        sudo apt-get install xsel tmux

- Create a symbolic link to `dotfiles/tmux/tmux.ubuntu.conf`

        ln -s /path/to/repo/dotfiles/tmux/tmux.ubuntu.conf ~/.tmux.conf

- Run tmux

    `$ tmux`

## FISH Configuration

## CTAGS

## MACOSX
