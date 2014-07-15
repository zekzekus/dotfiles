# PATH modifications. last item has the highest priority
set --export PATH (brew --prefix)/bin $PATH
set --export PATH /usr/local/share/npm/bin $PATH
set --export PATH $HOME/bin $PATH

# my favorite text editor
set -U EDITOR vim

# python virtualenv tool
set -g VIRTUALFISH_COMPAT_ALIASES
. ~/.config/fish/plugins/virtualfish.git/virtual.fish

# color codes for prompt functions
set -g fish_color_user magenta
set -g fish_color_host yellow
set -g fish_prompt_git_status_git_dir '⚒'
set -g fish_prompt_git_remote_space ' '
