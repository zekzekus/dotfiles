# AGENTS.md

## Shell Environment

User runs **Nushell** as default shell. When executing commands:
- Avoid shell-specific syntax like `&&`, `;`, or `&` for chaining/backgrounding
- Avoid output redirections like `2>&1` or `> /dev/null` (use nushell: `out>`, `err>`, `out+err>`)
- Run commands separately instead of chaining
- Use `| complete` if you need to capture both stdout and stderr
- For complex shell commands, wrap with `bash -c "..."` to use bash syntax directly

## Commands

```bash
make check        # Validate flake
make home         # Apply home-manager config (auto-detects host)
make home-build   # Dry-run build
make darwin       # Rebuild nix-darwin system (macOS only)
make nixos        # Rebuild NixOS system (NixOS only)
make update       # Update flake inputs
```

## Architecture

```
flake.nix            # Main entry point: inputs, outputs, host definitions
nix/
├── lib.nix          # Unified host builders (mkNixosSystem, mkDarwinSystem, mkHomeConfiguration)
├── checks.nix       # CI checks (formatting, deadnix, statix) and formatter
├── home.nix         # Shared config imported by all hosts
├── hosts/           # Per-machine configurations (default.nix + configuration.nix)
│   └── <host>/modules/  # Host-specific opt-in modules (e.g., hyprland, niri)
├── modules/         # Cross-platform Home Manager modules (auto-imported for all hosts)
└── platforms/       # Platform-specific abstractions (darwin/, linux/)
    └── <platform>/modules/  # Platform-wide opt-in modules (e.g., aerospace, firefox)
```

External configs (nvim/, ghostty/, tmux/, git/, etc.) are symlinked via Home Manager.

## Adding a New Host

1. Create `nix/hosts/<hostname>/configuration.nix` (NixOS/darwin system config)
2. Create `nix/hosts/<hostname>/default.nix` (Home Manager config)
3. Add directly to the appropriate output attrset in `flake.nix` (at repo root):
   ```nix
   nixosConfigurations = {
     myhost = mkNixosSystem {
       hostname = "myhost";
       homeModules = [];        # Home Manager modules
       homeSpecialArgs = {};    # Args passed to HM
       systemModules = [];      # NixOS system modules
       systemSpecialArgs = {};  # Args passed to NixOS
     };
   };
   # or
   darwinConfigurations = {
     myhost = mkDarwinSystem { hostname = "myhost"; };
   };
   # or for standalone HM:
   homeConfigurations = {
     "zekus@myhost" = mkHomeConfiguration { hostname = "myhost"; system = "x86_64-linux"; };
   };
   ```

## Code Style

- **Nix**: Use `inherit` when possible, group imports at top, prefer modules over inline config
- **Lua**: Follow existing patterns, use `require()` for imports
- Cross-platform shared code → `nix/modules/`
- Platform-wide code → `nix/platforms/<platform>/modules/`
- Host-specific code → `nix/hosts/<host>/modules/`

## Intentional Design Choices

These are deliberate decisions. Do NOT suggest "fixing" them.

- **`--impure` flag**: All build/switch commands use `--impure` (see Makefile). This is required because the flake references `builtins.currentSystem`, environment variables, and `mkOutOfStoreSymlink` paths that need impure evaluation. Do not suggest removing it.
- **`nix.enable = false`** in `nix/hosts/mac-machine/configuration.nix`: This machine uses **Determinate Nix**, which manages the Nix installation itself. Setting `nix.enable = false` prevents nix-darwin from conflicting with it. This is not a mistake.
- **`home.stateVersion = "24.11"`** in `nix/home.nix` with `enableNixpkgsReleaseCheck = false`: The state version is intentionally pinned behind the current nixpkgs channel. The release check is disabled to suppress the mismatch warning. Do not suggest bumping it.
- **Mixed config styles for window managers**: Hyprland is configured fully in Nix (`wayland.windowManager.hyprland.settings`), while Niri and Noctalia use `mkOutOfStoreSymlink` to link external config files (`niri/config.kdl`, `noctalia/settings.json`). This is intentional — Niri's KDL format and Noctalia's JSON are easier to maintain as standalone files. The Hyprland module predates this pattern. Do not suggest unifying them.

## Principles

- Keep setup modern, safe, performant, idiomatic, easy to reason about and extend
- Leave checking home manager setup to me unless I ask otherwise
