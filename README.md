# ⚙️ Dotfiles

> Declarative, reproducible, multi-platform development environment powered by **Nix Flakes** and **Home Manager**.

One config to rule them all — macOS, Linux, and NixOS.

---

## ✨ Highlights

- 🔄 **Declarative** — Entire environment defined in code, version controlled, reproducible
- 🖥️ **Multi-platform** — Single flake manages macOS (Apple Silicon), Linux, and NixOS
- 🏠 **Multi-host** — Per-machine configurations with shared modules and platform abstractions
- 🎨 **Stylix** — Consistent theming across applications
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
│   │   ├── mac-machine/       #   └── macOS (aarch64-darwin)
│   │   ├── zomarchy/          #   └── Linux (x86_64-linux)
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

| Host | Platform | Architecture | Description |
|------|----------|--------------|-------------|
| `mac-machine` | macOS | aarch64-darwin | Apple Silicon Mac |
| `zomarchy` | Linux | x86_64-linux | Non-NixOS Linux |
| `nixos` | NixOS | x86_64-linux | Full NixOS system |

---

## 🚀 Quick Start

```bash
# Clone
git clone https://github.com/zekzekus/dotfiles ~/devel/tools/dotfiles
cd ~/devel/tools/dotfiles

# Apply (auto-detects host)
make home      # Home Manager only
make nixos     # NixOS full system rebuild
```

See `make help` for all available commands.

---

## 🧩 Philosophy

```
                    ┌───────────┐       ┌─────────────┐
                    │  modules  │       │  home.nix   │
                    │ (shared)  │       │  (shared)   │
                    └─────┬─────┘       └──────┬──────┘
                          │                    │
                          └─────────┬──────────┘
                                    │
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
        └───────────┘         │linux-host │ │nixos-host │
                              └───────────┘ └───────────┘
```

**Layered configuration:**
1. **Flake** — Defines inputs, outputs, and wires everything together
2. **Platforms** — Darwin vs Linux specifics
3. **Hosts** — Machine-specific overrides and hardware config
4. **Modules** — Shared, reusable building blocks
5. **External configs** — Neovim, tmux, etc. symlinked via Home Manager

---

## 📦 What's Included

**Development**
- Neovim (nightly) with Lazy.nvim, LSP, Treesitter
- Git with custom templates and global ignores
- Universal Ctags

**Terminal**
- Ghostty terminal
- tmux with status line themes (Gruvbox, Nord)
- tmuxinator project templates

**Utilities**
- Custom scripts (`em`, `ff`, `rg+`, theme switchers)

---

## 📄 License

MIT — fork it, break it, make it yours.