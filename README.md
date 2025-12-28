# ⚙️ Dotfiles

> Declarative, reproducible, multi-platform development environment powered by **Nix Flakes**, **Home Manager**, and **nix-darwin**.

One config to rule them all — macOS, Linux, and NixOS.

---

## ✨ Highlights

- 🔄 **Declarative** — Entire environment defined in code, version controlled, reproducible
- 🖥️ **Multi-platform** — Single flake manages macOS (via nix-darwin), Linux, and NixOS
- 🏠 **Multi-host** — Per-machine configurations with shared modules and platform abstractions
- 🎨 **Stylix** — Consistent theming across applications
- 🐚 **Desktop Shells** — AGS-based shells (DMS default) for NixOS/Hyprland
- 🚀 **Neovim Nightly** — Always on the bleeding edge via nix-community overlay
- ⚡ **Make-driven** — Simple commands that auto-detect your host

---

## 🗂️ Structure

```
.
├── home-manager/              # Nix flake & Home Manager configs
│   ├── flake.nix              # Main flake entry point
│   ├── home.nix               # Shared home configuration
│   ├── hosts/                 # Per-machine configurations
│   │   ├── mac-machine/       #   └── macOS (aarch64-darwin) + nix-darwin
│   │   └── nixos/             #   └── NixOS (full system + home)
│   ├── modules/               # Reusable Home Manager modules
│   │   ├── file/              #   └── File symlinks
│   │   ├── packages/          #   └── Package sets
│   │   ├── programs/          #   └── Program configurations
│   │   ├── services/          #   └── User services
│   │   ├── sessionpath/       #   └── PATH management
│   │   └── sessionvariables/  #   └── Environment variables
│   └── platforms/             # Platform-specific configs
│       ├── darwin/            #   └── macOS-only settings
│       └── linux/             #   └── Linux-only settings
│
├── nvim/                      # Neovim configuration (Lua)
├── ghostty/                   # Ghostty terminal config
├── tmux/                      # tmux configurations & themes
├── tmuxinator/                # tmuxinator project templates
├── git/                       # Git config & templates
├── scripts/                   # Utility scripts
├── ctags/                     # Universal Ctags config
├── misc/                      # Legacy configs (archived)
│
└── Makefile                   # Convenience commands
```

---

## 🖥️ Supported Hosts

| Host | Platform | Architecture | Management |
|------|----------|--------------|------------|
| `mac-machine` | macOS | aarch64-darwin | nix-darwin + Home Manager |
| `nixos` | NixOS | x86_64-linux | NixOS + Home Manager |

---

## 🚀 Quick Start

```bash
# Clone
git clone https://github.com/zekzekus/dotfiles ~/devel/tools/dotfiles
cd ~/devel/tools/dotfiles

# Apply (auto-detects host)
make darwin    # macOS (nix-darwin + Home Manager)
make nixos     # NixOS full system rebuild
make home      # Standalone Home Manager only
```

See [home-manager/README.md](./home-manager/README.md) for detailed installation instructions.

---

## 🧩 Philosophy

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
              ▼                     ┌─────┴─────┐
        ┌───────────┐               ▼           ▼
        │ mac-host  │         ┌───────────┐ ┌───────────┐
        │(nix-darwin│         │linux-host │ │nixos-host │
        └───────────┘         └───────────┘ └───────────┘

              ┌───────────┐       ┌─────────────┐
              │  modules  │       │  home.nix   │
              │ (shared)  │       │  (shared)   │
              └───────────┘       └─────────────┘
```

**Layered configuration:**
1. **Flake** — Defines inputs, outputs, and wires everything together
2. **Platforms** — Darwin vs Linux specifics
3. **Hosts** — Machine-specific overrides and hardware config
4. **Modules** — Shared, reusable building blocks
5. **External configs** — Neovim, tmux, etc. symlinked via Home Manager

---

## 📦 What's Included

**Shared** *(all platforms)*
- Neovim (nightly) with Lazy.nvim, LSP, Treesitter
- Ghostty terminal
- Fish & Nushell with Starship prompt
- tmux with Gruvbox/Nord themes
- Git with delta/difftastic, lazygit, jujutsu
- Go, Rust, Python, Node.js, Ruby, Clojure, Deno
- fzf, ripgrep, fd, bat, zoxide

**Darwin** *(macOS via nix-darwin)*
- Aerospace tiling window manager
- JankyBorders for window highlights
- Karabiner-Elements key remapping
- Homebrew integration via nix-homebrew

**NixOS Host**
- Hyprland compositor with AGS-based desktop shells
- DankMaterialShell (default), Caelestia, Noctalia available
- Stylix system-wide theming
- Pipewire audio, Bluetooth, SDDM
- Mako notifications, cliphist clipboard

---

## 📄 License

MIT — fork it, break it, make it yours.
