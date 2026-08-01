---
name: editing-clojure-with-parinfer
description: "Edits indentation-sensitive Clojure forms safely when a repository is known to use Parinfer. Use when changing requires, bindings, maps, conditionals, or other structure whose parenthesis layout Parinfer derives from indentation."
---

# Editing Clojure with Parinfer

In a Parinfer-enabled editor, **indentation drives the parenthesis structure** — the
parens follow the indentation, not the other way around. A misaligned line is a
structural change, not a cosmetic one, and will silently reshape the form. Treat
every edit to a `.clj` / `.cljs` / `.cljc` / `.edn` file as alignment-sensitive.

## Core rules

1. **Align siblings to the same column.**
   - Every entry in a `(:require […])` block starts at the same column.
   - Every binding in a `let` / `binding` / `loop` vector starts at the same column.
   - Map entries, `cond` pairs, and `case` clauses likewise line up.

2. **Count, don't eyeball.** Before inserting a line, look at an existing sibling
   line and match its leading-space count exactly. Mismatched indentation by even
   one space re-parents the form under Parinfer.

3. **Match the form's own indentation, not the file's default.** Nested forms
   indent relative to their parent; copy the depth of the neighbour you're
   inserting next to.

## Workflow

When adding a require:

1. Open the `(:require …)` block and note the column the existing namespaces
   start at (count the spaces).
2. Insert the new namespace at that exact column, following the repository's
   established ordering.
3. Re-check the closing of the block — under Parinfer the trailing parens move
   with indentation, so confirm the block still closes where it did.

When adding a `let` binding:

1. Note the column of the existing binding names in the vector.
2. Insert `name  value` aligned to that column.
3. Confirm the body forms below still sit at their original indentation.

## Verify every edit

After any edit, **diff and read the changed lines**:

```sh
jj diff      # or: git diff, if the repo isn't on jj
```

Check that:
- each modified form's indentation matches its siblings, and
- you did not accidentally pull a following form into the edited form (or push
  one out) by changing indentation.

Run the repository's documented formatter, linter, and affected tests before
finishing. For example, only where these commands are established locally:

```sh
bb format    # cljstyle, where available
make lint    # clj-kondo --lint src test, where available
make test    # affected tests, where available
```
