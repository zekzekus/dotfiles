# My Personal Configuration Files

The installation instructions are coming soon... (WIP)

## VIM Configuration

* Compatible with [Neovim](https://neovim.io/).
* Fully supports only Neovim at the moment.
* Some plugins might not support vanilla Vim without compiled python3.
* Recommended environment includes [iTerm nightly](https://www.iterm2.com/downloads/nightly) and [tmux](https://tmux.github.io/).
* Plugins managed by [vim-plug](https://github.com/junegunn/vim-plug).
* Primary programming languages supported: `Python`, `Haskell`, `Rust`, `Go` and `Clojure`
* Mnemonic keyboard shortcuts. E.g. file based actions under `<Leader>f` and
  buffer based shortcuts are under `<Leader>b`.
* Leader key is `space`.
* Local leader is `\`.

### Installation

#### MacOS

* Install `Neovim` (i prefer HEAD).
        
        brew install neovim --HEAD

* For Neovim it is recommended to use separated virtual python environments for
  editor's own needs (i use Fish shell and virtualfish). For any shell these
  virtual environments must be located under `~/.virtualenvs/`.

        vf new neovim2
        pip install neovim

        vf new --python=python3 neovim3
        pip3 install neovim

* Clone repository to any place you prefer.

        git clone https://github.com/zekzekus/dotfiles.git

* Create symbolic links.

        cd $HOME
        cd .config
        ln -s /path/to/dotfiles/nvim .

* Create necessary directories.

        cd $HOME
        mkdir .nvimtmp

* First run will give errors. Ignore them.

        $ nvim

* For each editor execute `:PlugInstall` command.

### Plugins List

Check [plugins.vim](https://github.com/zekzekus/dotfiles/blob/master/nvim/plugins.vim) for all plugins and [keybindings.vim](https://github.com/zekzekus/dotfiles/blob/master/nvim/keybindings.vim) for all custom
keybindings.

## TMUX Configuration

### Mac OS X

- First install Homebrew

        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

- Next, install the `tmux` and `reattach-to-user-namespace` packages using Homebrew

        brew install tmux
        brew install reattach-to-user-namespace
- Create a symbolic link to `dotfiles/tmux/tmux.conf`

        ln -s /path/to/repo/dotfiles/tmux/tmux.conf ~/.tmux.conf

- ###### (Optional) Change the shell from `fish` to `zsh`
    - Open `~/.tmux.conf` in your favourite editor and edit the `MYSHELL` and `MYSHELL_PATH` variables in the file which defaults to `fish`

            ...
            3 # SHELL choice (zsh | fish)
            4 MYSHELL=zsh
            5 MYSHELL_PATH=/usr/local/bin/zsh
            ...

- Run tmux

    `~$ tmux`

- ##### Et voilà!

### Debian/Ubuntu

- Install the `xsel` and `tmux` packages

        sudo apt-get install xsel tmux
- Create a symbolic link to `dotfiles/tmux/tmux.ubuntu.conf`

        ln -s /path/to/repo/dotfiles/tmux/tmux.ubuntu.conf ~/.tmux.conf

- ###### (Optional) Change the shell from `fish` to `zsh`
    - Open `~/.tmux.conf` in your favourite editor and edit the `MYSHELL` and `MYSHELL_PATH` variables in the file which defaults to `fish`

            ...
            3 # SHELL choice (zsh | fish)
            4 MYSHELL=zsh
            5 MYSHELL_PATH=/usr/bin/zsh
            ...

- Run tmux

    `~$ tmux`

- #### Troubleshooting :
    - If you get an error regarding `ambiguous option: mouse` edit your `~/.tmux.conf` and change the `set -g mouse on` to this

            # set -g mouse on

- ##### Et voilà!

## ZSH Configuration

## FISH Configuration

## CTAGS

## MACOSX
