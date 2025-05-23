# My Personal Configuration Files

## Nix

Now I am trying to manage my dotfiles using [Nix](https://nix.dev) and [Home Manager](https://nix-community.github.io/home-manager/index.xhtml)!

In theory, it supposed to be a single command after installing Nix successfully. I am using [Determinated Nix](https://determinate.systems/nix) but vanilla Nix should work just fine.

        $ cd home-manager
        $ nix run .#homeConfigurations.zekus.activationPackage switch --impure

After first run, after every config change:

        $ home-manager switch --impure

## NEOVIM

* Fully (almost) configured with lua
* I use latest HEAD build of Neovim
* Package manager: [lazy.nvim](https://github.com/folke/lazy.nvim)
* Main static language support comes from builtin treesitter (WARNING: Installs for no language. Do not forget to install for your favorite languages)
* Dynamic language support comes from builtin LSP client
* [Mason](https://github.com/williamboman/mason.nvim) to install language servers (any language server installed with mason will be initialized when needed)
* [Keybindings](https://github.com/zekzekus/dotfiles/blob/master/nvim/lua/keybindings.lua)
* Additional keybindings when a LSP client attached: [here](https://github.com/zekzekus/dotfiles/blob/master/nvim/lua/config/lsp-zero.lua)
* [Plugins](https://github.com/zekzekus/dotfiles/blob/master/nvim/lua/plugins.lua)

## VIM

* Much simpler compared to my Neovim configuration
* I always use latest HEAD build of Vim
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
