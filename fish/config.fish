if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set --export GOROOT /usr/local/opt/go/libexec
set --export GOPATH $HOME/go
set --export PATH /usr/local/bin $PATH
set --export PATH /usr/local/sbin $PATH
set --export PATH $HOME/.cargo/bin $PATH
set --export PATH $HOME/.local/bin $PATH
set --export PATH $HOME/.cabal/bin $PATH
set --export PATH $GPATH/bin $PATH
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
set --export RUBY_CONFIGURE_OPTS --with-openssl-dir=/usr/local/opt/openssl@1.1
set --export RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src

alias mux='tmuxinator'

set --export FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
set --export FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set --export FZF_ALT_C_COMMAND 'bfs -type d -nohidden'

set --export HOMEBREW_NO_INSTALL_CLEANUP 1

rbenv init - | source
nodenv init - | source
direnv hook fish | source

if test -e ~/.nix-profile/etc/profile.d/nix.sh
  bass source ~/.nix-profile/etc/profile.d/nix.sh
end

starship init fish | source
set -g fish_user_paths "/usr/local/opt/openjdk@11/bin" $fish_user_paths

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
test -f /Users/zekus/.ghcup/env ; and set -gx PATH $HOME/.cabal/bin /Users/zekus/.ghcup/bin $PATH
set -g fish_user_paths "/usr/local/opt/ruby/bin" $fish_user_paths
