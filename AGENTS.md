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
home-manager/
├── flake.nix        # Main entry point: inputs, outputs, host definitions
├── lib.nix          # Unified host builders (mkNixosSystem, mkDarwinSystem, mkHomeConfiguration)
├── checks.nix       # CI checks (formatting, deadnix, statix) and formatter
├── home.nix         # Shared config imported by all hosts
├── hosts/           # Per-machine configurations (default.nix + configuration.nix)
├── modules/         # Reusable Home Manager modules
└── platforms/       # Platform-specific abstractions (darwin/, linux/)
```

External configs (nvim/, ghostty/, tmux/, git/, etc.) are symlinked via Home Manager.

## Adding a New Host

1. Create `hosts/<hostname>/configuration.nix` (NixOS/darwin system config)
2. Create `hosts/<hostname>/default.nix` (Home Manager config)
3. Add directly to the appropriate output attrset in `flake.nix`:
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
- Host-specific code → `hosts/`, shared code → `modules/`, platform code → `platforms/`

## Principles

- Keep setup modern, safe, performant, idiomatic, easy to reason about and extend
- Leave checking home manager setup to me unless I ask otherwise
