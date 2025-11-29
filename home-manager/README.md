# Home Manager Configuration

Flake-based Home Manager configuration for managing user environments across multiple machines.

## Installation

### macOS

1. **Install Nix** (Determinate Systems installer):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Clone the repository**:
   ```bash
   git clone https://github.com/zekzekus/dotfiles ~/devel/tools/dotfiles
   cd ~/devel/tools/dotfiles
   ```

3. **Configure trusted users** (required for binary caches):
   ```bash
   sudo mkdir -p /etc/nix/nix.conf.d
   echo "trusted-users = root $(whoami)" | sudo tee /etc/nix/nix.conf.d/trusted-users.conf
   sudo launchctl kickstart -k system/systems.determinate.nix-daemon
   ```

4. **Apply configuration**:
   ```bash
   nix run home-manager/main -- switch --impure --flake ./home-manager#zekus@mac-machine
   ```

5. **Subsequent updates**:
   ```bash
   home-manager switch --impure --flake ./home-manager#zekus@mac-machine
   ```

### Linux (non-NixOS)

1. **Install Nix** (Determinate Systems installer):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Clone the repository**:
   ```bash
   git clone https://github.com/zekzekus/dotfiles ~/devel/tools/dotfiles
   cd ~/devel/tools/dotfiles
   ```

3. **Configure trusted users** (required for binary caches):
   ```bash
   sudo mkdir -p /etc/nix/nix.conf.d
   echo "trusted-users = root $(whoami)" | sudo tee /etc/nix/nix.conf.d/trusted-users.conf
   sudo systemctl restart nix-daemon
   ```

4. **Apply configuration**:
   ```bash
   nix run home-manager/main -- switch --impure --flake ./home-manager#zekus@zomarchy
   ```

5. **Subsequent updates**:
   ```bash
   home-manager switch --impure --flake ./home-manager#zekus@zomarchy
   ```

### NixOS

1. **Clone the repository**:
   ```bash
   git clone https://github.com/zekzekus/dotfiles ~/devel/tools/dotfiles
   cd ~/devel/tools/dotfiles
   ```

2. **Rebuild system** (includes Home Manager):
   ```bash
   sudo nixos-rebuild switch --impure --flake ./home-manager#nixos
   ```

> Trusted users are configured in `configuration.nix`. Home Manager is integrated via the NixOS module.

## Adding a New Host

1. Create host directory:
   ```bash
   mkdir -p home-manager/hosts/<hostname>
   ```

2. Create `default.nix`:
   ```nix
   { pkgs, ... }:

   {
     # Host-specific overrides here
   }
   ```

3. Add to `flake.nix`:
   ```nix
   "zekus@<hostname>" = mkHomeConfiguration {
     system = "x86_64-linux";  # or "aarch64-darwin"
     hostname = "<hostname>";
   };
   ```

## Updating Dependencies

```bash
cd home-manager && nix flake update
```

## Troubleshooting

```bash
nix flake check ./home-manager --impure
```
