set --export PATH /opt/homebrew/bin $PATH
set --export PATH /usr/local/bin $PATH
set --export PATH /usr/local/sbin $PATH
set --export PATH $HOME/.cargo/bin $PATH
set --export PATH $HOME/.local/bin $PATH
set --export PATH $HOME/.deno/bin $PATH
set --export PATH $HOME/Library/Application\ Support/Coursier/bin $PATH
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
set --export MANPAGER "nvim +Man!"
set --export RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/library

alias mux='tmuxinator'

set --export FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
set --export FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set --export FZF_ALT_C_COMMAND 'bfs -type d -nohidden'

set --export HOMEBREW_NO_INSTALL_CLEANUP 1

if test -e ~/.nix-profile/etc/profile.d/nix.sh
  bass source ~/.nix-profile/etc/profile.d/nix.sh
end

starship init fish | source

if test -e /opt/homebrew/opt/asdf/libexec/asdf.fish
  source /opt/homebrew/opt/asdf/libexec/asdf.fish
end
