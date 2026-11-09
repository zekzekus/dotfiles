# Architecture and Extension

[Project overview](../../README.md) · [Installation](../README.md) ·
[Adding a Host](adding-hosts.md) · [Maintenance](maintenance.md)

The configuration is composed along three independent axes. Keep a change at
the narrowest layer that owns it rather than copying a whole existing host.
Paths in the tables below are relative to `nix/`.

## Layers and ownership

| Axis | Selected by | Responsibility |
| --- | --- | --- |
| OS family | `system`, such as `aarch64-darwin` | `platforms/darwin` or `platforms/linux` |
| Role | Host `profiles = [ ... ]` | Opt-in bundles from `profileRegistry` in `flake.nix` |
| Management target | Builder and, for standalone HM, `target` | System + home versus home-only; foreign-Linux integration |

The shared base (`home.nix`, `modules/*`, and the Linux platform) has no GUI
apps or desktop services. This **headless-safe** Linux contract is not a minimal
package set: editors, language tooling, and personal CLI tools are included.
Darwin's platform itself includes GUI applications and system preferences;
`profiles = []` does not turn it into a headless Mac.

| Put a change in | When it belongs to |
| --- | --- |
| `modules/` | Every host; cross-platform and headless-safe |
| `profiles/graphical/` | Machines with displays; Linux-only apps in `linux/` |
| `profiles/wayland/` | The Linux desktop session and its NixOS prerequisites |
| `platforms/<family>/` | An OS family, independent of the machine |
| `hosts/<hostname>/default.nix` | One machine's Home Manager overrides |
| `hosts/<hostname>/configuration.nix` | One machine's NixOS/nix-darwin system configuration |

Shared modules are imported explicitly, not discovered by scanning directories:

| Directory | Contents |
| --- | --- |
| `modules/programs/` | CLI configuration: Neovim, Git, Fish, Nushell, tmux, Starship |
| `modules/packages/` | CLI packages, development tools, and pinned applications |
| `modules/file/` | File links, utility-script snapshots, ctags, tmuxinator |
| `modules/sessionpath/` | PATH entries: `~/bin`, pnpm, coursier |
| `modules/sessionvariables/` | Editor, project paths, and age-key environment |

## How builders assemble a host

`flake.nix` declares each real machine in `hosts` and exports it through the
appropriate output. `nix/lib.nix` provides `mkNixosSystem`, `mkDarwinSystem`,
and `mkHomeConfiguration`. Each takes the host's name, architecture, profiles,
and optional extra modules/arguments.

The Home Manager module list is assembled in this order:

1. Host-supplied `homeModules`.
2. The sops-nix module and `home.nix` (which imports the shared modules).
3. `platforms/darwin` or `platforms/linux`, selected from `system`.
4. Home modules contributed by the selected profiles.
5. `hosts/<hostname>/default.nix`.

This is module composition, not an imperative last-write-wins sequence: Nix's
option merging and priorities still apply. System builders also include the
host's `configuration.nix`, profile system modules, and integrated Home Manager;
Darwin adds shared system policy and nix-homebrew.

The `common` special argument carries user identity, paths, environment defaults,
and `isLinux`/`isDarwin` to home and system modules. The managed username is
`zekus`; the checkout is `~/devel/tools/dotfiles`. Changing Make's `USER` only
selects an output; it does not parameterize that identity. Adapting these
dotfiles for someone else also requires reviewing signing, secrets, host policy,
and application configs, not just editing the host name.

Conditional `imports` must branch on a special argument such as
`common.isLinux`, not `pkgs` or `config` (which can cause infinite recursion).

## Profiles and management targets

- **`graphical`** adds cross-platform GUI apps and the 1Password SSH-agent
  environment; Linux adds its GUI packages and 1Password autostart.
- **`wayland`** requires Linux **and** `graphical` (enforced by the builders).
  It contributes Hyprland/Niri/Noctalia home settings, Stylix, and NixOS session
  prerequisites: SDDM, portals, graphics, PipeWire, polkit/PAM, storage/power
  services. It does not copy the workstation's Plasma, gaming, devices, family
  accounts, VPNs, or personal services.
- A profile registry entry may supply `homeModules`, `homeSpecialArgs`,
  `systemModules`, and `systemSpecialArgs`. Extra modules/arguments can also be
  supplied on a host entry when the behavior is not shared.

Standalone Home Manager's `target` is `generic-linux` by default on Linux and
`standalone` otherwise. `generic-linux` enables `targets.genericLinux` but leaves
GPU integration off for headless safety. Use `target = "nixos"` for standalone
HM on NixOS, avoiding foreign-distro integration. NixOS and Darwin system
switches already apply their integrated Home Manager configuration.

On foreign distros, Home Manager owns only the user environment. The distro
still owns boot, users, SSH, drivers, and desktop/session prerequisites.
Foreign graphical hosts must deliberately enable GPU integration (then run
`sudo non-nixos-gpu`) or use appropriate nixGL wrappers. The documented foreign
bootstrap covers headless x86_64 Linux, not desktop integration.

## Files outside Nix

Neovim, Niri, Noctalia, agent guidance, tmuxinator, and Doom are live-linked
from the checkout using `mkOutOfStoreSymlink`. Ghostty and tmux settings are
Nix-managed. Utility scripts and Git templates are store snapshots.
See [edit/apply ownership](maintenance.md#edit-and-apply-ownership) before
assuming that an edit is already installed.

`misc/emacs/doom` is active and linked to `~/.config/doom`; the other `misc/`
material is historical, not an onboarding prerequisite. There are no tracked
submodules to initialize. [Agent configuration](../../agents/README.md)
documents the separate guidance/skill consumption model.

## Flake inputs

The source of truth is [`flake.nix`](../../flake.nix); exact revisions live in
`flake.lock`. [Maintenance](maintenance.md#updating-dependencies) covers updates.

| Input | Purpose |
| --- | --- |
| `nixpkgs` | Main package set (`nixos-unstable`) |
| `home-manager` | User environment management |
| `nix-darwin` | macOS system management |
| `nix-homebrew` | Declarative Homebrew integration |
| `homebrew-emacs-plus` | macOS emacs-plus tap |
| `sops-nix` | Age-backed encrypted secrets in the shared home layer |
| `hyprland` | Wayland compositor and modules |
| `stylix` | CLI/application theming in the Wayland profile |
| `nix-flatpak` | Declarative Flatpak management |
| `determinate` | Determinate Nix integration |
| `rex` | Preview-channel personal server on the NixOS host |
| `hey-cli` | HEY CLI package |
| `basecamp-cli` | Basecamp CLI package |
| `practicalli-clojure-cli-config` | Clojure CLI user config (`deps.edn` aliases) |
