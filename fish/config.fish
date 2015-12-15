# PATH modifications. last item has the highest priority
set --export GOPATH $HOME
set --export PATH /usr/local/sbin $PATH
set --export PATH /usr/local/bin $PATH
set --export PATH /usr/local/share/npm/bin $PATH
set --export PATH /usr/local/opt/go/libexec/bin $PATH
set --export PATH $HOME/.stack/programs/x86_64-osx/ghc-7.10.2/bin $PATH
set --export PATH $HOME/.multirust/toolchains/nightly/cargo/bin $PATH
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

set --export RUST_SRC_PATH ~/devel/tools/rust/src/

if test -d ~/.config/fish/functions/rust.fish
    . ~/.config/fish/functions/rust.fish/rustc.fish
    . ~/.config/fish/functions/rust.fish/cargo.fish
end
