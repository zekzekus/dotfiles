# AI agent configuration

The single source of truth for personal AI-agent guidance, reusable skills, and
language-specific conventions, designed for use by Amp and Claude. Tool-specific
activation must expose these source files rather than create copies that drift.

## What goes where

```
agents/
├── AGENTS.md                 always-on preferences and engineering defaults
├── adapters/                 tool-specific imports and path scoping
│   ├── amp/
│   │   ├── AGENTS.md
│   │   └── languages/
│   └── claude/
│       ├── CLAUDE.md
│       └── rules/
├── languages/
│   ├── clojure.md            opt-in Clojure defaults
│   └── python.md             opt-in Python defaults
└── skills/
    ├── using-jujutsu-vcs/
    │   └── SKILL.md          on-demand jj setup + git→jj workflow
    ├── running-in-nix-flake/
    │   └── SKILL.md          on-demand: run commands in the flake dev shell
    ├── editing-clojure-with-parinfer/
    │   └── SKILL.md          on-demand technique for editing Clojure safely
    └── authoring-repo-tasks/
        └── SKILL.md          on-demand: bb.edn tasks + Makefile mirror pattern
```

The split follows one rule:

| Kind | Mechanism | Why |
|---|---|---|
| Ambient constraints ("prefer `jj` when this is a jj repo") | **AGENTS.md context** (always loaded) | The agent must know the rule before choosing tools or starting work. |
| Procedural techniques ("when editing Clojure, indent like this, then verify") | **Skill** (loaded on demand) | A workflow with steps the agent pulls in only when it hits a matching task. |
| Language defaults ("use Ruff for a new Python project") | **`languages/` guidance** (opt-in) | A language-specific preference that should not consume context or constrain unrelated repositories. |

The litmus test: *Is this "always behave this way" (context) or "here's how to do
X when you do X" (skill)?*

## Consumption model

### Always-on guidance

`AGENTS.md` is the canonical global guidance file. Repository-local guidance
adds stack and domain specifics and wins on conflict.

### Per-language conventions

Files under `languages/` contain canonical language defaults. Thin adapters
apply them only when matching files enter context: Amp uses `globs` through its
global `AGENTS.md`, while Claude uses `paths` through user-level rules. These
defaults are not a reason to migrate an established toolchain without an
explicit request.

### Skills

Skills live under `skills/<name>/SKILL.md` and contain procedural workflows that
should be loaded only when their descriptions match the task.

Shell snippets in skills are instructions for the agent's execution environment.
Commands handed to me must still be translated to Nushell-compatible form as
required by `AGENTS.md`.

## Activation

Home Manager creates out-of-store symlinks from this directory to each tool's
user-wide discovery paths:

| Source | Amp | Claude Code |
|---|---|---|
| Global adapter | `~/.config/amp/AGENTS.md` | `~/.claude/CLAUDE.md` |
| Language adapters | `~/.config/amp/languages/<language>.md` | `~/.claude/rules/<language>.md` |
| `skills/<name>/` | `~/.config/agents/skills/<name>/` | `~/.claude/skills/<name>/` |

Adapters contain only imports and tool-specific scope metadata; guidance remains
defined once in `AGENTS.md` and `languages/`. Each skill is linked individually
so tool-specific skills can coexist in either destination. Do not edit the
destination links; edit the files in this directory.

## Exclusions

Repository-specific architecture, API contracts, commands, and house style stay
in the owning repository's `AGENTS.md` or `CLAUDE.md`. Promote a rule here only
when it is a durable personal preference that generalizes across projects.
