# SYNOPSIS
#   zekus [options]
#
# USAGE
#   Options
#

function init -a path --on-event init_zekus
    # PATH modifications. last item has the highest priority
    set --export GOPATH $HOME/devel/projects/go
    set --export PATH /usr/local/sbin $PATH
    set --export PATH /usr/local/bin $PATH
    set --export PATH /usr/local/share/npm/bin $PATH
    set --export PATH $GOPATH/bin $PATH
    set --export PATH $HOME/bin $PATH

    set --export GHC_DOT_APP /Applications/ghc-7.8.4.app
    set --export PATH $HOME/.local/bin $PATH

    set --export LANG "en_US.UTF-8"
    set --export LC_COLLATE "en_US.UTF-8"
    set --export LC_CTYPE "en_US.UTF-8"
    set --export LC_MESSAGES "en_US.UTF-8"
    set --export LC_MONETARY "en_US.UTF-8"
    set --export LC_NUMERIC "en_US.UTF-8"
    set --export LC_TIME "en_US.UTF-8"
    set --export LC_ALL "en_US.UTF-8"

    # python virtualenv tool
    set -g VIRTUALFISH_COMPAT_ALIASES
    eval (python -m virtualfish)
end

function zekus -d "My package"

end

function uninstall --on-event uninstall_zekus

end
