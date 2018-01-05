set --export GOPATH $HOME/go

# PATH modifications. last item has the highest priority
set --export PATH /usr/local/bin $PATH
set --export PATH /usr/local/opt/go/libexec/bin $PATH
set --export PATH /usr/local/opt/python/libexec/bin $PATH
set --export PATH $HOME/.fzf/bin $PATH
set --export PATH $HOME/.cargo/bin $PATH
set --export PATH $GOPATH/bin $PATH
set --export PATH $HOME/.local/bin $PATH
set --export PATH $HOME/bin $PATH

set --export LANG "en_US.UTF-8"
set --export LC_COLLATE "en_US.UTF-8"
set --export LC_CTYPE "en_US.UTF-8"
set --export LC_MESSAGES "en_US.UTF-8"
set --export LC_MONETARY "en_US.UTF-8"
set --export LC_NUMERIC "en_US.UTF-8"
set --export LC_TIME "en_US.UTF-8"
set --export LC_ALL "en_US.UTF-8"

# python virtualenv tool
python -m virtualfish | source

if test -d ~/.config/fish/functions/rust.fish
    . ~/.config/fish/functions/rust.fish/rustc.fish
    . ~/.config/fish/functions/rust.fish/cargo.fish
end

set --export EDITOR nvim
set --export MANPAGER "nvim -c 'set ft=man' -"

set --export RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src
set --export FZF_DEFAULT_COMMAND 'rg --hidden --files --follow --glob "!.git/*"'

alias mux='tmuxinator'
set -g fish_user_paths "/usr/local/opt/llvm/bin" $fish_user_paths

status --is-interactive; and source (nodenv init -|psub)

. /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
