# Installation and Recovery

This is the authoritative sequence for first installation, reinstalling an
existing host, and adding a machine. Credential guides linked below describe
individual phases, not alternative bootstrap sequences. Commands work in
Nushell unless explicitly marked `sh` (run those in `sh`); stop on any failure.
Do not run system activation in an orb or against a different machine.

## 1. Choose the target and prepare the OS

| Target | Architecture | Output | First activation |
| --- | --- | --- | --- |
| Existing Mac `mac-machine` | Apple Silicon, `aarch64-darwin` | `darwinConfigurations.mac-machine` | [macOS](#4-first-activation) |
| Existing NixOS workstation `nixos` | `x86_64-linux` | `nixosConfigurations.nixos` | [NixOS](#nixos) |
| Standalone HM on `nixos` | `x86_64-linux` | `homeConfigurations."zekus@nixos"` | [Standalone Linux](#standalone-linux) |
| Additional machine | Explicit host/output required | Not auto-generated | [Adding a new host](#adding-a-new-host) first |

- The managed account is **`zekus`**, with home `/Users/zekus` on macOS or
  `/home/zekus` on Linux. Username and checkout paths are fixed in `lib.nix`;
  `make USER=...` does not change that policy. Other accounts need configuration
  changes, not just a command override.
- Install the OS and keep a working administrator account, backups, and local
  recovery access. System switches need `sudo`; Home Manager runs as `zekus`,
  never root. Network access and adequate disk space are required for downloads.
- On macOS, install Apple's Command Line Tools (`xcode-select --install`) and
  finish their prompts so Git and Make work. Install
  [Determinate Nix](https://docs.determinate.systems/getting-started/) and open
  a new terminal. This repo intentionally leaves Nix management to Determinate.
- On NixOS, finish the OS installer with account `zekus`. Keep its generated
  `/etc/nixos` configuration. Ensure Git and Make are available; if needed use
  `nix-shell -p git gnumake` temporarily. Nix is already installed.
- Confirm `git --version`, `make --version`, and `nix --version` work. Flake
  commands require `nix-command` and `flakes` enabled in Nix's configuration;
  the bootstrap Mac command below also enables them explicitly.

**Before applying on an existing Mac:** review
`platforms/darwin/configuration.nix` and inventory/back up Homebrew packages and
application data. `nix-homebrew.autoMigrate = true` adopts existing Homebrew;
`homebrew.onActivation.cleanup = "zap"` can remove undeclared packages/casks
and associated data. The switch also changes macOS defaults. Proceed only if
this machine should be owned by that declared configuration.

## 2. Clone and select the host explicitly

Use HTTPS so SSH credentials are not a bootstrap prerequisite. From the `zekus`
account, create `~/devel/tools` if absent, then:

```nu
git clone https://github.com/zekzekus/dotfiles ~/devel/tools/dotfiles
cd ~/devel/tools/dotfiles
make help
```

Keep this checkout in place: live-linked configs depend on it. For a reinstall,
restore any uncommitted configuration changes from backup before applying.
Do not clone over an existing checkout.

Make normally selects `whoami` and `hostname -s`. A fresh machine may not have
the intended name yet: use `make darwin HOST=mac-machine` or
`make nixos HOST=nixos` explicitly. Standalone HM selects `zekus@HOST`, not a
system output. Check the target table above, then run the read-only preflight:

```nu
make doctor HOST=mac-machine TARGET=darwin
# Or on the NixOS workstation:
make doctor HOST=nixos TARGET=nixos
# Standalone Home Manager, not a system install:
make doctor HOST=nixos TARGET=home
```

`make doctor` defaults to the current hostname/account and selects `darwin` on
macOS, `nixos` on NixOS, otherwise `home`. `TARGET` affects only preflight;
activation still uses the explicit `make darwin`, `make nixos`, or `make home`
command. `USER=...` selects an HM output but cannot change the managed account.
If Make is not installed yet, `bash scripts/doctor --host mac-machine --target
darwin` runs the same checks and reports Make as missing.

The report identifies the selected output, configured user/architecture/home,
expected checkout, missing bootstrap tools/features, age-key availability and
permissions, and decryption of the SSH ciphertext. Optional runner ciphertext
and directory prerequisites are warnings, not blockers for basic setup. It is
normal for credential checks to fail before phase 3; rerun after restoring or
enrolling the key. Missing `darwin-rebuild` is a bootstrap warning (use phase 4),
whereas missing `home-manager` blocks today's `make home` path.

Exit 0 means required preflight checks passed, not that the machine can boot or
all services work. Exit 1 means blocked/unverified; direct script invocation
uses exit 2 for invalid arguments (Make itself wraps failures with exit 2).
No files are created, credentials displayed, inputs downloaded, commands
installed, services started, or configurations applied. Nix reads local setup
metadata through a dummy store, without resolving flake inputs or evaluating
Home Manager/packages; it therefore works before caches are populated. Nix
must already be installed. Only run repository code you trust.

For a new host, add/export it using [the steps below](#adding-a-new-host), then
run `make doctor HOST=<hostname> TARGET=<target>`. Unknown outputs report the
available names. Preflight follows the registry naming convention: system
outputs use the host key; HM outputs use `username@host`. Its user/path facts
are the shared builder policy, not a full evaluation of host overrides.

## 3. Restore credentials and service prerequisites

**Before first activation**, follow [age key restoration or enrollment](docs/sops-setup.md#restore-or-enroll-an-age-key).
For a reinstall, restore that host's backed-up private age key; for a new host,
generate a distinct key and have an already-authorized machine add its public
recipient and rewrap all applicable ciphertext. Generating a key alone cannot
recover existing secrets. Confirm decryption without displaying plaintext.

The existing hosts start personal/work Amp runners automatically. Before
activation, create the empty working/discovery roots if missing:

```nu
mkdir ~/devel/projects/personal ~/devel/projects/playground ~/devel/projects/work
```

Restore project checkouts and `~/Documents/dev.zeko.miracle` from their actual
sources/backups if using the work runner; do not substitute an empty vault for
data recovery. The dotfiles clone supplies `~/devel/tools`. These directories
are not currently created declaratively. Runners are optional personal services,
but their configuration is enabled on both existing hosts; missing directories
or tokens can leave services failed/retrying even if activation succeeds.
See [runner credentials and verification](docs/sops-setup.md#nixos-amp-runners).

Have password-manager account recovery/2FA available independently of this
machine. Use another trusted device or the password-manager app to retrieve the
age backup before managed 1Password is installed; do not depend on the future
SSH agent to obtain the checkout or the decryption key.

## 4. First activation

### macOS

From the checkout, bootstrap nix-darwin using this flake's locked input, rather
than `make darwin` (which requires `darwin-rebuild` already installed):

```nu
sudo nix --extra-experimental-features "nix-command flakes" run --inputs-from . nix-darwin -- switch --impure --flake .#mac-machine
```

Read any `/run` or existing shell-file conflict instructions before accepting
changes. Back up conflicting files instead of deleting them blindly. Home
Manager backs up collisions with `.hm-backup`; an existing backup may still
need manual resolution. System activation includes Home Manager and Homebrew.
After success, optionally choose Fish with
`chsh -s /run/current-system/sw/bin/fish`. Log out and back in, then continue
with [readiness](#5-accounts-login-and-readiness). Later applies use
`make darwin HOST=mac-machine`.

### NixOS

This path **reinstalls/replaces the existing `nixos` host**, not an additional
machine. Compare the installer's generated storage/boot configuration with
`hosts/nixos/configuration.nix` (including boot loader and other hardware policy).
Only for that replacement, back up the old hardware file and copy the generated
one into this host:

```nu
cp /etc/nixos/hardware-configuration.nix nix/hosts/nixos/hardware-configuration.nix
sudo nixos-rebuild switch --option extra-substituters https://install.determinate.systems --option extra-trusted-public-keys "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=" --impure --flake .#nixos
```

Review the full host system config, not just UUIDs: it contains machine-specific
devices, accounts, networking, and desktop policy. Preserve the installer's
working boot generation/configuration until the replacement boots successfully.
If the stock Nix daemon is too old, diagnose the reported version error and
upgrade using the installed NixOS configuration before retrying; do not blindly
switch channels as a generic error workaround.

Reboot into the new generation, then continue with
[readiness](#5-accounts-login-and-readiness). Later applies use
`make nixos HOST=nixos`; it also applies Home Manager.

### Standalone Linux

The only exported standalone target is currently `zekus@nixos`. It is an
alternative way to manage that user's home on an already-configured NixOS
system, **not** a way to install the NixOS host. Do not alternate it with
integrated Home Manager without deliberately deciding which owns the home.
`make home HOST=nixos` requires `home-manager` already on PATH.

Foreign Linux support exists in the builder, but the headless/graphical hosts
are evaluation fixtures, not installable exported outputs. There is **no
complete, clean-install-tested standalone bootstrap yet**. A later piece will
provide the locked first-use Home Manager invocation (without preinstalled
`home-manager`), distro prerequisites, and session environment loading. Until
then, adding a standalone output requires completing those steps manually with
the [Home Manager manual](https://nix-community.github.io/home-manager/).

For a foreign desktop, the distro must supply the graphical session, display
manager, portals, and drivers; HM does not configure the OS. Generic Linux GPU
integration defaults off for headless safety; graphical hosts must deliberately
enable it (and run `sudo non-nixos-gpu`) or use appropriate nixGL wrappers.
Headless-safe means no GUI on Linux, not a small package closure. Darwin's
platform includes GUI packages even without the `graphical` profile.

## Adding a New Host

Do this before the shared credential and activation phases above. Never replace
`hosts/nixos/hardware-configuration.nix` to add a second machine.

1. Choose a unique hostname, supported architecture, and management target.
   The real configurations/check systems cover `x86_64-linux` and
   `aarch64-darwin`; helper recognition of other architectures is not evidence
   that their packages or desktop launchers have been validated.
2. Create `nix/hosts/<hostname>/default.nix` for host HM overrides (an empty
   `_: {}` is sufficient). For NixOS/Darwin also create `configuration.nix`.
   A blank system module is **not a usable NixOS configuration**: start from the
   installer-generated boot/storage/hardware, users, networking, and state
   version, kept under the new host directory. Do not copy the existing
   workstation's accounts, devices, or 500-line system policy wholesale.
   Darwin already imports the shared platform system module; review its
   Homebrew ownership and supply only appropriate host overrides.
3. Add one entry to `hosts` in `flake.nix`, then explicitly export it through
   `mkNixosSystem`, `mkDarwinSystem`, or `mkHomeConfiguration`. Use existing
   wiring as the contract, not evaluation fixtures as ready-made hosts.
   System builders accept the host entry directly. HM accepts `hostname`,
   `system`, `profiles`, `homeModules`, and `homeSpecialArgs`; forward applicable
   home fields, not system-only fields. Set `target = "nixos"` only for
   standalone HM on NixOS; foreign Linux defaults to `generic-linux`.
4. Select profiles intentionally. `[]` is the Linux headless base; `graphical`
   adds GUI apps. `wayland` expects `graphical` and supplies HM-side session
   configuration, not all system compositor/login/portal prerequisites.
5. Make new files visible to the Git-backed flake (`git add` only the new files
   after checking they contain no plaintext secrets). Review/evaluate the new
   output on its own architecture before first activation; evaluation is not a
   boot test. Return to [phase 3](#3-restore-credentials-and-service-prerequisites),
   then use the appropriate target's activation command with the new output name.

Minimal working host examples and complete standalone Linux bootstrap are
separate follow-ups; the steps here document today's wiring and prerequisites,
not a claim that an empty host module boots.

## 5. Accounts, login, and readiness

### Required for the workflows you use

- Log out/in (and reboot NixOS after system installation). Verify the expected
  shell, editor, checkout-backed configs, and environment in a fresh terminal.
  Nushell's managed session loader handles HM variables; an old initialized
  session is not a reliable check of new environment settings.
- Follow [1Password SSH and GPG restoration](docs/1password-setup.md#account-and-key-restoration):
  sign in, enable the agent, restore GPG private key/ownertrust, and test signing.
  Git signs by default with `6716516470AD2D7A`; a successful switch does not
  supply the private key. Restore file-based SSH keys referenced by the encrypted
  host list separately with private permissions (`~/.ssh/keys`, mode `0700`;
  key files mode `0600`). Headless machines need their own SSH authentication;
  they do not get a running 1Password GUI agent.
- Confirm [age decryption](docs/sops-setup.md#verify-decryption-without-printing-secrets)
  and the rendered `~/.ssh/config.d/hosts` path without printing its contents.
- On desktops, test a fresh login, terminal, launcher, browser, audio, and
  monitor layout. Noctalia references an external wallpaper and `HDMI-A-2` in
  `noctalia/settings.toml`; restore the asset or adjust those personal settings.
  `niri/config.kdl` includes untracked `noctalia.kdl`, and Noctalia enables an
  audio-switcher plugin. Clean-session generation/plugin recovery is not yet
  verified; inspect first-launch errors instead of assuming Git restores them.

### Optional personal services and data

- Verify Amp runner services, correct account/directory discovery, and token
  availability using the [runner guide](docs/sops-setup.md#nixos-amp-runners).
  Runners share one OS user; directory lists do not isolate account processes.
- On macOS, approve required Privacy & Security permissions for Hammerspoon,
  Karabiner, window management, and runner access as prompted. Terminal access
  to Documents does not prove a LaunchAgent has the same permission.
- Enroll Tailscale/Rex separately using [Rex setup](docs/rex-setup.md).
- Restore project/vault data, development environments, and work credentials
  before using tmuxinator templates or project scripts. The NixOS `qmd` shim
  needs the separately installed `@tobilu/qmd` binary at
  `~/.local/share/pnpm/bin/qmd`; the shim does not install it.
- Restore other application accounts/data from their backups. Keep age/GPG
  recovery material and password-manager recovery access backed up off-machine.

`make check` checks Nix code/evaluation, not credentials, services, bootability,
or a working desktop. `make doctor` checks setup prerequisites, not live service
health, signing, account enrollment, network/disk capacity, desktop assets, or
privacy permissions. Runtime directory creation and clean-session asset tests
remain separate follow-ups, not guarantees made by these checks.

## Edit and apply ownership

| Source | How changes take effect |
| --- | --- |
| Nix settings, Ghostty, tmux | Rebuild the chosen system/HM output |
| Live-linked Neovim, Niri, Noctalia, agents, tmuxinator, Doom | Edit in the fixed checkout; reload/restart the application as needed |
| Repo-relative script snapshots and Git templates | Rebuild; editing the source does not update the installed snapshot |
| Age/SSH/GPG keys, tokens, accounts, project data, generated assets | Restore/enroll separately; reapply/restart consumers where required |

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
| `modules/programs/` | CLI program configs (explicit imports in `default.nix`): neovim, git, fish, nushell, tmux, starship, etc. |
| `modules/packages/` | Shared CLI packages: dev tools, terminal utilities, LLM tools |
| `modules/file/` | File symlinks: ctags, tmuxinator, utility scripts |
| `modules/sessionpath/` | PATH entries: `~/bin`, pnpm, coursier |
| `modules/sessionvariables/` | Environment variables: editor, project directories, sops age key path |

### Profiles — opt-in roles (`profiles = [ ... ]`)

| Profile | Contents |
|---------|----------|
| `profiles/graphical/` | GUI apps: ghostty, obsidian, localsend, 1Password SSH agent (cross-platform); `linux/` adds chromium, zed, OBS, media viewers, helium (x86_64), emacs-pgtk, 1Password GUI |
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
| `hosts/nixos/` | NixOS system: Kanata, Steam, Flatpak, PipeWire, portals, SDDM, Plasma 6, Niri, Hyprland, hardware config (desktop *home* via `graphical`+`wayland` profiles) |

## Checks & Quality

The flake includes automated checks run via `make check` (or `nix flake check --impure`):

| Check | Tool | Purpose |
|-------|------|---------|
| `formatting` | alejandra | Nix code formatting |
| `deadnix` | deadnix | Unused code detection |
| `statix` | statix | Nix anti-pattern linting |
| `doctor` | ShellCheck + Python CLI tests | Offline preflight, disposable age decryption, error/warning behavior, no-write check |
| `eval-*` | instantiation | Darwin system, standalone HM, plus headless and graphical-only Linux fixtures |

Format all Nix files: `make fmt`

## Updating Dependencies

```bash
make update
# updates flake inputs *and* pinned application versions.
# flake inputs only:
nix flake update
```

## Troubleshooting

```bash
# Validate the flake
nix flake check --impure

# Plan without switching (dry-run does not prove a successful build)
make home-build     # standalone Home Manager (dry-run)
make darwin-build   # nix-darwin (actual build, no switch)
make nixos-build    # NixOS (dry-run)

# Show detected host
make help
```
