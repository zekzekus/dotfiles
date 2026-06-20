# Dotfiles

> Declarative, reproducible, multi-platform development environment powered by **Nix Flakes**, **Home Manager**, and **nix-darwin**.

One config to rule them all -- macOS, Linux, and NixOS.

---

## Highlights

- **Declarative** -- Entire environment defined in code, version controlled, reproducible
- **Any Linux box** -- Headless-safe base + opt-in `profiles` work on NixOS *and* foreign distros (Ubuntu, etc.), desktop or headless server
- **Multi-platform** -- Single flake manages macOS (via nix-darwin), Linux, and NixOS
- **Multi-host** -- Per-machine config with shared modules, platform abstractions, and composable role profiles
- **Stylix** -- Consistent theming across applications (Kanagawa scheme, via the `wayland` profile)
- **Make-driven** -- Simple commands that auto-detect your host

---

## Structure

```
.
├── flake.nix                  # Main flake entry point (inputs, outputs, host wiring, profileRegistry)
├── flake.lock                 # Flake lock file
├── nix/                       # Nix & Home Manager configs
│   ├── lib.nix                # Host builders + profile folding + common (user info, paths, env)
│   ├── checks.nix             # CI checks (formatting, deadnix, statix) and formatter
│   ├── home.nix               # Shared, headless-safe base (imports all shared modules)
│   ├── hosts/                 # Per-machine config only
│   │   ├── mac-machine/       #   macOS (aarch64-darwin) + nix-darwin
│   │   └── nixos/             #   NixOS (x86_64-linux) full system + host overrides
│   ├── modules/               # Cross-platform, headless-safe HM modules (auto-imported)
│   │   ├── file/              #   File symlinks (ctags, tmuxinator, scripts)
│   │   ├── packages/          #   Shared CLI packages
│   │   ├── programs/          #   Program configurations
│   │   ├── sessionpath/       #   PATH management
│   │   └── sessionvariables/  #   Environment variables
│   ├── profiles/              # Opt-in role bundles, selected via `profiles = [ ... ]`
│   │   ├── graphical/         #   GUI apps (cross-platform + linux/ gated via common.isLinux)
│   │   └── wayland/           #   Hyprland/Niri/Noctalia session (HM side) + stylix
│   ├── platforms/             # OS-family abstractions
│   │   ├── darwin/            #   macOS: Karabiner, Hammerspoon
│   │   │   └── modules/       #   opt-in: Aerospace, JankyBorders
│   │   └── linux/             #   headless-safe stub (Linux-universal user config)
│   └── docs/                  # Setup guides
│       └── 1password-setup.md #   1Password SSH & GPG setup
│
├── nvim/                      # Neovim configuration (Lua, symlinked via HM)
├── ghostty/                   # Ghostty terminal config (symlinked via HM)
├── tmux/                      # tmux configurations & themes (symlinked via HM)
├── tmuxinator/                # tmuxinator project templates (symlinked via HM)
├── git/                       # Git config templates & global ignore (symlinked via HM)
├── niri/                      # Niri compositor config (symlinked via HM)
├── noctalia/                  # Noctalia shell config (symlinked via HM)
├── scripts/                   # Utility scripts (tmux project launchers, theme switchers)
├── ctags/                     # Universal Ctags config (symlinked via HM)
├── macosx/                    # macOS-specific configs (Karabiner, Hammerspoon)
├── misc/                      # Legacy configs (archived)
│
├── Makefile                   # Convenience commands
└── AGENTS.md                  # AI agent instructions
```

---

## Supported Hosts

| Host | Platform | Architecture | Management | Profiles |
|------|----------|--------------|------------|----------|
| `mac-machine` | macOS | aarch64-darwin | nix-darwin + Home Manager | `graphical` |
| `nixos` | NixOS | x86_64-linux | NixOS + Home Manager | `graphical`, `wayland` |

