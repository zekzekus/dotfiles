# My Personal Configuration Files

## VIM Configuration

NOTE: I gave up on making config fully compatible with both Vim and Neovim
because Neovim took a different path. So now Vim and Neovim configurations are
maintained separately and Neovim part will be as much as possible in pure Lua.

Some part of the information below might be outdated. I will try update it soon.

My very personal Vim configuration. Some more details below.

* Compatible with both [Vim >=8](https://www.vim.org/) and [Neovim](https://neovim.io/).
* Some plugins might not support vanilla Vim if not compiled with python3.
* Recommended environment includes [iTerm nightly](https://www.iterm2.com/downloads/nightly) and [tmux](https://tmux.github.io/).
* Plugins managed by [vim-plug](https://github.com/junegunn/vim-plug).
* Basic language support comes from [vim-polyglot](https://github.com/sheerun/vim-polyglot/).
* Mnemonic keyboard shortcuts. E.g. file based actions under `<Leader>f` and buffer based shortcuts are under `<Leader>b`.
* Leader key is `space`.  Local leader is `\`.

### Key bindings List

Notable custom key bindings;

* File based operations (starts with `<leader>f`)
    * `<leader>ff` Find files. Fuzzy search UI populated with ripgrep. It shows project files. You can switch between these with `C-j` and `C-k`.
    * `<leader>fs` Save file in active buffer.
    * `<leader>fj` Fuzzy find junkfiles.
    * `<leader>fW` Remove trailing whitespace from whole buffer.
* Buffer based operations (starts with `<leader>b`)
    * `<leader>bb` List open buffers and prompt with fuzzy search to jump.
    * `<leader>bd` Delete current buffer. (runs `:bdelete`)
    * `<leader><tab>` Switch to previous buffer. Equivalent to `:b#<cr>`.
* Search based operations
    * `n` mapped to `nzzzv` to keep matching line in the middle of the screen.
    * `<BS>` executes `:nohlsearch<cr>`.
* Other
    * `<leader>V` selects just pasted text.

Check [keybindings.vim](https://github.com/zekzekus/dotfiles/blob/master/nvim/keybindings.vim) for all custom keybindings. Filetype based keybindings (for haskell, python etc.) and configurations can be found in corresponding files under `nvim/after/ftplugin` directory.

### Plugins List

Check [plugins.vim](https://github.com/zekzekus/dotfiles/blob/master/nvim/plugins.vim) for all plugins. 

### Installation

#### MacOS

* Install `Neovim` (I prefer HEAD).
        
        $ brew install neovim --HEAD

* For Neovim it is recommended to use separated virtual python environments for editor's own needs (I use Fish shell and virtualfish). For any shell, these virtual environments must be located under `~/.virtualenvs/`.

        $ vf new --python=python3 neovim3

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

* For each editor execute `:PlugInstall` command.

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
