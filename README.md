# My Personal Configuration Files

## VIM Configuration

My first and most useful suggestion is this: BUILD YOUR OWN SET OF VIM
CONFIGURATION!! I strongly recommend [this](http://mislav.uniqpath.com/2011/12/vim-revisited/) article to start with a minimum
set of configuration options. Than build your editing environment incrementally
due to your very personal taste of preferences.

Installation steps for who loves risky stuff.

IMPORTANT NOTE: now my setup heavily uses [Unite](https://github.com/Shougo/unite.vim) plugin for various type of
listings. Current MacVim does have a problem with garbage collecting causes
freezing of vim after selection from any unite buffer. This problem is fixed
with regular Vim source code. So i strongly recommend using latest official Vim
distribution until MacVim includes the patch about this bug.

IMPORTANT NOTE (2015-03-26): i started to use [neobundle](https://github.com/Shougo/neobundle.vim) for vim plugin
management. Besides, i am using [neocomplete](https://github.com/Shougo/neocomplete.vim) for auto completion and removed
youcompleteme from my stack. I migrated my package manager from Vundle to
NeoBundle with these commands under `vim/vimfiles/bundle` directory; `ls | grep
-v neobundle.vim | xargs rm -rf` then `vim +NeoBundleInstall +qall` command.
With neobundle some of the compilation commands i mentioned below are
deprecated because these NeoBundle can execute them.

- clone the repo.
- execute `git submodule update --init --recursive`
- make a symbolic link of REPO_PATH/vim/vimfiles to ~/.vim
- make a symbolic link of REPO_PATH/vim/vimrc to ~/.vimrc
- create a directory for persistent undo history `mkdir ~/.vimtmp`
- install necessary external programs. as i remember:
    - flake8 for syntax checks. `pip install flake8` used by sytastic plugin.
    - ctags for tagbar and ctrlp plugin. You can use your OS package manager to
    - install ag aka the silver searcher
install
- execute `vim +NeoBundleInstall +qall`

Yeah these should be enough to use my VIM configuration on your system. If
these are not sufficient, please warn me.

### Most notable commands, shortcuts etc. (mode indicator inside parantheses)

- leader key is `space`
- `F3` key to toggle vim Paste mode
- `<leader>n` for removing highlights (`:noh`)
- `<leader>W` to remove trailing whitespace from whole buffer
- `<leader>v` to select just pasted text
- `jj` to `<ESC>`
- `<C-s>` toggle [NerdTree](https://github.com/scrooloose/nerdtree)
- `<leader>t` toggle [Tagbar](https://github.com/majutsushi/tagbar)
- `F5` key toggle background color
- `<leader>V` activate specified python virtualenv
- `<leader>f` activate [Unite](https://github.com/Shougo/unite.vim) source
  for files (recursive)
- `<leader>g` activate [Unite](https://github.com/Shougo/unite.vim) git source
- `<leader>b` activate [Unite](http://kien.github.io/ctrlp.vim/) buffer list
  with quick selection
- `<leader>B` activate [Unite](https://github.com/Shougo/unite.vim) buffer list
- `<leader>y` activate [Unite](https://github.com/Shougo/unite.vim) buffer outline
- `<leader>e` activate [Unite](https://github.com/Shougo/unite.vim) recent files
- `<leader>h` activate [Unite](https://github.com/Shougo/unite.vim) history/yank
  list
- `<leader>l` activate [Unite](https://github.com/Shougo/unite.vim) lines of
  current file
- `<leader>/` activate [Unite](https://github.com/Shougo/unite.vim) grep
- `<leader>H` activate [Unite](https://github.com/Shougo/unite.vim) for vim help
  content
- `<leader>j` activate [Unite](https://github.com/Shougo/unite.vim) for [junkfile](https://github.com/Shougo/junkfile.vim) plugin
  plugin
- `<leader>G` toggle [Gundo](https://github.com/sjl/gundo.vim) plugin
- `<leader>o` executes `:only` command. Makes active buffer full screen
- `<leader>w` bound to `:w` command. Saved the buffer
- `<leader><tab>` switch to last edited buffer
- `<C-u>` convert the word uppercase (both NORMAL and INSERT)
- `<leader>s` triggers [Dash](http://kapeli.com/dash) search based on active buffer's filetype
- `<leader>S` triggers global [Dash](http://kapeli.com/dash) search
- `<leader>d` tries to go to definition of identifier under cursor. Works with
  python and Go files out of the box.
- `K` show godoc of the identifier under cursor for go source files
- `<C-j>` expand snippet (INSERT)
- `<C-b>` jump next edit point within the snippet (INSERT)
- `<C-z>` jump previous edit point within the snippet (INSERT)
- `<C-n>` to invoke multiple cursors plugin [info](https://github.com/terryma/vim-multiple-cursors)

## TMUX Configuration

Very basic conf.
- For Mac OS X --> `brew install reattach-to-user-namespace`
- For Ubuntu/Linux --> `sudo aptitude install xsel`
- Symbolic link tmux/tmux.conf or tmux/tmux.ubuntu.conf to ~/.tmux.conf based on your
  platform choice.
- Check and modify shell command based preference. Default is fish for now.

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

Based on oh-my-fish
- Install fish shell `brew install fish` or `sudo aptitude install fish` based
  on your platform.
- `pip install virtualfish`
- Install [Oh My Fish](https://github.com/bpinto/oh-my-fish).
- Create a symbolic link fish/config.fish to ~/.config/fish/config.fish
- Create a symbolic link fish/oh-my-fish/custom to ~/.oh-my-fish/custom
- Check and modify your TMUX conf to use fish.
