#!/usr/bin/env bash

# Ensure ZEK_DEVEL_HOME and ZEK_DEFAULT_PROJECT_DIR are set
: "${ZEK_DEVEL_HOME:?Environment variable ZEK_DEVEL_HOME is not set}"
: "${ZEK_DEFAULT_PROJECT_DIR:?Environment variable ZEK_DEFAULT_PROJECT_DIR is not set}"

# Function to select a project
select_project() {
    local default_project_dir=${1:-$ZEK_DEFAULT_PROJECT_DIR}
    ls -1 "$ZEK_DEVEL_HOME/$default_project_dir/" |
        fzf --exit-0 --prompt="Project: "
}

# Command to open a project in yazi with dev environment activated
yazigo() {
    local selected_project
    selected_project=$(select_project "$@") || return $?
    local project_dir="${1:-$ZEK_DEFAULT_PROJECT_DIR}"
    local project_path="$ZEK_DEVEL_HOME/$project_dir/$selected_project"

    cd "$project_path" || return $?

    if [ -f .envrc ]; then
        direnv exec . yazi .
    elif [ -f devenv.nix ]; then
        devenv shell -- yazi .
    elif [ -f flake.nix ]; then
        nix develop --command yazi .
    else
        yazi .
    fi
}

# Execute the appropriate command based on the script name
case $(basename "$0") in
    "yy") yazigo "$@" ;;
    *) echo "Usage: yy [project_dir]" >&2; exit 1 ;;
esac
