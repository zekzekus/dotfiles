---
name: running-in-nix-flake
description: "Runs project commands inside a Nix flake dev shell from non-persistent agent shells and diagnoses flake environment or tool-resolution failures. Use when local guidance or repository inspection establishes that a flake dev shell owns the development environment."
---

# Running commands in a Nix flake dev shell

When repository guidance, `.envrc`, or flake inspection establishes that a Nix
dev shell owns the development environment, **run project commands inside that
shell**, not against whatever happens to be on the host `PATH`.

## First: detect the environment

```sh
command -v nix        # is Nix available?
ls flake.nix          # is this a flake repo?
cat .envrc            # does it select a flake dev shell via direnv?
nix flake show        # does the flake expose the expected dev shell?
```

- Usable project dev shell established → use the repository's documented entry
  point for project commands.
- No flake, no usable dev shell, or another environment owns the toolchain →
  follow the repository's supported environment; this skill does not apply.
- Activation or evaluation failure → stop and diagnose or report the blocker.
  Do not silently switch to host tools or another activation mechanism.

## The key gotcha: env doesn't persist between tool calls

A non-interactive agent shell runs each command in a fresh process — `cd` and
`export` (or an activated dev shell) **do not carry over** to the next call.
So you cannot "enter the shell once" and then run commands; you must put each
command *inside* the shell invocation.

## Running a command in the dev shell

Use `nix develop -c` (alias for `--command`) to run a single command in the
default dev shell without an interactive prompt:

```sh
nix develop -c <command> [args...]
# e.g.
nix develop -c make test
nix develop -c clj -M:test
nix develop -c bb format
```

For a multi-step command, wrap it in a shell explicitly:

```sh
nix develop -c bash -c 'cmd1 && cmd2'
```

Select a non-default shell with `nix develop .#<name> -c <command>`.

### If the repo uses direnv (`.envrc` with `use flake`)

`direnv exec` runs a command with the directory's environment loaded — often
faster than a cold `nix develop` because direnv caches it:

```sh
direnv exec . <command> [args...]
```

Follow the repository's documented entry point. Prefer `direnv exec .` when its
`.envrc` is the established entry point; otherwise use `nix develop -c`. If the
chosen mechanism fails, diagnose it rather than silently trying a different
environment.

## Verifying a tool comes from the shell

Don't assume a tool is the flake's version. Check inside the shell:

```sh
nix develop -c sh -c 'command -v <tool>'
nix develop -c <tool> --version
```

## Adding a tool to the project

When the flake owns the project toolchain and the project needs a new
tool/library, add it to the flake (not the host) so the dev shell stays complete:

1. Add the package to the relevant dev shell in `flake.nix` (or the relevant
   `inputs` for a new overlay).
2. Run `nix flake check` to validate.
3. Tell me to re-enter `nix develop` — or, if `.envrc` uses `use flake`, that a
   `direnv reload` is needed — so the new tool is on PATH.

## Quick reference

| Task | Command |
|---|---|
| Is it a flake repo? | `ls flake.nix` |
| Run one command in the shell | `nix develop -c <cmd>` |
| Run via direnv cache | `direnv exec . <cmd>` |
| Multi-step in the shell | `nix develop -c bash -c '...'` |
| Confirm tool origin | `nix develop -c sh -c 'command -v <tool>'` |
| Validate flake changes | `nix flake check` |
| Inspect outputs | `nix flake show` |
