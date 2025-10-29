# Dotfiles

Multi-machine configuration using Nix flakes and Home Manager.

## Overview

This repository manages configurations for multiple machines using a unified Nix flake:

- **macOS** - Home Manager standalone
- **Linux** - Home Manager standalone  
- **NixOS** - Full system + Home Manager integration

## Structure

```
.
├── home-manager/
│   ├── flake.nix              # Main flake configuration
│   ├── home.nix               # Shared home-manager config
│   ├── hosts/
│   │   ├── mac-machine.nix    # macOS host
│   │   ├── zomarchy.nix       # Linux host
│   │   └── nixos/             # NixOS host
│   │       ├── configuration.nix
│   │       ├── hardware-configuration.nix
│   │       └── default.nix
│   └── modules/               # Shared modules
└── Makefile                   # Convenience commands
```

## Setup Instructions

### macOS

1. Install Nix:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. Clone this repository:
   ```bash
   git clone <repo-url> ~/devel/tools/dotfiles
   cd ~/devel/tools/dotfiles
   ```

3. Apply configuration:
   ```bash
   nix run home-manager/main -- switch --impure --flake ./home-manager#zekus@mac-machine
   ```

4. Subsequent updates:
   ```bash
   make home
   ```

### Linux (non-NixOS)

1. Install Nix:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. Clone this repository:
   ```bash
   git clone <repo-url> ~/devel/tools/dotfiles
   cd ~/devel/tools/dotfiles
   ```

3. Apply configuration:
   ```bash
   nix run home-manager/main -- switch --impure --flake ./home-manager#zekus@zomarchy
   ```

4. Subsequent updates:
   ```bash
   make home
   ```

### NixOS

1. Clone this repository:
   ```bash
   git clone <repo-url> ~/devel/tools/dotfiles
   cd ~/devel/tools/dotfiles
   ```

2. Rebuild system:
   ```bash
   sudo nixos-rebuild switch --impure --flake ./home-manager#nixos
   ```
   
   Or use the Makefile:
   ```bash
   make nixos
   ```

3. Home Manager is integrated automatically via the NixOS module.

## Makefile Commands

The Makefile auto-detects your username and hostname:

- `make` or `make help` - Show available commands
- `make home` - Switch home-manager configuration
- `make home-build` - Build home-manager (dry-run)
- `make nixos` - Rebuild NixOS system (NixOS only)
- `make nixos-build` - Build NixOS without switching
- `make update` - Update flake inputs
- `make check` - Check flake validity
- `make clean` - Clean build artifacts

## Adding a New Host

1. For macOS/Linux:
   ```bash
   cp home-manager/hosts/zomarchy.nix home-manager/hosts/<hostname>.nix
   ```

2. For NixOS:
   ```bash
   mkdir -p home-manager/hosts/<hostname>
   # Add configuration.nix, hardware-configuration.nix, and default.nix
   ```

3. Update `home-manager/flake.nix` to add the new host configuration.

## Directory Paths

Default paths used in configurations (customizable in `flake.nix`):

- `dotfilesDir`: `~/devel/tools/dotfiles`
- `develHome`: `~/devel/projects`
- `workHome`: `~/devel/projects/personal`
- `personalHome`: `~/devel/projects/personal`

## Current Hosts

- **mac-machine** (aarch64-darwin) - macOS
- **zomarchy** (x86_64-linux) - Linux
- **nixos** (x86_64-linux) - NixOS
