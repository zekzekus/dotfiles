---
name: authoring-repo-tasks
description: "Adds or standardizes Babashka-based repo tasks using bb.edn as the implementation source with a thin Makefile command facade. Use when a repository already uses Babashka, when bb.edn and Makefile tasks are duplicated or diverging, or when the user explicitly requests Babashka tasks."
---

# Authoring repo-local tasks

In a Babashka-based repository, task implementation (build, test, lint, run,
format, release) lives in **one source of truth — `bb.edn`** — with a **thin
`Makefile` command facade**. Logic goes in the bb task; the Makefile target is a
one-line shim that calls it. Never duplicate real logic across the two.

## When this applies

- Adding a task runner to a repo that has none, after Babashka has been selected
  by local guidance or explicitly requested.
- The user explicitly asks to adopt Babashka tasks in a repo that currently has
  only a `Makefile`.
- Task definitions are duplicated between `bb.edn` and `Makefile` and have drifted.

Do not introduce Babashka merely because a repository has a `Makefile`. Follow
the repository's existing command architecture unless the user requests a
change.

## First: detect what exists

```sh
ls bb.edn Makefile deps.edn flake.nix
```

- `bb.edn` present → add/adjust tasks there; keep the Makefile a pure mirror.
- Only `Makefile` → preserve it unless the user explicitly requested Babashka;
  if requested, move each recipe's logic into a `bb.edn` task and reduce the
  Makefile target to `bb <task>`.
- Neither → create both only when Babashka is the chosen local task runner.

## The pattern

### `bb.edn` — the source of truth

Every task carries a `:doc`. Use `babashka.tasks/shell` for shell commands and
`clojure` for `clj -T`/`-M`/`-X` invocations. Guard for `run` and `uberjar` with
`:override-builtin true` (they shadow bb builtins). Set `:dir` when a task runs
in a subdirectory.

```clojure
{:tasks {:requires ([babashka.fs :as fs]
                    [babashka.tasks :refer [shell]])

         run     {:doc  "starts the app"
                  :override-builtin true
                  :task (clojure {:dir "."} "-M:dev")}

         test    {:doc  "runs tests"
                  :task (clojure {:dir "."} "-M:test")}

         lint    {:doc  "lints src and test"
                  :task (shell "clj-kondo --lint src test")}

         uberjar {:doc  "builds the uberjar"
                  :override-builtin true
                  :task (clojure {:dir "."} "-T:build all")}

         format  {:doc  "formats codebase"
                  :task (shell {:dir "src"} "cljstyle fix")}

         clean   {:doc  "removes build output"
                  :task (fs/delete-tree "target")}}}
```

List available tasks with their docs:

```sh
bb tasks
```

### `Makefile` — the mirror

Each target is a one-line `bb <task>` shim. The bb task name and the make target
match.

```make
.PHONY: clean run test lint uberjar format

clean:
	bb clean

run:
	bb run

test:
	bb test

lint:
	bb lint

uberjar:
	bb uberjar

format:
	bb format
```

## Conventions

- **One source of truth.** Real logic lives in the bb task; the Makefile target
  is a one-line `bb <task>` shim. If you change a task, you change `bb.edn`.
- **Names match** between the bb task and the Makefile target.
- **Every bb task has a `:doc`** so `bb tasks` is self-documenting.
- **`:override-builtin true`** on tasks that shadow bb builtins such as `run`
  and `uberjar`.
- **`:dir`** for tasks that run in a subdirectory (e.g. `test/e2e`, `src`).
- Prefer task dependencies, `babashka.tasks/run`, or Clojure/Babashka functions
  for multi-step logic. Reuse a maintained project script only when scripts are
  already an established architectural boundary or the logic independently
  warrants a maintained module; do not create one-off scripts to escape task
  composition.
- Don't add Makefile-only targets that carry task logic — promote them to bb
  tasks first.

## Verify

```sh
bb tasks            # all tasks listed with docs
bb test             # the bb path works
make test           # the mirror reaches the same task
```

If local guidance or inspection establishes that a flake dev shell owns the
environment, run these inside it (load the `running-in-nix-flake` skill) so
`bb`, `clojure`, and `clj-kondo` come from the pinned environment.
