if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set --export GOROOT /usr/local/opt/go/libexec
set --export GOPATH $HOME/go

# PATH modifications. last item has the highest priority
set --export PATH /usr/local/bin $PATH
set --export PATH /usr/local/sbin $PATH
set --export PATH /usr/local/opt/go/libexec/bin $PATH
set --export PATH $HOME/.cargo/bin $PATH
set --export PATH $GOPATH/bin $PATH
set --export PATH $HOME/.local/bin $PATH
set --export PATH $HOME/.ghcup/bin $PATH
set --export PATH $HOME/.cabal/bin $PATH
set --export PATH $HOME/bin $PATH
set -g fish_user_paths "/usr/local/opt/icu4c/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/icu4c/sbin" $fish_user_paths

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
status --is-interactive; and source (nodenv init -|psub)
status --is-interactive; and source (rbenv init -|psub)
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

set --export FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
set --export FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set --export FZF_ALT_C_COMMAND 'bfs -type d -nohidden'

set --export HOMEBREW_NO_INSTALL_CLEANUP 1

starship init fish | source
