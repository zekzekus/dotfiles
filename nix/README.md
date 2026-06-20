# Home Manager Configuration

Flake-based Home Manager configuration for managing user environments across multiple machines.

## Installation

### macOS (nix-darwin)

1. **Install Nix** (Determinate Systems installer):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Clone the repository**:
   ```bash
   git clone https://github.com/zekzekus/dotfiles ~/devel/tools/dotfiles
   cd ~/devel/tools/dotfiles
   ```

3. **Bootstrap nix-darwin** (first time only):
   ```bash
   nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --impure --flake .#mac-machine
   ```
   
   You may be prompted to:
   - Create `/run` symlink (say yes)
   - Back up `/etc/bashrc`, `/etc/zshrc`, etc. (say yes)
   - Migrate existing Homebrew (uses `autoMigrate`)

4. **Subsequent updates**:
   ```bash
   make darwin
   ```

5. **Change default shell** (after first successful switch):
   ```bash
   chsh -s /run/current-system/sw/bin/fish
   ```

> **Note:** nix-darwin manages Home Manager, Homebrew casks, and macOS system defaults declaratively. See `hosts/mac-machine/configuration.nix` for system configuration.

### NixOS

1. **Install NixOS** using the graphical installer. Ensure:
   - Username is `zekus`
   - Hostname is `nixos`

2. **Clone the repository**:
   ```bash
   git clone https://github.com/zekzekus/dotfiles ~/devel/tools/dotfiles
   cd ~/devel/tools/dotfiles
   ```

3. **Replace hardware configuration** with the one generated for the new machine:
   ```bash
   cp /etc/nixos/hardware-configuration.nix nix/hosts/nixos/hardware-configuration.nix
   ```

4. **Bootstrap** (first time only — extra flags needed for Determinate Nix binary cache):
   ```bash
   sudo nixos-rebuild switch \
     --option extra-substituters https://install.determinate.systems \
     --option extra-trusted-public-keys "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=" \
     --impure \
     --flake .#nixos
   ```

   If this fails with a "stale file" or Nix version error, upgrade the stock Nix daemon first:
   ```bash
   sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
   sudo nixos-rebuild switch --upgrade
   ```
   Then retry the bootstrap command above.

5. **Subsequent updates**:
   ```bash
   make nixos
   ```

> **Note:** The `hardware-configuration.nix` in the repo contains machine-specific UUIDs and kernel modules. Always replace it with the generated one from `/etc/nixos/` when setting up a new machine. Trusted users are configured in `hosts/nixos/configuration.nix`. Home Manager is integrated via the NixOS module.

## Adding a New Host

1. Create host directory:
   ```bash
   mkdir -p nix/hosts/<hostname>
   ```

2. Create `default.nix` (Home Manager config):
   ```nix
   { pkgs, ... }:

   {
     # Host-specific Home Manager overrides
   }
   ```

3. Create `configuration.nix` (system config, for NixOS/darwin hosts):
   ```nix
   { common, ... }:

   {
     # System-level configuration
   }
   ```

4. Add directly to the appropriate output attrset in `flake.nix`:
   ```nix
   # NixOS host
   nixosConfigurations = {
     myhost = mkNixosSystem {
       hostname = "myhost";
       # system = "x86_64-linux";  # default
       homeModules = [];
       homeSpecialArgs = {};
       systemModules = [];
       systemSpecialArgs = {};
     };
   };

   # macOS host
   darwinConfigurations = {
     myhost = mkDarwinSystem {
       hostname = "myhost";
       # system = "aarch64-darwin";  # default
       systemModules = [];
     };
   };

   # Standalone Home Manager (no system management)
   homeConfigurations = {
     "zekus@myhost" = mkHomeConfiguration {
       hostname = "myhost";
       system = "x86_64-linux";
     };
   };
   ```

### How `lib.nix` Wires Hosts

The builder functions in `lib.nix` automatically:
- Detect platform from `system` and import the correct `platforms/darwin` or `platforms/linux`
- Import `home.nix` (shared, headless-safe base) for all hosts
- Resolve `profiles = [ ... ]` from the `profileRegistry` and fold in their home/system modules + specialArgs
- Import `hosts/<hostname>/default.nix` for host-specific Home Manager config
- Import `hosts/<hostname>/configuration.nix` for system-level config (NixOS/darwin)
- Set up the `common` attribute set (username, paths, directories, `isLinux`/`isDarwin`)
- For `mkHomeConfiguration` on a foreign distro (`target = "generic-linux"`), enable `targets.genericLinux` (with `gpu.enable` off for headless safety)
- Configure nixpkgs overlays (see `nix/temporary-overlays.nix`)

## Module Structure

### Shared Modules — headless-safe base (all hosts)

| Module | Contents |
|--------|----------|
| `modules/programs/` | CLI program configs: neovim, git, fish, nushell, tmux, starship, fzf, etc. |
| `modules/packages/` | Shared CLI packages: dev tools, terminal utilities, LLM tools |
| `modules/file/` | File symlinks: ctags, tmuxinator, utility scripts |
| `modules/sessionpath/` | PATH entries: `~/bin`, pnpm, coursier |
| `modules/sessionvariables/` | Environment variables: editor, fzf, project directories |

### Profiles — opt-in roles (`profiles = [ ... ]`)

| Profile | Contents |
|---------|----------|
| `profiles/graphical/` | GUI apps: ghostty, obsidian (cross-platform); `linux/` adds firefox, chromium, zed, OBS, media viewers, helium, emacs-pgtk, 1Password GUI |
| `profiles/wayland/` | Hyprland/Niri/Noctalia session (HM side), stylix, rofi, hyprlock, hypridle, tray services |

### Platform Modules (OS family)

| Platform | Contents |
|----------|----------|
| `platforms/darwin/` | Aerospace, JankyBorders, Karabiner, Hammerspoon, Homebrew PATH |
| `platforms/linux/` | Headless-safe stub (home for Linux-universal user config) |

### Host-Specific Config

| Host | Key Features |
|------|-------------|
| `hosts/mac-machine/` | nix-darwin system defaults, Homebrew casks, Touch ID sudo, file descriptor limits |
| `hosts/nixos/` | NixOS system: Kanata, Steam, Flatpak, PipeWire, portals, greetd, hardware config (desktop *home* now via `graphical`+`wayland` profiles) |

## Checks & Quality

The flake includes automated checks run via `make check` (or `nix flake check --impure`):

| Check | Tool | Purpose |
|-------|------|---------|
| `formatting` | alejandra | Nix code formatting |
| `deadnix` | deadnix | Unused code detection |
| `statix` | statix | Nix anti-pattern linting |

Format all Nix files: `make fmt`

## Updating Dependencies

```bash
make update
# or manually:
nix flake update
```

## Troubleshooting

```bash
# Validate the flake
nix flake check --impure

# Build without switching (dry-run)
make home-build     # Home Manager only
make darwin-build   # nix-darwin
make nixos-build    # NixOS

# Show detected host
make help
```
