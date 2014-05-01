# My Personal Configuration Files

## VIM Configuration

Now i am using [Vundle](https://github.com/gmarik/Vundle.vim) to manage my VIM plugins.

Based on instructions [here](http://haridas.in/vim-as-your-ide.html).

My first and most useful suggestion is this: BUILD YOUR OWN SET OF VIM
CONFIGURATION!! I strongly recommend [this](http://mislav.uniqpath.com/2011/12/vim-revisited/) article to start with a minimum
set of configuration options. Than build your editing environment incrementally
due to your very personal taste of preferences.

Installation steps for who loves risky stuff.

- clone the repo.
- execute `git submodule update --init --recursive`
- make a symbolic link of REPO_PATH/vim/vimfiles to ~/.vim
- make a symbolic link of REPO_PATH/vim/vimrc to ~/.vimrc
- create a directory for persistent undo history `mkdir ~/.vimtmp`
- install necessary external programs. as i remember:
    - flake8 for syntax checks. `pip install flake8` used by sytastic plugin.
    - ctags for tagbar and ctrlp plugin. You can use your OS package manager to
install
- execute `vim +PluginInstall +qall`
- cd into `~/.vim/bundle/YouCompleteMe` then `./install.sh`
- if you develop golang then you must install related tools for [this](https://github.com/fatih/vim-go) plugin manually.

Yeah these should be enough to use my VIM configuration on your system. If
these are not sufficient, please warn me.

### Most notable commands, shortcuts etc. (mode indicator inside parantheses)

- leader key is `,`
- `F3` key to toggle vim Paste mode
- `<leader>space` for removing highlights (`:noh`)
- `<leader>W` to remove trailing whitespace from whole buffer
- `<leader>v` to select just pasted text
- `jj` to `<ESC>`
- `<C-n>` toggle NerdTree
- `<leader>l` toggle Tagbar
- `F5` key toggle background color
- `<leader>V` activate specified python virtualenv
- `<leader>t` activate default CtrlP plugin
- `<leader>b` activate CtrlP buffer list
- `<leader>y` activate CtrlP buffer tags list
- `<leader>G` toggle Gundo plugin
- `<leader>o` executes `:only` command. Makes active buffer full screen
- `<leader>w` bound to `:w` command. Saved the buffer
- `<leader>,` switch to last edited buffer
- `<C-u>` convert the word uppercase (both NORMAL and INSERT)
- `<leader>s` triggers Dash search based on active buffer's filetype
- `<leader>S` triggers global Dash search
- `<leader>d` tries to Go to definition of identifier under cursor. Works with
  python and Go files out of the box.
- `K` show godoc of the identifier under cursor for go source files
- `<C-j>` expand snippet (INSERT)
- `<C-b>` jump next edit point within the snippet (INSERT)
- `<C-z>` jump previous edit point within the snippet (INSERT)

## TMUX Configuration

Very basic conf.
- For Mac OS X --> `brew install reattach-to-user-namespace`
- For Ubuntu/Linux --> `sudo aptitude install xsel`
- Symbolic link tmux/tmux.conf or tmux/tmux.ubuntu.conf to ~/.tmux.conf based on your
  platform choice.
- Check and modify shell command based preference. Default is zsh for now.

## ZSH Configuration

Based on oh-my-zsh.
- Install zsh `brew install zsh` or `sudo aptitude install zsh` based on your platform.
- Install [Oh My Zsh!](https://github.com/robbyrussell/oh-my-zsh).
- Rename ~/.zshrc to ~/.zshrc_backup
- Symbolic link zsh/zshrc to ~/.zshrc
- Default theme is my own customization to norm theme. If you want to use it,
  you must make a symbolic link zsh/oh-my-zsh/themes/normz.zsh-theme to
  ~/.oh-my-zsh/themes directory.

## FISH Configuration

All conf files are meant to be symlinked to proper places.
