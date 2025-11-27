# Home Manager Configuration

A flake-based Home Manager configuration for managing user environments across multiple machines (Linux and macOS).

## Structure

```
home-manager/
├── flake.nix                 # Main flake with multi-host configurations
├── flake.lock               # Locked dependencies
├── home.nix                 # Shared base configuration
├── hosts/                   # Host-specific configurations
│   ├── linux-machine.nix   # Linux machine config
│   └── mac-machine.nix     # macOS machine config
├── platforms/               # Platform-specific configurations
│   ├── linux.nix          # Linux settings (generic)
│   └── darwin.nix         # macOS settings
└── modules/
    ├── common.nix          # Platform-aware common variables
    ├── packages/          # Package definitions
    ├── programs/          # Program configurations
    ├── services/          # Service configurations
    └── ...
```

## Supported Platforms

- **Linux**: `x86_64-linux`
- **macOS**: `aarch64-darwin` (Apple Silicon) or `x86_64-darwin` (Intel)

## Platform Differences

### Linux
- Home directory: `/home/zekus`
- Bash: disabled (fish is the primary shell)
- Window managers: Standard Linux tools

### macOS
- Home directory: `/Users/zekus`
- Bash: enabled
- Window managers: Aerospace
- Window borders: JankyBorders

## Usage

### Initial Setup

1. Install Nix with flakes enabled
2. Clone this repository
3. Run Home Manager for your machine

### Switching Configurations

**On Linux:**
```bash
home-manager switch --flake .#zekus@linux-machine
```

**On macOS:**
```bash
home-manager switch --flake .#zekus@mac-machine
```

**Backwards compatible (existing Linux setup):**
```bash
home-manager switch --flake .#zekus
```

**With automatic hostname detection:**
```bash
home-manager switch --flake .#zekus@$(hostname)
```

### Adding a New Machine

1. Create a new host file in `hosts/` (e.g., `hosts/work-laptop.nix`)
2. Import the base configuration and appropriate platform module:
   ```nix
   { pkgs, ... }:
   {
     imports = [
       ../home.nix
       ../platforms/darwin.nix  # or linux.nix
     ];
     
     # Host-specific overrides
   }
   ```
3. Add the configuration to `flake.nix`:
   ```nix
   "zekus@work-laptop" = mkHomeConfiguration {
     system = "aarch64-darwin";
     hostname = "work-laptop";
   };
   ```

### Updating Dependencies

```bash
nix flake update
```

### Building Without Switching

```bash
home-manager build --flake .#zekus@linux-machine
```

## Configuration Organization

### Shared Configuration (`home.nix`)
Contains settings common to all machines:
- Base packages
- Shared program configurations
- Common environment variables

### Platform-Specific Modules
- `platforms/linux.nix`: Linux-only configurations
- `platforms/darwin.nix`: macOS-only configurations

### Host-Specific Files
Individual machine configurations in `hosts/` can override or extend:
- Shared settings
- Platform defaults
- Add machine-specific packages or configurations

## Customization

### Adding Packages
Edit `modules/packages/default.nix` to add packages available on all platforms.

For platform-specific packages, edit:
- `platforms/linux.nix` for Linux-only packages
- `platforms/darwin.nix` for macOS-only packages

### Configuring Programs
Program configurations are in `modules/programs/`. Platform-specific programs are imported by platform modules.

### Environment Variables
- Common variables: `modules/sessionvariables/`
- Platform-specific: Add to `platforms/{linux,darwin}.nix`

## Troubleshooting

### Build Errors
Check diagnostics with:
```bash
nix flake check
```

### Platform Detection Issues
The configuration automatically detects the platform using `pkgs.stdenv.isDarwin`. Ensure you're using the correct system architecture in `flake.nix`.

### Path Issues
Ensure all relative imports start from the correct directory. The `common.nix` module automatically adjusts paths based on platform.

## Dependencies

- [nixpkgs](https://github.com/nixos/nixpkgs): unstable channel
- [home-manager](https://github.com/nix-community/home-manager): Follows nixpkgs
- [neovim-nightly-overlay](https://github.com/nix-community/neovim-nightly-overlay): Latest Neovim builds

## State Version

Current state version: `24.11`

When updating, check the [Home Manager release notes](https://github.com/nix-community/home-manager/blob/master/docs/release-notes/rl-2411.adoc) for breaking changes.
