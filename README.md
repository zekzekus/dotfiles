# My Personal Configuration Files

The installation instructions are coming soon... (WIP)

## VIM Configuration

* Compatible with both [Vim >=8](https://www.vim.org/) and [Neovim](https://neovim.io/).
* Some plugins might not support vanilla Vim without compiled python3.
* Recommended environment includes [iTerm nightly](https://www.iterm2.com/downloads/nightly) and [tmux](https://tmux.github.io/).
* Plugins managed by [vim-plug](https://github.com/junegunn/vim-plug).
* Primary programming languages supported: `Python`, `Haskell`, `Rust`, `Go`, and `Javascript (React)`.
* Language support is available via corresponding [Language Servers](https://microsoft.github.io/language-server-protocol/implementors/servers/) except for `Go`.
* Mnemonic keyboard shortcuts. E.g. file based actions under `<Leader>f` and buffer based shortcuts are under `<Leader>b`.
* Leader key is `space`.
* Local leader is `\`.
* I am using default Vim functionality for completion. And if language server supports completion `omnifunc` set to language server's completion function.

### Installation

#### MacOS

* Install `Neovim` (i prefer HEAD).
        
        brew install neovim --HEAD

* For Neovim it is recommended to use separated virtual python environments for
  editor's own needs (i use Fish shell and virtualfish). For any shell, these
  virtual environments must be located under `~/.virtualenvs/`.

        vf new neovim2

        vf new --python=python3 neovim3

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

* Install necessary OS packages.

        $ brew install ctags ripgrep the_silver_searcher

* Install Language Servers for the languages you want work on.
    * [Python Language Server](https://github.com/palantir/python-language-server)
    * [Haskell IDE Engine](https://github.com/haskell/haskell-ide-engine)
    * [Rust Language Server](https://github.com/rust-lang-nursery/rls)
    * [Javascript/Typescript Language Server](https://github.com/sourcegraph/javascript-typescript-langserver)

### Keybindings List

Notable custom keybindings;

* File based operations (starts with `<leader>f`)
    * `<leader>ff` Find files. Fuzzy search UI populated with ripgrep.
    * `<leader>fj` Find junkfile files. Fuzzy search UI populated with files in junk file folder.
    * `<leader>ft` Toggle tagbar.
    * `<leader>fs` Write buffer to disk. Equilavent `:w<cr>`.
    * `<leader>fW` Remove trailing whitespace from whole buffer.
    * `<leader>fl` Populates all lines of current file into fuzzy search UI.
    * `<leader>fo` Poplulates (on the fly) all tags (outline) in the file (ctags) into fuzzy search UI.
* Buffer based operations (starts with `<leader>b`)
    * `<leader>bb` List buffer to jump. Fuzzy search UI.
    * `<leader>bd` Delete current buffer. Equivalent of `:bd<cr>`.
    * `<leader><tab>` Switch to previous buffer. Equilavent to `:b#<cr>`.
* Search based operations
    * `n` mapped to `nzzzv` to keep matching line in the middle of the screen.
    * `<leader>/` greps recursively in the directory and loads results into fuzzy search UI including preview for each row.
    * `<leader>*` same as previous one except this does not wait for input. Instead uses the word under cursor as input.
    * `<leader>ss` uses grepper plugin to grep. Results loaded into quickfix window.
    * `<BS>` executes `:nohlsearch<cr>`.
* Other
    * `<leader>V` selects just pasted text.
* Language server client bindings
    * `<leader>md` jump to definition of the symbol under cursor using language server.
    * `<leader>mt` shows hover information using language server.
    * `<leader>mr` rename the symbol under cursor using language server.
    * `<leader>mn` shows usages of the symbol under cursor using language server.

Check [keybindings.vim](https://github.com/zekzekus/dotfiles/blob/master/nvim/keybindings.vim) for all custom
keybindings. Filetype based keybindings (for haskell, python etc.) and confogurations can be found in corresponding files under `nvim/after/ftplugin` directory.

### Plugins List

Check [plugins.vim](https://github.com/zekzekus/dotfiles/blob/master/nvim/plugins.vim) for all plugins. 

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
