function fish_prompt --description 'Write out the prompt'
  # color codes for prompt functions
  set -g fish_color_user magenta
  set -g fish_color_host yellow
  set -g fish_prompt_git_status_git_dir '⚒'
  set -g fish_prompt_git_remote_space ' '

  set -l last_status $status

  if set -q VIRTUAL_ENV
    echo -n -s (set_color cyan) "{" (basename "$VIRTUAL_ENV") (set_color normal)"}"
  end

  echo -n ':'

  # PWD
  set_color $fish_color_cwd
  echo -n (basename (prompt_pwd))
  set_color normal

  echo -n ':'

  printf '%s ' (__informative_git_prompt)

  if not test $last_status -eq 0
    set_color $fish_color_error
  end

  if set -q SSH_CLIENT
    echo -n '>> '
  else
    echo -n '> '
  end

  set_color $fish_color_normal

end
