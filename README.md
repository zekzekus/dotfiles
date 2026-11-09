# Dotfiles

> Declarative, reproducible, multi-platform development environment powered by **Nix Flakes**, **Home Manager**, and **nix-darwin**.

One config to rule them all -- macOS, Linux, and NixOS.

These are my personal dotfiles, shared as a working setup and a source of ideas.
The declared machines use the `zekus` account and a fixed checkout location;
this is not a drop-in installer for someone else's machine. Start with the
[setup guide](./nix/README.md) to recreate a host or adapt the configuration.

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
│   │   ├── nixos/             #   NixOS (x86_64-linux) full system + host overrides
│   │   └── example-*/         #   Copyable Mac, NixOS desktop, and headless Linux examples
│   ├── modules/               # Cross-platform, headless-safe HM modules (explicitly imported)
│   │   ├── file/              #   File symlinks (ctags, tmuxinator, scripts)
│   │   ├── packages/          #   Shared CLI packages
│   │   ├── programs/          #   Program configurations
│   │   ├── sessionpath/       #   PATH management
│   │   └── sessionvariables/  #   Environment variables
│   ├── profiles/              # Opt-in role bundles, selected via `profiles = [ ... ]`
│   │   ├── graphical/         #   GUI apps (cross-platform + linux/ gated via common.isLinux)
│   │   └── wayland/           #   Hyprland/Niri/Noctalia, NixOS session prerequisites + Stylix
│   ├── platforms/             # OS-family abstractions
│   │   ├── darwin/            #   macOS: Karabiner, Hammerspoon
│   │   │   └── modules/       #   opt-in: Aerospace, JankyBorders
│   │   └── linux/             #   headless-safe stub (Linux-universal user config)
│   ├── README.md              # Installation and recovery, in order
│   └── docs/                  # New hosts, architecture, maintenance, and credential guides
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
├── misc/                      # Historical configs + active, live-linked Doom config
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
(`mkHomeConfiguration`); no real foreign-server output is exported yet.
[Copyable host examples](./nix/docs/adding-hosts.md) cover a NixOS Wayland desktop,
an Apple Silicon Mac, and a non-NixOS headless server. Foreign desktops need
additional distro integration and are outside the documented bootstrap path.

---

## Quick Start

Start with the [installation and recovery guide](./nix/README.md):

1. Prepare the OS, account, and Nix installation.
2. Clone to `~/devel/tools/dotfiles` and select the intended host explicitly.
3. Restore or enroll credentials **before** activation.
4. Bootstrap the chosen system or Home Manager output.
5. Log in again and complete the readiness checks for the workflows you use.

**New machine?** Follow [Adding a Host](./nix/docs/adding-hosts.md) after cloning,
then rejoin the same credential and activation sequence. **Reinstalling?** Use
the existing host's path; do not copy its hardware configuration to another PC.

Read the guide before switching: macOS activation can remove undeclared
Homebrew packages/data, and NixOS boot/storage settings are machine-specific.
The commands below are for everyday use **after bootstrap**.

---

## Commands

```nu
make help          # Show all commands with detected host
make doctor        # Read-only setup preflight
make doctor RUNTIME=1 # Add post-login local readiness checks
make home          # Switch standalone Home Manager (Linux; not used on Darwin)
make darwin        # Rebuild nix-darwin + integrated Home Manager (macOS only)
make nixos         # Rebuild NixOS + integrated Home Manager (NixOS only)
make update        # Update flake inputs + pinned package versions
make check         # Nix lint/format, script tests, and configuration evaluation
make fmt           # Format all Nix files with alejandra
```

Commands normally select the current username and short hostname. Override
`HOST=mac-machine` or `HOST=nixos` when needed; the managed account remains
`zekus`. NixOS/Darwin switches include Home Manager. Use `make home` only when
standalone Home Manager owns the home, not as a second system setup step.

See [Maintenance](./nix/docs/maintenance.md) for build versus dry-run commands,
targeted updates, troubleshooting, doctor limits, and shell completion behavior.

---

## Architecture

Every host combines a shared base with **three orthogonal axes**:

1. **OS family** -- `platforms/{darwin,linux}`, selected from `system`.
2. **Role** -- opt-in `profiles`, currently `graphical` and `wayland`.
3. **Management target** -- NixOS, nix-darwin, or standalone Home Manager.

`flake.nix` declares each host once; `nix/lib.nix` assembles its shared modules,
platform, profiles, and host overrides. The Linux base is **headless-safe**:
no GUI apps or desktop services, but a full CLI/development environment rather
than a minimal server closure. Darwin itself includes GUI apps and preferences.

Live-edited configs (Neovim, Niri, Noctalia, agents) point back into this checkout.
Ghostty and tmux are Nix-managed; helper scripts are store snapshots. See
[Architecture and Extension](./nix/docs/architecture.md) for module boundaries,
builder details, inputs, and where a change belongs.

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

Packages follow `nixos-unstable`, with Home Manager, nix-darwin, sops-nix,
Hyprland, Stylix, and the other integrations locked in `flake.lock`. See the
[input reference](./nix/docs/architecture.md#flake-inputs) for the full list and
[dependency updates](./nix/docs/maintenance.md#updating-dependencies) for the workflow.

---

## Documentation

- [Installation and Recovery](./nix/README.md) -- Start here for a fresh machine or reinstall
- [Adding a Host](./nix/docs/adding-hosts.md) -- Copyable examples, hardware ownership, and output wiring
- [Architecture and Extension](./nix/docs/architecture.md) -- Layers, module ownership, builders, and inputs
- [Maintenance](./nix/docs/maintenance.md) -- Apply changes, update dependencies, run checks, troubleshoot
- [1Password Setup](./nix/docs/1password-setup.md) -- SSH agent & GPG key management
- [sops Setup](./nix/docs/sops-setup.md) -- Encrypted secrets bootstrap & workflow (sops-nix, age)
- [Rex Setup](./nix/docs/rex-setup.md) -- Remote access to NixOS from the Mac

---

## License

MIT
