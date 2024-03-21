#!/usr/bin/env bash

# Ensure ZEK_DEVEL_HOME and ZEK_DEFAULT_PROJECT_DIR are set
: "${ZEK_DEVEL_HOME:?Environment variable ZEK_DEVEL_HOME is not set}"
: "${ZEK_DEFAULT_PROJECT_DIR:?Environment variable ZEK_DEFAULT_PROJECT_DIR is not set}"

# Get the starting index for window numbering in tmux
TMUX_WINDOW_START_INDEX=$(tmux show-options -g | grep '^base-index' | cut -d' ' -f2)

# Function to select a project
select_project() {
    local default_project_dir=${1:-$ZEK_DEFAULT_PROJECT_DIR}
    ls -1 "$ZEK_DEVEL_HOME/$default_project_dir/" |
        fzf --exit-0 --prompt="Project: "
}

# Command to start a new tmux session for a project
tmuxgg() {
    local selected_project
    selected_project=$(select_project "$@") || return $?
    local project_dir="${1:-$ZEK_DEFAULT_PROJECT_DIR}"
    local session_name="${selected_project}"

    tmux new-session -d -s "$session_name" -c "$ZEK_DEVEL_HOME/$project_dir/$selected_project"
    tmux rename-window -t "$session_name:$TMUX_WINDOW_START_INDEX" "editor"
    tmux send-keys -t "$session_name:$TMUX_WINDOW_START_INDEX" 'nvim' C-m
    tmux new-window -t "$session_name" -n "shell" -c "$ZEK_DEVEL_HOME/$project_dir/$selected_project"
    tmux send-keys -t "$session_name:$((TMUX_WINDOW_START_INDEX + 1))" 'clear; git fetch --all' C-m

    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
    tmux select-window -t "$session_name:$TMUX_WINDOW_START_INDEX"
}

# Command to kill tmux sessions using fzf
tmuxkillf() {
    local target_sessions
    target_sessions=$(tmux ls | \
        cut -d: -f1 | \
        fzf --query="$1" --multi --exit-0) || return $?

    for session in $target_sessions; do
        session=${session%%:*}
        tmux kill-session -t "$session"
    done
}

# Command to split tmux window and open a project in nvim
tmuxgp() {
    local selected_project
    selected_project=$(select_project "$@") || return $?

    tmux split-window -h
    tmux send-keys "cd $ZEK_DEVEL_HOME/${1:-$ZEK_DEFAULT_PROJECT_DIR}/$selected_project" C-m
    tmux send-keys "nvim" C-m
}

# Execute the appropriate command based on the script name
case $(basename "$0") in
    "gg") tmuxgg "$@" ;;
    "gk") tmuxkillf "$@" ;;
    "gp") tmuxgp "$@" ;;
    *) echo "Usage: gg | gk | gp" >&2; exit 1 ;;
esac
