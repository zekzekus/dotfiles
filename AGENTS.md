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

Three orthogonal layering axes:

1. **OS family** — `platforms/{darwin,linux}`, chosen automatically by `system` arch.
2. **Role** — `profiles/*`, opt-in per host via `profiles = [ ... ]` (e.g. `graphical`, `wayland`).
3. **Management target** — the builder (`mkNixosSystem` / `mkDarwinSystem` / `mkHomeConfiguration`), plus `mkHomeConfiguration`'s `target` arg (`nixos` | `generic-linux` | `standalone`) which drives non-NixOS integration.

The **base layer** (`home.nix` + `modules/*` + `platforms/linux`) is **headless-safe**: no GUI apps or desktop services. All GUI lives in profiles. This is what lets a host be any Linux box — NixOS or foreign distro, desktop or headless server.

```
flake.nix            # Inputs, outputs, host definitions, profileRegistry
nix/
├── lib.nix          # Host builders + profile folding + `common` (user info, paths)
├── checks.nix       # CI checks (formatting, deadnix, statix) and formatter
├── home.nix         # Shared, headless-safe base imported by all hosts
├── hosts/           # Per-machine config only (default.nix + configuration.nix)
├── modules/         # Cross-platform, headless-safe HM modules (auto-imported)
├── profiles/        # Opt-in role bundles selected via `profiles = [ ... ]`
│   ├── graphical/   #   GUI apps (cross-platform + ./linux gated via common.isLinux)
│   └── wayland/     #   Hyprland/Niri/Noctalia session (HM side) + ./modules, stylix
└── platforms/       # OS-family abstractions
    ├── darwin/      #   macOS; ./modules/ opt-in (aerospace, jankyborders)
    └── linux/       #   headless-safe stub (home for Linux-universal user config)
```

Profiles are defined in `flake.nix`'s `profileRegistry` (they can bundle external
HM modules + `homeSpecialArgs` + `systemModules` + `systemSpecialArgs`) and folded
into a host by the builders in `lib.nix`. Conditional `imports` must branch on a
specialArg (e.g. `common.isLinux`), never on `pkgs`/`config` (infinite recursion).

External configs (nvim/, ghostty/, tmux/, git/, etc.) are symlinked via Home Manager.

## Adding a New Host

1. Create `nix/hosts/<hostname>/default.nix` (host-specific Home Manager overrides; may be an empty `_: {}` stub).
2. For NixOS/darwin only: create `nix/hosts/<hostname>/configuration.nix` (system config).
3. Define the machine once in the `hosts` attrset in `flake.nix` (single source of truth for system, profiles, and system wiring), then reference it from the output(s) that manage it:
   ```nix
   hosts = {
     myhost = {
       hostname = "myhost";
       system = "x86_64-linux";   # or "aarch64-darwin"
       profiles = ["graphical" "wayland"];  # [] for a headless server
       systemModules = [];                  # NixOS/darwin system modules
       systemSpecialArgs = {};
     };
   };

   nixosConfigurations.myhost = mkNixosSystem hosts.myhost;
   # or: darwinConfigurations.myhost = mkDarwinSystem hosts.myhost;
   ```
   A machine that appears in several outputs (e.g. NixOS system + standalone HM) must reuse its single `hosts` entry so the profile list cannot diverge.

### Any Linux box via standalone Home Manager

`mkHomeConfiguration` works on NixOS *and* foreign distros (Ubuntu, Fedora, …).
`target` auto-detects to `generic-linux` on Linux (enables `targets.genericLinux`,
with `gpu.enable` forced off for headless safety). Profiles decide the role:

```nix
hosts = {
  # Foreign distro, desktop (Ubuntu/etc.). GUI apps; needs GL for them — either
  # set targets.genericLinux.gpu.enable = true (then `sudo non-nixos-gpu`) or wrap
  # GUI packages with nixGL.
  ubuntu = { hostname = "ubuntu"; system = "x86_64-linux"; profiles = ["graphical"]; };

  # Any non-NixOS server, headless. Base only — no GUI, gpu off.
  vps = { hostname = "vps"; system = "x86_64-linux"; profiles = []; };
};

homeConfigurations = {
  "zekus@ubuntu" = mkHomeConfiguration { inherit (hosts.ubuntu) hostname system profiles; };
  "zekus@vps" = mkHomeConfiguration { inherit (hosts.vps) hostname system profiles; };

  # Standalone HM on NixOS — pass target = "nixos" so genericLinux is NOT enabled.
  "zekus@nixbox" = mkHomeConfiguration {
    inherit (hosts.nixbox) hostname system profiles; target = "nixos";
  };
};
```

A **headless NixOS server** is just a `hosts` entry with `profiles = []` and no
desktop `systemModules`, passed to `mkNixosSystem` — the base is already headless-safe.

## Code Style

- **Nix**: Use `inherit` when possible, group imports at top, prefer modules over inline config
- **Lua**: Follow existing patterns, use `require()` for imports
- Cross-platform, headless-safe shared code → `nix/modules/`
- GUI / role-specific code → `nix/profiles/<profile>/` (e.g. `graphical`, `wayland`)
- Platform-wide (OS-family) code → `nix/platforms/<platform>/modules/`
- Host-specific code → `nix/hosts/<host>/{default,configuration}.nix`

## Intentional Design Choices

These are deliberate decisions. Do NOT suggest "fixing" them.

- **`--impure` flag**: All build/switch commands use `--impure` (see Makefile). This is required because the flake references `builtins.currentSystem`, environment variables, and `mkOutOfStoreSymlink` paths that need impure evaluation. Do not suggest removing it.
- **`nix.enable = false`** in `nix/hosts/mac-machine/configuration.nix`: This machine uses **Determinate Nix**, which manages the Nix installation itself. Setting `nix.enable = false` prevents nix-darwin from conflicting with it. This is not a mistake.
- **`home.stateVersion = "24.11"`** in `nix/home.nix` with `enableNixpkgsReleaseCheck = false`: The state version is intentionally pinned behind the current nixpkgs channel. The release check is disabled to suppress the mismatch warning. Do not suggest bumping it.
- **Mixed config styles for window managers**: Hyprland is configured fully in Nix (`wayland.windowManager.hyprland.settings`), while Niri and Noctalia use `mkOutOfStoreSymlink` to link external config files (`niri/config.kdl`, `noctalia/settings.json`). This is intentional — Niri's KDL format and Noctalia's JSON are easier to maintain as standalone files. The Hyprland module predates this pattern. Do not suggest unifying them.

## Principles

- Keep setup modern, safe, performant, idiomatic, easy to reason about and extend
- Leave checking home manager setup to me unless I ask otherwise
