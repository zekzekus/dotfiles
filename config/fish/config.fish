set CONFIGDIR (dirname (status -f))
set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local/opt/ruby/bin $PATH

set -x EDITOR /usr/local/bin/vim

. $CONFIGDIR/bundle/virtualfish/virtual.fish

set fish_greeting
