# PATH modifications. last item has the highest priority
set --export GOPATH $HOME/go
set --export PATH /usr/local/bin $PATH
set --export PATH /usr/local/opt/go/libexec/bin $PATH
set --export PATH $HOME/.cargo/bin $PATH
set --export PATH $GOPATH/bin $PATH
set --export PATH $HOME/bin $PATH

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

if test -d ~/.config/fish/functions/rust.fish
    . ~/.config/fish/functions/rust.fish/rustc.fish
    . ~/.config/fish/functions/rust.fish/cargo.fish
end

set --export EDITOR vim

set --export RUST_SRC_PATH $HOME/devel/tools/rust/src
set --export FZF_DEFAULT_COMMAND 'rg --files --follow --glob "!.git/*"'

if test -f /usr/local/bin/thefuck
    eval (thefuck --alias | tr '\n' ';')
end
