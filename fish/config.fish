# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Path to your custom folder (default path is $FISH/custom)
#set fish_custom $HOME/dotfiles/oh-my-fish

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

Theme "robbyrussell"
Theme "syl20bnr"
Theme "zekus"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Example format: set fish_plugins autojump bundler
Plugin "localhost"
Plugin "brew"
Plugin "osx"
Plugin "python"
Plugin "ssh"
Plugin "theme"
Plugin "tmux"
