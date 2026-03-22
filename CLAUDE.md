# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Shell Environment

The user runs **Nushell** as the default shell. When executing commands:
- Avoid shell-specific syntax like `&&`, `;`, or `&` for chaining/backgrounding
- Avoid output redirections like `2>&1` or `> /dev/null` (use nushell: `out>`, `err>`, `out+err>`)
- Run commands separately instead of chaining
- For complex shell commands, wrap with `bash -c "..."` to use bash syntax directly

## Commands

```bash
make check         # Run all checks: alejandra formatting, deadnix, statix linting
make fmt           # Format all Nix files with alejandra
make home          # Switch Home Manager config (auto-detects user@host)
make home-build    # Dry-run build of Home Manager config
make darwin        # Rebuild nix-darwin system (macOS only)
make darwin-build  # Build nix-darwin without switching
make nixos         # Rebuild NixOS system (NixOS only)
make nixos-build   # Build NixOS without switching
make update        # Update all flake inputs (nix flake update)
make clean         # Remove ./result build artifacts
```

`make check` runs `nix flake check --impure` and is the equivalent of CI validation. Always run before proposing config changes are complete.

## Architecture

```
flake.nix               # Entry point: inputs, outputs, host wiring
nix/
├── lib.nix             # Builder functions: mkNixosSystem, mkDarwinSystem, mkHomeConfiguration
├── checks.nix          # CI checks (formatting, deadnix, statix) and formatter
├── home.nix            # Shared HM config imported by ALL hosts (imports all shared modules)
├── hosts/              # Per-machine overrides
│   ├── mac-machine/    #   default.nix (HM) + configuration.nix (nix-darwin system)
│   └── nixos/          #   default.nix (HM) + configuration.nix (NixOS system) + hardware-configuration.nix
│       └── modules/    #   Host-specific opt-in: Hyprland, Niri, Rofi, Hyprlock, Noctalia, Wayland
├── modules/            # Cross-platform Home Manager modules (auto-imported for all hosts)
│   ├── programs/       #   ~22 program configs: neovim, git, fish, nushell, tmux, ghostty, starship, fzf, etc.
│   ├── packages/       #   Shared packages: dev tools, terminal utilities, LLM tools
│   ├── file/           #   Symlinks: ctags, tmuxinator, utility scripts
│   ├── sessionpath/    #   PATH entries
│   └── sessionvariables/  # Environment variables
├── platforms/          # Platform-specific Home Manager config
│   ├── darwin/         #   macOS: Karabiner, Hammerspoon, Homebrew PATH
│   │   └── modules/    #   Platform-wide opt-in: Aerospace, JankyBorders
│   └── linux/          #   Linux: Chromium
│       └── modules/    #   Platform-wide opt-in: Firefox, Zed Editor
└── docs/               # Setup guides
```

External configs (`nvim/`, `ghostty/`, `tmux/`, `git/`, `scripts/`, `ctags/`, `tmuxinator/`) live at the repo root and are **symlinked into place via Home Manager** (`modules/file/`). Edit these files directly; HM activation creates the symlinks.

### How lib.nix Assembles a Host

`lib.nix` builder functions automatically compose the Home Manager module list as:
1. `home.nix` (shared base)
2. `platforms/darwin` or `platforms/linux` (auto-selected by system)
3. `hosts/<hostname>/default.nix` (host-specific HM overrides)

The `common` attrset (username, homeDir, dotfilesDir, project paths) is passed as `specialArgs` to all HM and system modules.

### Supported Hosts

| Host | Platform | Management |
|------|----------|------------|
| `mac-machine` | aarch64-darwin | nix-darwin + Home Manager |
| `nixos` | x86_64-linux | NixOS + Home Manager |

## Adding a New Host

1. Create `nix/hosts/<hostname>/default.nix` (HM config)
2. Create `nix/hosts/<hostname>/configuration.nix` (system config)
3. Add to the appropriate output in `flake.nix`:
   ```nix
   nixosConfigurations."myhost" = mkNixosSystem { hostname = "myhost"; };
   darwinConfigurations."myhost" = mkDarwinSystem { hostname = "myhost"; };
   # standalone HM only:
   homeConfigurations."zekus@myhost" = mkHomeConfiguration { hostname = "myhost"; system = "x86_64-linux"; };
   ```

## Code Style

- **Nix**: Use `inherit` when possible, group imports at the top, prefer modules over inline config
- **Lua** (nvim/): Follow existing patterns, use `require()` for imports
- Cross-platform shared → `nix/modules/`
- Platform-wide opt-in → `nix/platforms/<platform>/modules/`
- Host-specific opt-in → `nix/hosts/<host>/modules/`

## Principles

- Keep setup modern, safe, performant, idiomatic, easy to reason about and extend
- Do not check or modify the home-manager activation state unless explicitly asked
