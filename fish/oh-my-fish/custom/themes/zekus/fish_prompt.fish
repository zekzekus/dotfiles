# name: zekus

# ----------------------------------------------------------------------------
# Utils
# ----------------------------------------------------------------------------

set -g __zekus_display_rprompt 1

function toggle_right_prompt -d "Toggle the right prompt of the zekus theme"
  if test $__zekus_display_rprompt -eq 0
    echo "enable right prompt"
    set __zekus_display_rprompt 1
  else
    echo "disable right prompt"
    set __zekus_display_rprompt 0
  end
end

function __zekus_virtualenv
  if set -q VIRTUAL_ENV
    echo "["(basename "$VIRTUAL_ENV")"]"
  end
end

function __zekus_git_branch_name -d "Return the current branch name"
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function __zekus_git_repo_name -d "Return the current repository name"
  echo (command basename (git rev-parse --show-toplevel ^/dev/null))
end

function __zekus_git_repo_base -d "Return the current repository name"
  echo (command git rev-parse --show-toplevel ^/dev/null)
end

function __zekus_git_status -d "git status command"
  git status -b -s --ignore-submodules=dirty
end

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------

alias trp toggle_right_prompt

# ----------------------------------------------------------------------------
# Prompts
# ----------------------------------------------------------------------------

function fish_prompt -d "Write out the left prompt of the zekus theme"
  set -l last_status $status
  set -l basedir_name (basename (prompt_pwd))

  # Init colors

  set -l colcyan   (set_color cyan)
  set -l colbcyan  (set_color -o cyan)
  set -l colgreen  (set_color green)
  set -l colbgreen (set_color -o green)
  set -l colnormal (set_color normal)
  set -l colred    (set_color red)
  set -l colbred   (set_color -o red)
  set -l colwhite  (set_color white)
  set -l colbwhite  (set_color -o white)
  
  # Segments
  
  # git
  set -l ps_git ""
  set -l git_branch_name (__zekus_git_branch_name)
  if test -n "$git_branch_name"
    set -l git_repo_name (__zekus_git_repo_name)
    set -l git_status (__zekus_git_status)
    set -l colbranch $colbgreen
    if echo $git_status | grep -E "\s\?\?\s|\sM\s|\sD\s" > /dev/null
      set colbranch $colbred
    end
    set ps_git $colbwhite"~:"$colbcyan$git_repo_name$colbranch"{"$git_branch_name"}"
    if test "$basedir_name" != "$git_repo_name"
        set ps_git $ps_git$colnormal":"$colbwhite$basedir_name
    end
  end

  # pwd
  set -l ps_pwd ""
  if test -z "$ps_git"
    set -l depth (echo (pwd) | sed "s/\// /g" | wc -w)
    set -l in_home (echo (pwd) | grep ~)
    if test -n "$in_home"
      set ps_pwd $colbwhite"~"
    else
      set ps_pwd $colbwhite"/"
    end
    if test (echo (pwd)) != ~ -a (echo (pwd)) != /
      set ps_pwd $ps_pwd":"$colgreen$basedir_name
    end
  end
      
  # vi mode
  # If vi_mode plugin or native vi mode is activated then print the vi mode
  # in the prompt.
  set -l ps_vi ""
  if test -n "$vi_mode"
    set ps_vi $colnormal"["$vi_mode$colnormal"]"
  end
  if test "$fish_key_bindings" = "fish_vi_key_bindings" -o "$fish_key_bindings" = "my_fish_key_bindings" 
    switch $fish_bind_mode
      case default
        set ps_vi $colnormal"("$colred"N"$colnormal")"
      case insert
        set ps_vi $colnormal"("$colgreen"I"$colnormal")"
      case visual
        set ps_vi $colnormal"("$colwhite"V"$colnormal")"
    end
  end

  # end of prompt
  # The color of the end of the prompt depends on the $status value of the
  # last executed command. It is green or red depending on the last command
  # success or failure respectively.
  # Since I often use ranger and use its 'shift+s' key binding to bring a shell
  # session, there is discreet indicator when the parent process of the current
  # shell pid is a ranger process. In this case the end of the prompt is written
  # twice.
  # With this indicator I can quickly remember that I can "ctrl+d" to end the
  # the current shell process and get back to the ranger process.
  set -l ps_end ">"
  #
  # last status give the color of the right arrows at the end of the prompt
  if test $last_status -ne 0 
    set ps_end $colnormal$colbred$ps_end
  else
    set ps_end $colnormal$colgreen$ps_end
  end

  # Left Prompt

  echo -n -s (__zekus_virtualenv) $ps_git $ps_pwd $ps_git_dirty ' ' $ps_end ' '
end


function fish_right_prompt -d "Write out the right prompt of the zekus theme"
  set -l colnormal (set_color normal)

  # Segments

  # The where segment format is X@Y where:
  #   X is the username
  #   Y is the hostname
  if set -q SSH_CLIENT
    set -l ps_where $colnormal(whoami)@(hostname|cut -d . -f 1)
  end
  
  # Right Prompt

  if test $__zekus_display_rprompt -eq 1
    echo -n -s $ps_where
  end
end

