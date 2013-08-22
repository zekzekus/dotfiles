host_prompt () {
    if [ $SSH_CLIENT ] && echo "%{$fg[red]%}Δ " || echo "%{$fg[yellow]%}λ "
}

PROMPT='$(host_prompt)%{$fg[green]%}%c %{$fg[yellow]%}→ $(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%} → %{$reset_color%}"
