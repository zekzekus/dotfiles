# Python conventions

Defaults for new Python projects under my control. Preserve an established
repository's supported toolchain and compatibility range unless I explicitly
request a migration.

## Project and dependency management

- Use `uv` for project creation, dependency management, locking, and command
  execution (`uv init`, `uv add`, `uv run`). Do not introduce pip workflows,
  Poetry, or `requirements.txt` alongside it.
- Keep project metadata and tool configuration in `pyproject.toml`.
- Use a `src/` layout and `[project.scripts]` entry points for installable
  applications and libraries.
- Use the latest stable Python compatible with the project's consumers and
  deployment environment; use modern syntax for that supported version range.

## Quality and design

- Use Ruff for formatting and linting; do not add Black, Flake8, or isort for
  overlapping responsibilities.
- Use pytest for tests.
- Use typed models such as Pydantic at untrusted, schema-heavy boundaries when
  runtime validation is needed. Prefer plain typed dataclasses for internal
  data that does not require validation.
