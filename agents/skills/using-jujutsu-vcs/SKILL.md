---
name: using-jujutsu-vcs
description: "Performs version control with Jujutsu (jj), including the git-to-jj command map and anonymous-change workflow. Use for VCS operations in an ordinary repository with .jj, or when the user explicitly asks to initialize or adopt Jujutsu; do not substitute Vex unless the checkout is known to be Vex-backed."
---

# Using Jujutsu (jj) for version control

When a repository has `.jj/`, use **Jujutsu (`jj`)**, not raw `git`, for routine
VCS work. A repo may have a colocated `.git/` directory, but operations go
through `jj` except where Git interoperability is required or explicitly
requested.

Do not substitute the `vex` executable merely because it is installed or a Vex
skill is globally available. Use Vex only when the checkout is known to be
Vex-backed or the user or repository-local guidance explicitly requests it.

## First: make sure the repo is a jj repo

Before any VCS operation, confirm jj is initialized:

```sh
jj root        # prints the workspace root if this is a jj repo; errors if not
```

- **Already a jj repo** → just use `jj`.
- **A git repo but not yet jj** → follow its local VCS workflow. Only when the
  user explicitly asks to adopt Jujutsu, colocate jj on top of git (keeping
  `.git/` so git tooling still works):

  ```sh
  jj git init --colocate
  ```

- **No repo at all** → use `jj git init` when Jujutsu is the requested VCS.
- **Cloning** → use `jj git clone <url>` when the user wants a jj workspace.

Do not alter a repository's VCS setup merely because `jj` is installed.

## The mental model (how jj differs from git)

- **No staging area / index.** The working copy *is* a commit (the `@` change).
  Edits are recorded into `@` automatically — there is no `git add`.
- **Changes have stable change-ids** that survive rewrites, separate from the
  git commit hash.
- **Anonymous changes are normal.** You do not need a named branch to do work.
  Named pointers are *bookmarks* (jj's equivalent of git branches) and are only
  needed to push to a git remote.

## git → jj command map

| Intent | git | jj |
|---|---|---|
| Status | `git status` | `jj st` |
| Diff working copy | `git diff` | `jj diff` |
| History | `git log` | `jj log` |
| Create a new change | `git checkout -b` | `jj new` (only when requested) |
| Set the current change description | — | `jj describe -m "..."` |
| Commit current work and create an empty successor | `git commit -am` | `jj commit -m "..."` |
| Amend last commit | `git commit --amend` | `jj describe` / `jj squash` |
| Split a commit | `git add -p` + commit | `jj split` |
| Move changes into parent | — | `jj squash` |
| Switch to a commit | `git checkout <ref>` | `jj edit <change>` / `jj new <change>` |
| Rebase | `git rebase` | `jj rebase` |
| Fetch | `git fetch` | `jj git fetch` |
| Push (reference only; user-owned) | `git push` | `jj git push` |
| Undo last op | `git reflog` + reset | `jj undo` (see safety below) |

## Workflow conventions

- **Don't create branches/bookmarks by default.** Work in anonymous changes.
  Only create a bookmark when I explicitly ask.
- Edit the existing `@` by default. Do not create, describe, finalize, split, or
  squash changes merely to organize work unless I explicitly ask you to record
  or restructure it.
- When I explicitly request a commit, inspect `jj st` and `jj diff`, run
  `jj commit -m "..."`, then use `jj log` and `jj st` to verify that `@` is a
  fresh empty successor.
- `jj describe` changes only the current change's message; it does not finalize
  the change or leave an empty working-copy successor.
- Never push. If publishing is requested, provide the exact command for me to
  run.

## Safety — ask before destructive operations

Do **not** run these without explicit confirmation from me:

- `git commit`, `git rebase`, `git reset`, or other raw Git mutations in a jj
  repository.
- `jj abandon`, `jj op restore`, any `jj undo`, and any other operation that
  discards or rewrites work.

Never run `git push`, `jj git push`, or a force-push; publishing is user-owned.

When in doubt, show me `jj st` / `jj log` output and ask, rather than mutating.
`jj op log` records every operation if recovery is needed.
