# AGENTS.md

## Commands

```bash
make check        # Validate flake
make home         # Apply home-manager config (auto-detects host)
make home-build   # Dry-run build
make nixos        # Rebuild NixOS system (NixOS only)
make update       # Update flake inputs
```

## Architecture

- **home-manager/** — Nix flake entry point (`flake.nix`), shared config (`home.nix`), per-host configs in `hosts/`, reusable modules in `modules/`, platform abstractions in `platforms/`
- **nvim/** — Neovim config (Lua), symlinked via Home Manager
- **ghostty/, tmux/, git/, ctags/, scripts/** — App configs symlinked via Home Manager

## Code Style

- Nix: Use `inherit` when possible, group imports at top, prefer modules over inline config
- Lua (nvim): Follow existing patterns in `lua/`, use `require()` for imports
- Keep host-specific code in `hosts/`, shared code in `modules/`
- Platform-specific settings go in `platforms/darwin/` or `platforms/linux/`

## Principles

- Keep home-manager setup modern, safe, performant, idiomatic, easy to reason about and easy to extend
- Leave checking home manager setup to me if I didn't ask otherwise
