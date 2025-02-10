set --export ZEK_DEVEL_HOME $HOME/devel/projects
set --export ZEK_DEFAULT_PROJECT_DIR sendcloud
set --export ZEK_DEVEL_WORK_HOME $ZEK_DEVEL_HOME/$ZEK_DEVEL_DEFAULT_DIR
set --export ZEK_DEVEL_PERSONAL_HOME $ZEK_DEVEL_HOME/personal

set --export PATH /opt/homebrew/bin $PATH
set --export PATH /opt/homebrew/opt/grep/libexec/gnubin $PATH
set --export PATH /usr/local/bin $PATH
set --export PATH /usr/local/sbin $PATH
set --export PATH $HOME/.local/bin $PATH
set --export PATH $HOME/.deno/bin $PATH
set --export PATH $HOME/.roswell/bin $PATH
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

if command -sq rustc
  set --export RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/library
end

alias mux='tmuxinator'

set --export FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
set --export FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set --export FZF_ALT_C_COMMAND 'bfs -type d -nohidden'

set --export HOMEBREW_NO_INSTALL_CLEANUP 1

if test -e ~/.nix-profile/etc/profile.d/nix.sh
  bass source ~/.nix-profile/etc/profile.d/nix.sh
end

if command -sq starship
  starship init fish | source
end

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

if test -e ~/.asdf/plugins/java/set-java-home.fish
  source ~/.asdf/plugins/java/set-java-home.fish
end

fish_add_path /opt/homebrew/opt/llvm/bin
fish_add_path /opt/homebrew/opt/mysql-client@5.7/bin

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /Users/zekeriyakoc/.ghcup/bin $PATH # ghcup-env


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/Users/zekeriyakoc/.opam/opam-init/init.fish' && source '/Users/zekeriyakoc/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration
