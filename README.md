# Dotfiles

> Declarative, reproducible, multi-platform development environment powered by **Nix Flakes**, **Home Manager**, and **nix-darwin**.

One config to rule them all -- macOS, Linux, and NixOS.

---

## Highlights

- **Declarative** -- Packages and configuration defined in code; credentials, accounts, and personal data restored separately
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
│   ├── modules/               # Cross-platform, headless-safe HM modules (explicitly imported)
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
│       ├── 1password-setup.md #   1Password SSH & GPG setup
│       └── sops-setup.md      #   Encrypted secrets (sops-nix, age) bootstrap & workflow
│
├── nvim/                      # Neovim configuration (Lua, live-linked via HM)
├── tmuxinator/                # tmuxinator project templates (live-linked via HM)
├── git/                       # Git ignore + template (store snapshots via HM)
├── niri/                      # Niri compositor config (live-linked via HM)
├── noctalia/                  # Noctalia settings.toml (live-linked into XDG state)
├── scripts/                   # Utility scripts (tmux project launchers, theme switchers)
├── agents/                    # Global AI-agent guidance, skills, and language conventions
├── ctags/                     # Universal Ctags config (symlinked via HM)
├── macosx/                    # macOS-specific configs (Karabiner, Hammerspoon)
├── misc/                      # Historical configs + active Doom config (see inventory below)
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

