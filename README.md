# Dotfiles

> Declarative, reproducible, multi-platform development environment powered by **Nix Flakes**, **Home Manager**, and **nix-darwin**.

One config to rule them all -- macOS, Linux, and NixOS.

---

## Highlights

- **Declarative** -- Entire environment defined in code, version controlled, reproducible
- **Multi-platform** -- Single flake manages macOS (via nix-darwin), Linux, and NixOS
- **Multi-host** -- Per-machine configurations with shared modules and platform abstractions
- **Stylix** -- Consistent theming across applications (Kanagawa scheme on NixOS)
- **Neovim Nightly** -- Always on the bleeding edge via nix-community overlay
- **Make-driven** -- Simple commands that auto-detect your host

---

## Structure

```
.
├── flake.nix                  # Main flake entry point
├── flake.lock                 # Flake lock file
├── nix/                       # Nix & Home Manager configs
│   ├── lib.nix                # Host builders (mkNixosSystem, mkDarwinSystem, mkHomeConfiguration)
│   ├── checks.nix             # CI checks (formatting, deadnix, statix) and formatter
│   ├── home.nix               # Shared home configuration (imports all shared modules)
│   ├── hosts/                 # Per-machine configurations
│   │   ├── mac-machine/       #   macOS (aarch64-darwin) + nix-darwin
│   │   └── nixos/             #   NixOS (x86_64-linux) full system + home
│   ├── modules/               # Reusable Home Manager modules
│   │   ├── file/              #   File symlinks (ctags, tmuxinator, scripts)
│   │   ├── packages/          #   Shared packages
│   │   ├── programs/          #   Program configurations (30 modules)
│   │   ├── services/          #   User services (jankyborders)
│   │   ├── sessionpath/       #   PATH management
│   │   └── sessionvariables/  #   Environment variables
│   ├── platforms/             # Platform-specific abstractions
│   │   ├── darwin/            #   macOS: Aerospace, JankyBorders, Karabiner, Hammerspoon
│   │   └── linux/             #   Linux: Firefox, Chromium
│   └── docs/                  # Setup guides
│       └── 1password-setup.md #   1Password SSH & GPG setup
│
├── nvim/                      # Neovim configuration (Lua, symlinked via HM)
├── ghostty/                   # Ghostty terminal config (symlinked via HM)
├── tmux/                      # tmux configurations & themes (symlinked via HM)
├── tmuxinator/                # tmuxinator project templates (symlinked via HM)
├── git/                       # Git config templates & global ignore (symlinked via HM)
├── scripts/                   # Utility scripts (tmux project launchers, theme switchers)
├── ctags/                     # Universal Ctags config (symlinked via HM)
├── macosx/                    # macOS-specific configs (Karabiner, Hammerspoon)
├── noctalia/                  # Noctalia shell config
├── misc/                      # Legacy configs (archived)
│
├── Makefile                   # Convenience commands
└── AGENTS.md                  # AI agent instructions
```

---

## Supported Hosts

| Host | Platform | Architecture | Management |
|------|----------|--------------|------------|
| `mac-machine` | macOS | aarch64-darwin | nix-darwin + Home Manager |
| `nixos` | NixOS | x86_64-linux | NixOS + Home Manager |

---

## Quick Start

```bash
# Clone
git clone https://github.com/zekzekus/dotfiles ~/devel/tools/dotfiles
cd ~/devel/tools/dotfiles

# Apply (auto-detects host)
make darwin    # macOS (nix-darwin + Home Manager)
make nixos     # NixOS full system rebuild
make home      # Standalone Home Manager only
```

See [nix/README.md](./nix/README.md) for detailed installation instructions.

---

## Commands

```bash
make help          # Show all commands with detected host
make home          # Switch Home Manager only (faster iteration)
make home-build    # Build Home Manager only (dry-run)
make darwin        # Rebuild nix-darwin system (macOS only)
make darwin-build  # Build nix-darwin without switching
make nixos         # Rebuild NixOS system (NixOS only)
make nixos-build   # Build NixOS without switching
make update        # Update flake inputs
make check         # Run all checks (format, deadnix, statix)
make fmt           # Format all Nix files with alejandra
make clean         # Clean build artifacts
```

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         flake.nix                               │
│                    (single source of truth)                     │
└───────────────────────────┬─────────────────────────────────────┘
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
        ┌───────────┐               ┌───────────┐
        │  darwin   │               │   linux   │
        │ platform  │               │ platform  │
        └─────┬─────┘               └─────┬─────┘
              │                           │
              ▼                           ▼
        ┌───────────┐               ┌───────────┐
        │mac-machine│               │   nixos   │
        │(nix-darwin)│              │ (NixOS)   │
        └───────────┘               └───────────┘

              ┌───────────┐       ┌─────────────┐
              │  modules  │       │  home.nix   │
              │ (shared)  │       │  (shared)   │
              └───────────┘       └─────────────┘
```

**Layered configuration:**
1. **Flake** -- Defines inputs, outputs, and wires everything together
2. **lib.nix** -- Host builder functions (`mkNixosSystem`, `mkDarwinSystem`, `mkHomeConfiguration`)
3. **Platforms** -- Darwin vs Linux specifics (auto-selected by `lib.nix` based on system)
4. **Hosts** -- Machine-specific overrides and system config
5. **Modules** -- Shared, reusable building blocks (programs, packages, services, etc.)
6. **External configs** -- Neovim, tmux, Ghostty, etc. symlinked via Home Manager

---

## What's Included

**Shared** *(all platforms)*
- Neovim (nightly) with Treesitter grammars, LSPs for Lua, Nix, Go, Rust, Python, TypeScript, Ruby, Clojure, Haskell
- Ghostty terminal
- Fish & Nushell with Starship prompt, Carapace completions
- tmux with tmuxinator
- Git with delta, difftastic, lazygit, jujutsu (jj), lazyjj, jjui
- direnv, atuin (shell history), zoxide, yazi
- fzf, ripgrep, fd, bat, btop, fastfetch
- GPG signing, SSH via 1Password agent
- devenv, Ollama (CPU)

**Darwin** *(macOS via nix-darwin)*
- Aerospace tiling window manager
- JankyBorders for window highlights (currently disabled)
- Karabiner-Elements key remapping
- Hammerspoon automation
- Homebrew integration via nix-homebrew (Raycast, Zed, 1Password)
- Touch ID for sudo

**NixOS**
- Hyprland and Niri compositors with Noctalia shell, hypridle, hyprlock
- Stylix system-wide theming (Kanagawa, dark polarity)
- Pipewire audio, Bluetooth, SDDM display manager
- Kanata key remapping (caps-lock as ctrl/esc)
- Steam + Gamescope gaming
- Flatpak (GeForce NOW)
- OBS Studio with PipeWire capture
- Tailscale VPN
- 1Password via NixOS modules

---

## Flake Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs` | Main package set (nixos-unstable) |
| `home-manager` | User environment management |
| `nix-darwin` | macOS system management |
| `nix-homebrew` | Declarative Homebrew on macOS |
| `neovim-nightly-overlay` | Bleeding-edge Neovim |
| `hyprland` | Wayland compositor |
| `hyprland-plugins` | Hyprland extensions |
| `noctalia` | Desktop shell for Hyprland |
| `stylix` | System-wide theming |
| `nix-flatpak` | Declarative Flatpak management |
| `determinate` | Determinate Nix integration |

---

## Documentation

- [Home Manager README](./nix/README.md) -- Installation, adding hosts, troubleshooting
- [1Password Setup](./nix/docs/1password-setup.md) -- SSH agent & GPG key management

---

## License

MIT
