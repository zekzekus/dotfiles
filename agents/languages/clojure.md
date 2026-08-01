# Clojure conventions

Defaults for new Clojure projects under my control. Preserve an established
repository's conventions and toolchain unless I explicitly request a migration.

## Indentation is structural (Parinfer)

When a repository is edited with **Parinfer**, indentation controls parenthesis
structure. Wrong indentation is a structural bug, not a style nit.

> A repeatable workflow for this lives in the `editing-clojure-with-parinfer`
> skill. Load it only when Parinfer is known to be active and the edit changes
> indentation-sensitive structure.

## Code style

- Prefer idiomatic, functional Clojure and follow the repository's namespace
  ordering and formatter.
- Prefer namespaced keywords for domain data (`:note/title`, `:user/email`, …).
- Use `clojure.test` (`deftest` / `is`) unless the repository establishes a
  different test framework. Choose the narrowest suitable test double; use
  fixtures only when shared lifecycle setup is genuinely needed.
- Use the repository's established logging abstraction; for a new project,
  prefer `clojure.tools.logging` as the API boundary.
- Do not leave trailing whitespace.

## Linting

- Use `clj-kondo` and expose it through the repository's command facade. Let the
  local command graph decide whether tests depend on lint.
- For an isolated false positive, prefer the narrowest linter-specific inline
  suppression and explain what the linter cannot infer. For systematic macro or
  namespace behavior, use documented project configuration such as hooks or
  `:lint-as` rather than scattering suppressions.

## Formatting

- Prefer `cljstyle` for new projects and run formatting through the repository's
  documented command facade.
