host_prompt () {
    if [ $SSH_CLIENT ] && echo "%{$fg[red]%}Δ %{$reset_color%}" || echo "%{$fg[yellow]%}λ %{$reset_color%}"
}

virtualenv_prompt () {
    if [ $VIRTUAL_ENV ] && echo "%{$fg[cyan]%}[`basename \`echo $VIRTUAL_ENV\``] %{$reset_color%}%{$fg[yellow]%}→ %{$reset_color%}"
}

PROMPT='$(host_prompt)$(virtualenv_prompt)%{$fg[green]%}%c %{$fg[yellow]%}→ $(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%} → %{$reset_color%}"
