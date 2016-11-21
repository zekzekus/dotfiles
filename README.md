# My Personal Configuration Files

The installation instructions are coming soon...

## VIM Configuration

## TMUX Configuration
#### Mac OS X
- First install Homebrew

        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

- Next, install the `tmux` and `reattach-to-user-namespace` packages using Homebrew

        brew install tmux
        brew install reattach-to-user-namespace
- Create a symbolic link to `dotfiles/tmux/tmux.conf`

        ln -s /path/to/repo/dotfiles/tmux/tmux.conf ~/.tmux.conf

- ###### (Optional) Change the shell from `fish` to `zsh`
    - Open `~/.tmux.conf` in your favourite editor and edit the `MYSHELL` and `MYSHELL_PATH` variables in the file which defaults to `fish`

            ...
            3 # SHELL choice (zsh | fish)
            4 MYSHELL=zsh
            5 MYSHELL_PATH=/usr/local/bin/zsh
            ...

- Run tmux

    `~$ tmux`

- ##### Et voilà!

#### Debian/Ubuntu

- Install the `xsel` and `tmux` packages

        sudo apt-get install xsel tmux
- Create a symbolic link to `dotfiles/tmux/tmux.ubuntu.conf`

        ln -s /path/to/repo/dotfiles/tmux/tmux.ubuntu.conf ~/.tmux.conf

- ###### (Optional) Change the shell from `fish` to `zsh`
    - Open `~/.tmux.conf` in your favourite editor and edit the `MYSHELL` and `MYSHELL_PATH` variables in the file which defaults to `fish`

            ...
            3 # SHELL choice (zsh | fish)
            4 MYSHELL=zsh
            5 MYSHELL_PATH=/usr/bin/zsh
            ...

- Run tmux

    `~$ tmux`

- #### Troubleshooting :
    - If you get an error regarding `ambiguous option: mouse` edit your `~/.tmux.conf` and change the `set -g mouse on` to this

            # set -g mouse on

- ##### Et voilà!

## ZSH Configuration

- Install zsh `brew install zsh` or `sudo apt-get install zsh` based on your
  platform.
- Install [Oh My Zsh!](https://github.com/robbyrussell/oh-my-zsh).

## FISH Configuration

## CTAGS

## MACOSX
