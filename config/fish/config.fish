set --export PATH (brew --prefix)/bin $PATH
set --export PATH /usr/local/share/npm/bin $PATH
set --export PATH $HOME/bin $PATH

set -U EDITOR vim

. ~/.config/fish/plugins/virtualfish.git/virtual.fish

set -g fish_color_user magenta
set -g fish_color_host yellow
set -g fish_prompt_git_status_git_dir '⚒'  
set -g fish_prompt_git_remote_space ' '

function fish_prompt --description 'Write out the prompt'
  set -l last_status $status

  # User
  set_color $fish_color_user
  echo -n (whoami)
  set_color normal

  echo -n '@'

  # Host
  set_color $fish_color_host
  echo -n (hostname -s)
  set_color normal

  echo -n ':'

  # PWD
  set_color $fish_color_cwd
  echo -n (prompt_pwd)
  set_color normal

  printf '%s ' (__informative_git_prompt)

  if not test $last_status -eq 0
    set_color $fish_color_error
  end

  echo -n '$ '
  
  set_color $fish_color_normal

end

function fish_right_prompt -d "Write out the right prompt"

  # Time
  set_color -o black
  echo (date +%R)
  set_color $fish_color_normal

end

