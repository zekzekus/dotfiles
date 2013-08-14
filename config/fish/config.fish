set CONFIGDIR (dirname (status -f))
set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local/opt/ruby/bin $PATH

set -x GOPATH $HOME/devel/go
set -x PATH $GOPATH/bin $PATH

set -x EDITOR /usr/local/bin/vim

# no greeting
set fish_greeting

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow

# Status Chars
set __fish_git_prompt_char_dirtystate '*'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'

# load external submodules
. $CONFIGDIR/bundle/virtualfish/virtual.fish
