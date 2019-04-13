set --export GOROOT /usr/local/opt/go/libexec
set --export GOPATH $HOME/go

# PATH modifications. last item has the highest priority
set --export PATH /usr/local/bin $PATH
set --export PATH /usr/local/opt/go/libexec/bin $PATH
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

set --export EDITOR nvim
set --export MANPAGER "nvim -c 'set ft=man' -"
set --export PGDATA /usr/local/var/postgres

set --export RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src

alias mux='tmuxinator'

python3 -m virtualfish | source

if test -d ~/.config/fish/functions/rust.fish
    . ~/.config/fish/functions/rust.fish/rustc.fish
    . ~/.config/fish/functions/rust.fish/cargo.fish
end

if test -e ~/.nix-profile/etc/profile.d/nix.sh
    bass source ~/.nix-profile/etc/profile.d/nix.sh
end

status --is-interactive; and source (nodenv init -|psub)
set -g fish_user_paths "/usr/local/opt/icu4c/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/icu4c/sbin" $fish_user_paths

set -gx PATH '/Users/zekus/.jenv/shims' $PATH
set -gx JENV_SHELL fish
set -gx JENV_LOADED 1
set -e JAVA_HOME
source '/usr/local/Cellar/jenv/0.5.2/libexec/libexec/../completions/jenv.fish'
jenv rehash 2>/dev/null
function jenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case enable-plugin rehash shell shell-options
    source (jenv "sh-$command" $argv|psub)
  case '*'
    command jenv "$command" $argv
  end
end
