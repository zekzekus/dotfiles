My Personal Configuration Files
===============================

VIM Configuration
-----------------
Based on instructions [here](http://haridas.in/vim-as-your-ide.html). Pathogen
must be installed.

My first and most useful suggestion is this: BUILD YOUR OWN SET OF VIM
CONFIGURATION!! I strongly recommend [this](http://mislav.uniqpath.com/2011/12/vim-revisited/) article to start with a minimum
set of configuration options. Than build your editing environment inrementally
due to your very personal taste of preferences. 

Installation steps for who loves risky stuff.

- clone the repo.
- run `git submodule update --init --recursive` command to fetch and update all submodules.
- make a symbolic link of REPO_PATH/vim/vimfiles to ~/.vim
- make a symbolic link of REPO_PATH/vim/vimrc ~/.vimrc
- follow installation process for excellent [pathogen](https://github.com/tpope/vim-pathogen) plugin
- install necessary external programs. as i remember:
    - there is no need to install jedi python library if you update git submodules recursively. This will fetch jedi library. 
    - flake8 for syntax checks. `pip install flake8` used by sytastic plugin. 
    - ctags for tagbar and ctrlp plugin. You can use your OS package manager to
install

Yeah these should be enough to use my VIM configuration on your system. If
these are not sufficient, please warn me.

TMUX Configuration
------------------
Very basic conf

ZSH Configuration
-----------------
Based on oh-my-zsh

FISH Configuration
------------------
For now i am using fish shell

All conf files are meant to be symlinked to proper place. 
