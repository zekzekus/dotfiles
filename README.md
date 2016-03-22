# My Personal Configuration Files

## VIM Configuration

Installation steps for who loves risky stuff.

- clone the repo.
- execute `git submodule update --init --recursive`
- make a symbolic link of REPO_PATH/vim/vimfiles to ~/.vim
- make a symbolic link of REPO_PATH/vim/vimrc to ~/.vimrc
- create a directory for persistent undo history `mkdir ~/.vimtmp`
- install necessary external programs. as i remember:
    - flake8 for syntax checks. `pip install flake8` used by sytastic plugin.
    - ctags for tagbar and ctrlp plugin. You can use your OS package manager to
    - install ag aka the silver searcher install
    - nodejs and npm
- execute `vim "+PlugInstall vimproc" +qall`
- execute `vim +PlugInstall +qall`
- if you want to override some configuration options you can create a file
  called `~/.vimrc.local` and put your own settings. This file (if exists) will
  we sourced at the very end of vimrc.

Yeah these should be enough to use my VIM configuration on your system. If
these are not sufficient, please warn me.

I am using neovim for a while and this conf is completely neovim compatible. You'll need to create ~/.nvimtmp for cache purposes.

### Most notable commands, shortcuts etc. (mode indicator inside parantheses)

I am using a separated file for my all keybindings. So you can check the
keybindings.vim file and find out all my custom shortcuts easily in one single
place.

## TMUX Configuration

Very basic conf.
- For Mac OS X --> `brew install reattach-to-user-namespace`
- For Ubuntu/Linux --> `sudo aptitude install xsel`
- Symbolic link tmux/tmux.conf or tmux/tmux.ubuntu.conf to ~/.tmux.conf based
  on your platform choice.
- Check and modify shell command based preference. Default is fish for now.

## ZSH Configuration

Based on oh-my-zsh.
- Install zsh `brew install zsh` or `sudo aptitude install zsh` based on your
  platform.
- Install [Oh My Zsh!](https://github.com/robbyrussell/oh-my-zsh).
- Rename ~/.zshrc to ~/.zshrc_backup
- Symbolic link zsh/zshrc to ~/.zshrc
- Default theme is my own customization to norm theme. If you want to use it,
  you must make a symbolic link zsh/oh-my-zsh/themes/normz.zsh-theme to
  ~/.oh-my-zsh/themes directory.

## FISH Configuration

Based on plain old fish
- Install fish shell `brew install fish` or `sudo aptitude install fish` based
  on your platform.
- `pip install virtualfish`
- Create a symbolic link fish/config.fish to ~/.config/fish/config.fish
- Create a symbolic link fish/functions/ to ~/.config/fish/functions
- Check and modify your TMUX conf to use fish.