Other Linux machines can be wired as standalone Home Manager targets
(`mkHomeConfiguration`). For future headless servers, the
[standalone Linux bootstrap](./nix/README.md#standalone-linux) covers distro/Nix
prerequisites, explicit host selection, locked first activation without an
installed Home Manager, and session setup. No real foreign-server output is
exported yet; declare the actual host before applying.

### Active and historical configuration

`misc/emacs/doom` is active: Home Manager live-links it to `~/.config/doom`.
The other `misc/` configs are historical material, not a fresh-install recipe.
The `.gitmodules` entries for `fish/functions/rust.fish` and
`clojure/dot-clojure` refer to paths absent from the tracked tree; there are no
tracked submodule gitlinks to initialize. They are not onboarding prerequisites.
This inventory does not relocate or delete historical configs.

---

## Quick Start

Start with the [installation and recovery guide](./nix/README.md). It is the
single ordered path for prerequisites, checkout/host selection, age key recovery
or enrollment, first activation, and account/data readiness. Do not start a
fresh machine with the everyday rebuild commands below: bootstrap tools may
not exist yet. Review the Homebrew cleanup warning before applying to a Mac.

---

## Commands

```bash
make help          # Show all commands with detected host
make doctor        # Read-only setup preflight; HOST=... TARGET=darwin|nixos|home
make home          # Switch standalone Home Manager (Linux; not used on Darwin)
make home-build    # Plan standalone Home Manager (dry-run, does not build)
make darwin        # Rebuild nix-darwin + integrated Home Manager (macOS only)
make darwin-build  # Build nix-darwin without switching
make nixos         # Rebuild NixOS + integrated Home Manager (NixOS only)
make nixos-build   # Plan NixOS (dry-run, does not build)
make update        # Update flake inputs + pinned package versions
make update-grokbot # Update only the pinned Grok Bot AppImage
make check         # Run all checks (format, deadnix, statix)
make fmt           # Format all Nix files with alejandra
make clean         # Clean build artifacts
```

These are post-bootstrap commands. They normally select the current username
and short hostname; use `HOST=mac-machine` or `HOST=nixos` when the detected
hostname is not the intended output. The configured account remains `zekus`.
`make home` needs the `home-manager` installed by the first activation; use the
guide's locked bootstrap command on a fresh server. The existing `zekus@nixos`
output is for the workstation, not a headless server. NixOS/Darwin system
switches already include Home Manager.

Grok Bot uses a version-pinned x64 AppImage on Linux, with a desktop launcher and
the `grok-bot` command. `make update-grokbot` resolves the official stable download
link and updates the version, release revision, and hash; it also runs as part of
`make update`. Apply the new package with `make nixos` (or `make home` for a
standalone Home Manager installation), rather than using in-app updates.

On macOS, `make darwin` manages Grok Bot through the Homebrew `grok-bot` cask.
The Mac app supports in-app updates; `make update-grokbot` only updates Linux.

### Nushell completions

Nushell uses prefix matching for its native completions, so short command names
do not match unrelated words inside long registered subcommands. For external
commands, it tries Carapace, then Fish when Carapace returns no suggestions or
fails. `asdf`, `mvn`, and
`tailscale` use Fish directly. If neither provider has suggestions, Nushell can
fall back to its file completions. This requires Nushell's named completer inputs
(`place.command`, supported by the pinned Nushell).

The Fish bridge loads bundled, vendor, user, and man-page-generated completions,
including Home Manager's generated completion directory. Home Manager generates
these from installed packages by default. To refresh Fish's separate cache from
man pages available on the current system, run this from Nushell:

```nu
fish -c 'fish_update_completions'
```

Custom Fish completion files belong in `~/.config/fish/completions/<command>.fish`.
Arbitrary project scripts still need completion definitions; neither provider
can infer their subcommands. The bridge does not provide Fish syntax or functions
defined only during interactive Fish startup.

---

## Architecture

Every host is built from one **headless-safe base** and then specialised along
**three orthogonal axes** -- OS family, role, and management target. The base
(`home.nix` + `modules/*` + `platforms/linux`) ships no GUI apps or desktop
services, so it runs on a headless server just as happily as a laptop; anything
graphical is opt-in via a profile.

This no-GUI contract applies to Linux; the Darwin platform itself installs GUI
apps and preferences. Headless-safe does not mean a minimal package closure.
See [edit/apply ownership](./nix/README.md#edit-and-apply-ownership) for live links,
Nix-managed settings, script snapshots, and separately restored state.

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

The centralized `common` attrset (user info, paths, env vars, `isLinux`/`isDarwin`) is passed as `specialArgs` to every Home Manager and system module. Live-edited configs (Neovim, Niri, Noctalia, agents) use `mkOutOfStoreSymlink`. Ghostty and tmux are Nix-managed. Script helpers are store snapshots of repo-relative sources.

---

## What's Included

**Base** *(all hosts -- headless-safe)*
- Neovim (nixpkgs unstable) with Treesitter grammars, LSPs for Lua, Nix, Go, Rust, Python, TypeScript, Ruby, Clojure, Haskell
- Fish & Nushell with Starship prompt, Carapace completions
- tmux with tmuxinator
- Git with delta, difftastic, lazygit, jujutsu (jj), lazyjj, jjui
- direnv, atuin (shell history), zoxide, yazi
- ripgrep, fd, bat, btop, fastfetch
- GPG signing, SSH via 1Password agent (encrypted host list via sops-nix)
- devenv

**`graphical` profile** *(opt-in -- any host with a display)*
- Ghostty terminal, Obsidian (cross-platform)
- Linux adds: Chromium, Zed, Emacs (pgtk), OBS Studio (PipeWire capture), Radicle, media viewers, helium and Grok Bot (x86_64), 1Password GUI autostart

**`wayland` profile** *(opt-in -- Linux desktop, requires `graphical`)*
- Hyprland and Niri compositors with Noctalia shell, hypridle, hyprlock
- NixOS session prerequisites: SDDM, portals, graphics, audio, polkit and storage services
- Stylix CLI theming (Kanagawa, dark polarity); Plasma owns shared Qt/GTK appearance
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
- PipeWire audio, Bluetooth, SDDM login, Plasma 6, Niri, and Hyprland sessions
- Kanata key remapping (caps-lock as ctrl/esc)
- Steam + Gamescope gaming, gpu-screen-recorder, v4l2loopback virtual camera
- Flatpak (GeForce NOW), Podman (Docker-compatible)
- Tailscale VPN, OpenSSH (reachable via Tailscale only)
- 1Password (NixOS module + GUI polkit), xdg portals (KDE/Hyprland/GTK/GNOME)

---

## Flake Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs` | Main package set (nixos-unstable) |
| `home-manager` | User environment management |
| `rex` | Preview-channel Rex personal server on the NixOS host |
| `sops-nix` | Encrypted secrets (age-backed), wired into the base in `nix/lib.nix` |
| `nix-darwin` | macOS system management |
| `nix-homebrew` | Declarative Homebrew on macOS |
| `homebrew-emacs-plus` | Homebrew tap for emacs-plus (macOS) |
| `hyprland` | Wayland compositor |
| `stylix` | System-wide theming |
| `practicalli-clojure-cli-config` | Clojure CLI user config (deps.edn aliases) |
| `nix-flatpak` | Declarative Flatpak management |
| `determinate` | Determinate Nix integration |

---

## Documentation

- [Installation and Recovery](./nix/README.md) -- Canonical setup sequence, checked copyable host examples, readiness, troubleshooting
- [1Password Setup](./nix/docs/1password-setup.md) -- SSH agent & GPG key management
- [sops Setup](./nix/docs/sops-setup.md) -- Encrypted secrets bootstrap & workflow (sops-nix, age)
- [Rex Setup](./nix/docs/rex-setup.md) -- Remote access to NixOS from the Mac

---

## License

MIT
