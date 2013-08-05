function fish_prompt --description 'Write out the prompt'
    if set -q VIRTUAL_ENV
        echo -n -s (set_color -b blue white) (basename "$VIRTUAL_ENV") (set_color normal) " "
    end

    set last_status $status

    set_color $fish_color_cwd
    printf '%s' (prompt_pwd)
    set_color normal

    printf '%s ' (__fish_git_prompt)

    set_color normal

end
