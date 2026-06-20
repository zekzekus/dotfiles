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

Three orthogonal layering axes:

1. **OS family** — `platforms/{darwin,linux}`, auto-selected by `system` arch.
2. **Role** — `profiles/*`, opt-in per host via `profiles = [ ... ]` (e.g. `graphical`, `wayland`).
3. **Management target** — the builder (`mkNixosSystem`/`mkDarwinSystem`/`mkHomeConfiguration`) plus `mkHomeConfiguration`'s `target` arg (`nixos` | `generic-linux` | `standalone`), which drives non-NixOS integration.

The **base layer** (`home.nix` + `modules/*` + `platforms/linux`) is **headless-safe**: no GUI apps or desktop services — all GUI lives in profiles. This is what lets a host be any Linux box: NixOS or foreign distro, desktop or headless server.

```
flake.nix               # Entry point: inputs, outputs, host wiring, profileRegistry
nix/
├── lib.nix             # Builders + profile folding + common (mkNixosSystem, mkDarwinSystem, mkHomeConfiguration)
├── checks.nix          # CI checks (formatting, deadnix, statix) and formatter
├── home.nix            # Shared, headless-safe base imported by ALL hosts
├── hosts/              # Per-machine config only
│   ├── mac-machine/    #   default.nix (HM overrides) + configuration.nix (nix-darwin system)
│   └── nixos/          #   default.nix (HM overrides) + configuration.nix (NixOS system) + hardware-configuration.nix
├── modules/            # Cross-platform, headless-safe HM modules (auto-imported for all hosts)
│   ├── programs/       #   CLI program configs: neovim, git, fish, nushell, tmux, starship, fzf, etc.
│   ├── packages/       #   Shared CLI packages: dev tools, terminal utilities, LLM tools
│   ├── file/           #   Symlinks: ctags, tmuxinator, utility scripts
│   ├── sessionpath/    #   PATH entries
│   └── sessionvariables/  # Environment variables
├── profiles/           # Opt-in role bundles, selected via `profiles = [ ... ]`
│   ├── graphical/      #   GUI apps: ghostty, obsidian (cross-platform); linux/ gated via common.isLinux
│   └── wayland/        #   Hyprland/Niri/Noctalia session (HM side) + stylix, rofi, hyprlock, services
├── platforms/          # OS-family abstractions
│   ├── darwin/         #   macOS: Karabiner, Hammerspoon, Homebrew PATH
│   │   └── modules/    #   opt-in: Aerospace, JankyBorders
│   └── linux/          #   headless-safe stub (home for Linux-universal user config)
└── docs/               # Setup guides
```

External configs (`nvim/`, `ghostty/`, `tmux/`, `git/`, `scripts/`, `ctags/`, `tmuxinator/`) live at the repo root and are **symlinked into place via Home Manager** (`modules/file/`). Edit these files directly; HM activation creates the symlinks.

### How lib.nix Assembles a Host

`lib.nix` builder functions automatically compose the Home Manager module list as:
1. `home.nix` (shared, headless-safe base)
2. `platforms/darwin` or `platforms/linux` (auto-selected by system)
3. profile modules from `profiles = [ ... ]` (resolved via the `profileRegistry` in `flake.nix`)
4. `hosts/<hostname>/default.nix` (host-specific HM overrides)

Profiles can also bundle external HM modules, `homeSpecialArgs`, `systemModules`, and `systemSpecialArgs`. Conditional `imports` must branch on a specialArg (e.g. `common.isLinux`), never on `pkgs`/`config` (infinite recursion). The `common` attrset (username, homeDir, dotfilesDir, project paths, `isLinux`/`isDarwin`) is passed as `specialArgs` to all HM and system modules.

### Supported Hosts

| Host | Platform | Management | Profiles |
|------|----------|------------|----------|
| `mac-machine` | aarch64-darwin | nix-darwin + Home Manager | `graphical` |
| `nixos` | x86_64-linux | NixOS + Home Manager | `graphical`, `wayland` |

## Adding a New Host

1. Create `nix/hosts/<hostname>/default.nix` (HM overrides; may be an empty `_: {}` stub).
2. For NixOS/darwin only: create `nix/hosts/<hostname>/configuration.nix` (system config).
3. Pick `profiles` for the role and add to the appropriate output in `flake.nix`:
   ```nix
   # NixOS desktop / headless server (omit profiles for headless):
   nixosConfigurations."myhost" = mkNixosSystem { hostname = "myhost"; profiles = ["graphical" "wayland"]; };
   darwinConfigurations."myhost" = mkDarwinSystem { hostname = "myhost"; profiles = ["graphical"]; };

   # Any Linux box via standalone HM (target auto-detects to generic-linux on Linux):
   homeConfigurations."zekus@ubuntu" = mkHomeConfiguration { hostname = "ubuntu"; system = "x86_64-linux"; profiles = ["graphical"]; };  # foreign desktop
   homeConfigurations."zekus@vps"    = mkHomeConfiguration { hostname = "vps";    system = "x86_64-linux"; };                          # foreign headless
   homeConfigurations."zekus@nixbox" = mkHomeConfiguration { hostname = "nixbox"; system = "x86_64-linux"; target = "nixos"; };       # standalone HM on NixOS
   ```

## Code Style

- **Nix**: Use `inherit` when possible, group imports at the top, prefer modules over inline config
- **Lua** (nvim/): Follow existing patterns, use `require()` for imports
- Cross-platform, headless-safe shared → `nix/modules/`
- GUI / role-specific → `nix/profiles/<profile>/` (e.g. `graphical`, `wayland`)
- Platform-wide (OS-family) opt-in → `nix/platforms/<platform>/modules/`
- Host-specific → `nix/hosts/<host>/{default,configuration}.nix`

## Principles

- Keep setup modern, safe, performant, idiomatic, easy to reason about and extend
- Do not check or modify the home-manager activation state unless explicitly asked