Any other Linux box -- a foreign distro desktop, or a headless VPS -- can be added as a standalone Home Manager target (`mkHomeConfiguration`); the base is headless-safe and graphical bits are opt-in via profiles. See [Adding a New Host](./nix/README.md#adding-a-new-host).

---

## Quick Start

```bash
# Clone
git clone https://github.com/zekzekus/dotfiles ~/devel/tools/dotfiles
cd ~/devel/tools/dotfiles

# Apply (auto-detects host)
make darwin    # macOS (nix-darwin + Home Manager)
make nixos     # NixOS full system rebuild
make home      # Standalone Home Manager only (NixOS or any foreign Linux distro)
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

Every host is built from one **headless-safe base** and then specialised along
**three orthogonal axes** -- OS family, role, and management target. The base
(`home.nix` + `modules/*` + `platforms/linux`) ships no GUI apps or desktop
services, so it runs on a headless server just as happily as a laptop; anything
graphical is opt-in via a profile.

```
                  ┌────────────────────────────────────────────┐
                  │              flake.nix                     │
                  │ inputs - profileRegistry - host wiring     │
                  └────────────────────────────────────────────┘
                                         │
                ┌────────────────────────────────────────────────┐
                │            lib.nix builders                    │
                │ mkNixosSystem / mkDarwinSystem /               │
                │ mkHomeConfiguration                            │
                │ pick management target:                        │
                │ nixos | generic-linux | standalone             │
                └────────────────────────────────────────────────┘
                                         │  assemble the HM module stack
                                         ▼
        ┌─────────────────────────────────────────────────────────────────┐
        │ hosts/<host>/             machine-specific overrides            │
        ├─────────────────────────────────────────────────────────────────┤
        │ profiles = [ ... ]        graphical, wayland          (role)    │
        ├─────────────────────────────────────────────────────────────────┤
        │ platforms/{darwin,linux}  auto-selected by system   (OS family) │
        ├─────────────────────────────────────────────────────────────────┤
        │ home.nix + modules/*      shared, HEADLESS-SAFE base            │
        └─────────────────────────────────────────────────────────────────┘
```

**Three orthogonal axes**

1. **OS family** -- `platforms/{darwin,linux}`, auto-selected from `system`.
2. **Role** -- `profiles/*`, opt-in per host via `profiles = [ ... ]` (e.g. `graphical`, `wayland`), resolved from the `profileRegistry` in `flake.nix`. A profile may bundle HM modules, system modules, and extra `specialArgs`.
3. **Management target** -- the builder (`mkNixosSystem` / `mkDarwinSystem` / `mkHomeConfiguration`) plus `mkHomeConfiguration`'s `target` (`nixos` | `generic-linux` | `standalone`), which drives non-NixOS integration. On a foreign distro it auto-selects `generic-linux` and enables `targets.genericLinux`.

**How `lib.nix` assembles a host** *(module order)*

1. `home.nix` -- shared, headless-safe base (imports every shared `modules/*`)
2. `platforms/darwin` or `platforms/linux` -- auto-selected by `system`
3. profile modules from `profiles = [ ... ]` -- resolved via the `profileRegistry`
4. `hosts/<hostname>/default.nix` -- host-specific Home Manager overrides

The centralized `common` attrset (user info, paths, env vars, `isLinux`/`isDarwin`) is passed as `specialArgs` to every Home Manager and system module. External configs (Neovim, tmux, Ghostty, Niri, Noctalia, ...) live at the repo root and are symlinked into place via Home Manager (`modules/file/`).

---

## What's Included

**Base** *(all hosts -- headless-safe)*
- Neovim (nixpkgs unstable) with Treesitter grammars, LSPs for Lua, Nix, Go, Rust, Python, TypeScript, Ruby, Clojure, Haskell
- Fish & Nushell with Starship prompt, Carapace completions
- tmux with tmuxinator
- Git with delta, difftastic, lazygit, jujutsu (jj), lazyjj, jjui
- direnv, atuin (shell history), zoxide, yazi
- fzf, ripgrep, fd, bat, btop, fastfetch
- GPG signing, SSH via 1Password agent
- devenv, Ollama (CPU)

**`graphical` profile** *(opt-in -- any host with a display)*
- Ghostty terminal, Obsidian (cross-platform)
- Linux adds: Firefox, Chromium, Zed, Emacs (pgtk), OBS Studio (PipeWire capture), Radicle, media viewers, helium, 1Password GUI autostart

**`wayland` profile** *(opt-in -- Wayland desktop, normally paired with `graphical`)*
- Hyprland and Niri compositors with Noctalia shell, hypridle, hyprlock
- Stylix system-wide theming (Kanagawa, dark polarity)
- rofi launcher, Hyprland polkit agent
- Tray/session services: clipboard history (cliphist), automount (udiskie), network + Tailscale applets

**`darwin` platform** *(macOS via nix-darwin)*
- Aerospace tiling window manager (opt-in)
- JankyBorders for window highlights (opt-in, currently disabled)
- Karabiner-Elements key remapping
- Hammerspoon automation
- Homebrew integration via nix-homebrew (Raycast, Zed, 1Password)
- Touch ID for sudo

**`nixos` host** *(system level)*
- PipeWire audio, Bluetooth, greetd + tuigreet login, COSMIC desktop available
- Kanata key remapping (caps-lock as ctrl/esc)
- Steam + Gamescope gaming, gpu-screen-recorder, v4l2loopback virtual camera
- Flatpak (GeForce NOW), Podman (Docker-compatible)
- Tailscale VPN, OpenSSH (reachable via Tailscale only)
- 1Password (NixOS module + GUI polkit), xdg portals (Hyprland/GTK/GNOME/COSMIC)

---

## Flake Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs` | Main package set (nixos-unstable) |
| `home-manager` | User environment management |
| `nix-darwin` | macOS system management |
| `nix-homebrew` | Declarative Homebrew on macOS |
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
