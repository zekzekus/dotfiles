# My Personal Configuration Files

## VIM Configuration

My very personal Vim configuration. Some more details below.

* Compatible with both [Vim >=8](https://www.vim.org/) and
  [Neovim](https://neovim.io/).
* Some plugins might not support vanilla Vim if not compiled with python3.
* Recommended environment includes [iTerm
  nightly](https://www.iterm2.com/downloads/nightly) and
  [tmux](https://tmux.github.io/).
* Plugins managed by [vim-plug](https://github.com/junegunn/vim-plug).
* Basic language support comes from [vim-polyglot](https://github.com/sheerun/vim-polyglot/).
* Advanced Language support is available via corresponding [Language
  Servers](https://microsoft.github.io/language-server-protocol/implementors/servers/)
  except for `Clojure` and `Ruby`. 
* Programming languages configured for LSP: `Python`, `Clojure`, `Haskell`,
  `Rust`, `Go`, `Javascript`, `Scala` and `Ruby`.
* Mnemonic keyboard shortcuts. E.g. file based actions under `<Leader>f` and
  buffer based shortcuts are under `<Leader>b`.
* Leader key is `space`.
* Local leader is `\`.
* I am using
  [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim) as
  autocompletion and language client engine.

### Key bindings List

Notable custom key bindings;

* File based operations (starts with `<leader>f`)
    * `<leader>ff` Find files. Fuzzy search UI populated with ripgrep. It shows
      project files. You can switch between these with `C-n` and `C-p`.
    * `<leader>fj` Fuzzy find junkfiles.
* Buffer based operations (starts with `<leader>b`)
    * `<leader>bb` List open buffers and prompt with fuzzy search to jump.
    * `<leader><tab>` Switch to previous buffer. Equivalent to `:b#<cr>`.
* Search based operations
    * `n` mapped to `nzzzv` to keep matching line in the middle of the screen.
    * `<BS>` executes `:nohlsearch<cr>`.
* Other
    * `<leader>V` selects just pasted text.
* Programming support bindings.
    * `<C-p>` list supported LSP functionalities

Check
[keybindings.vim](https://github.com/zekzekus/dotfiles/blob/master/nvim/keybindings.vim)
for all custom keybindings. Filetype based keybindings (for haskell, python
etc.) and configurations can be found in corresponding files under
`nvim/after/ftplugin` directory.

### Plugins List

Check
[plugins.vim](https://github.com/zekzekus/dotfiles/blob/master/nvim/plugins.vim)
for all plugins. 

### Installation

#### MacOS

* Install `Neovim` (I prefer HEAD).
        
        $ brew install neovim --HEAD

* For Neovim it is recommended to use separated virtual python environments for
  editor's own needs (I use Fish shell and virtualfish). For any shell, these
  virtual environments must be located under `~/.virtualenvs/`.

        $ vf new --python=python2 neovim2
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

* Install Language Servers for the languages you want work on.
    * [Python Language
      Server](https://github.com/palantir/python-language-server)
    * [Haskell IDE Engine](https://github.com/haskell/haskell-ide-engine)
    * [Rust Language Server](https://github.com/rust-lang-nursery/rls)
    * [Javascript/Typescript Language
      Server](https://github.com/sourcegraph/javascript-typescript-langserver)
    * [Ruby](https://solargraph.org)

## TMUX Configuration

### Mac OS X

- First install Homebrew

        /usr/bin/ruby -e "$(curl -fsSL
        https://raw.githubusercontent.com/Homebrew/install/master/install)"

- Next, install the `tmux` and `reattach-to-user-namespace` packages using
  Homebrew

        $ brew install tmux
        $ brew install reattach-to-user-namespace
- Create a symbolic link to `dotfiles/tmux/tmux.conf`

        ln -s /path/to/repo/dotfiles/tmux/tmux.conf ~/.tmux.conf

- ###### (Optional) Change the shell from `fish` to `zsh`
    - Open `~/.tmux.conf` in your favorite editor and edit the `MYSHELL` and
      `MYSHELL_PATH` variables in the file which defaults to `fish`

            ...  3 # SHELL choice (zsh | fish) 4 MYSHELL=zsh 5
            MYSHELL_PATH=/usr/local/bin/zsh ...

- Run tmux

    `~$ tmux`

- ##### Et voilà!

### Debian/Ubuntu

- Install the `xsel` and `tmux` packages

        sudo apt-get install xsel tmux
- Create a symbolic link to `dotfiles/tmux/tmux.ubuntu.conf`

        ln -s /path/to/repo/dotfiles/tmux/tmux.ubuntu.conf ~/.tmux.conf

- ###### (Optional) Change the shell from `fish` to `zsh`
    - Open `~/.tmux.conf` in your favorite editor and edit the `MYSHELL` and
      `MYSHELL_PATH` variables in the file which defaults to `fish`

            ...  3 # SHELL choice (zsh | fish) 4 MYSHELL=zsh 5
            MYSHELL_PATH=/usr/bin/zsh ...

- Run tmux

    `~$ tmux`

- #### Troubleshooting :
    - If you get an error regarding `ambiguous option: mouse` edit your
      `~/.tmux.conf` and change the `set -g mouse on` to this

            # set -g mouse on

- ##### Et voilà!

## FISH Configuration

## CTAGS

## MACOSX
