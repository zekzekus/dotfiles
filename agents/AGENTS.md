# Global Agent Guidelines

Personal, project-agnostic working rules for AI coding agents. Project-level
`AGENTS.md` / `CLAUDE.md` files add stack specifics and win on any conflict.
In shared repositories, do not force personal tooling choices on teammates.

## Before changing code

- Treat the repository, current behavior, and observable evidence as the source
  of truth. Read relevant local guidance, code, tests, and documentation first.
- Preserve user and concurrent-agent work. Never revert or overwrite unrelated
  changes.
- State uncertainty and missing evidence explicitly; never present assumptions
  as verified conclusions.

## Version control

- Use the repository's native VCS. In an ordinary repository with `.jj/`, use
  Jujutsu (`jj`) for routine VCS work. Use Git only for required
  interoperability, an explicit request, or local policy.
- Use `vex` only in a checkout known to be Vex-backed (for example, one created
  by `vex clone`, `vex init`, or `vex convert`) or when explicitly requested by
  me or repository-local guidance. An installed `vex` executable or globally
  available Vex skill is not evidence that a repository is Vex-backed.
- Do not create branches or bookmarks unless I ask.
- Commit only when I ask. Keep an explicitly requested commit atomic and
  single-concern; inspect the status and diff before recording it.
- Never add AI attribution, agent signatures, or generated-by trailers to
  commits, pull requests, or tags.
- Never push or deploy; I do those myself.
- Ask before destructive or history-rewriting VCS operations. If concurrent
  work exists, finish only your task, do not commit, and never revert others.

## Environment & tooling

- New projects under my control get committed `flake.nix` and `flake.lock`
  files with a complete development and verification environment. Existing
  repositories retain their supported environment unless I request a migration.
- New projects under my control expose common commands through a `Makefile`.
  Existing repositories retain their established command facade.

## Shell — Nushell

- Commands handed to me must be Nushell-compatible. Commands run internally by
  an agent's Bash-capable tool may use Bash.

## Working principles

- Prefer simple, direct implementations and established local patterns.
- Build the smallest complete vertical slice that solves the requested problem.
- Do not add abstractions, wrappers, options, dependencies, or extension points
  without a current need. Promote shared code only after demonstrated reuse.
- When replacing an implementation, remove the obsolete path in the same change.
- Handle errors explicitly; do not introduce silent fallback behavior or
  surprise defaults.
- Keep fake or placeholder data out of application code unless demo fixtures
  are an explicit product feature.
- Use ordinary code for deterministic work; do not spend model calls on tasks
  code performs reliably.
- Validate untrusted input at boundaries and keep core logic directly testable.
- Leave no temporary files, generated clutter, or stray artifacts.

## Scope discipline

- Make only requested or clearly necessary changes; do not refactor adjacent
  working code unprompted.
- Stop when the requested task is complete. Report deferred findings rather
  than implementing them.
- When a decision belongs to me, present short numbered or lettered options
  with trade-offs and wait.

## Verification & testing

- Run the narrowest relevant automated checks that establish confidence;
  broaden them for shared contracts, migrations, or cross-module changes.
- Never weaken checks or suppress failures merely to obtain a pass. Report what
  ran, what failed, and what could not be verified.
- Add proportionate tests for meaningful behavior and important failure paths.
  Default tests must not require credentials or network access.
- I run paid, production, and deployment operations myself. Agents may run safe
  local applications and checks when useful.
- Missing evidence is a valid result; do not invent a diagnosis or fix.

## Safety & data

- Never overwrite `.env` files without asking. Reflect new configuration in the
  project's documented example or schema.
- Never expose or commit secrets. Use the repository's supported secret
  mechanism and scoped, least-privilege credentials.
- Respect intended capability boundaries even when credentials permit more.
- Ask before destructive, hard-to-reverse, credential-affecting, or shared
  infrastructure actions.

## Documentation

- Keep documentation synchronized with materially changed behavior,
  architecture, workflows, and commands.
- Describe the current intended system, not implementation history. Remove
  obsolete guidance and stale references.
- Document public contracts and non-obvious intent, not line-by-line mechanics.
- Avoid duplicated agent guidance: use identical files or a symlink when
  `AGENTS.md` and `CLAUDE.md` serve the same purpose; preserve an explicitly
  documented canonical-file-plus-supplement structure.

## Communication

- Be concise, structured, and honest; avoid filler and invented ratings.
- Write synthesized output in English, even when my input is Turkish.
- Answer status questions from live repository state, not memory. Include a
  handoff only when I must run something or provide information.
