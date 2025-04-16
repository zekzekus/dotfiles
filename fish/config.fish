set --export PATH /opt/homebrew/bin $PATH
set --export PATH /opt/homebrew/opt/grep/libexec/gnubin $PATH
set --export PATH /usr/local/bin $PATH
set --export PATH /usr/local/sbin $PATH
set --export PATH $HOME/.local/bin $PATH
set --export PATH $HOME/.deno/bin $PATH
set --export PATH $HOME/.roswell/bin $PATH
set --export PATH $HOME/Library/Application\ Support/Coursier/bin $PATH
set --export PATH $HOME/bin $PATH

if command -sq rustc
  set --export RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/library
end

alias mux='tmuxinator'

if test -e ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  bass source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
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
