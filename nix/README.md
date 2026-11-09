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
- For a **non-NixOS headless server**, use `x86_64-linux`, a glibc-based
  distribution with systemd (such as Debian/Ubuntu), and account `zekus` with
  home `/home/zekus`. Alpine/musl, non-systemd distributions, and ARM servers
  are outside this bootstrap's scope. Keep the distro responsible for
  boot, networking, SSH access, users, security updates, and the login shell.
  Install Bash, Git, Make, curl, CA certificates, xz, sudo, and the systemd user
  session/PAM integration using its package manager. On Debian/Ubuntu:

  ```nu
  sudo apt-get update
  sudo apt-get install bash git make curl ca-certificates xz-utils sudo libpam-systemd dbus-user-session
  ```

  Log in directly as `zekus` (for example over SSH), not via `su` or `sudo -u`;
  `systemctl --user show-environment` must succeed. Install
  [Determinate Nix](https://docs.determinate.systems/getting-started/) using its
  supported Linux installer and review its privilege/system changes. Reconnect
  after installation so Nix is on PATH. Do not install Home Manager separately
  or add a Home Manager channel: phase 4 uses this checkout's locked input.
- Confirm `git --version`, `make --version`, and `nix --version` work. With
  upstream Nix, enable `nix-command` and `flakes` in Nix's configuration;
  current Determinate Nix provides these without experimental-feature flags.
  The first-activation commands below also pass the flags for upstream Nix.

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
enrolling the key. Missing `darwin-rebuild` or `home-manager` is a bootstrap
warning: use phase 4, not the everyday Make switch command. Standalone Linux
also requires a reachable systemd user manager for the managed sops service.

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

The existing hosts start personal/work Amp runners automatically. Their Home
Manager activation creates empty personal/playground/work discovery roots under
`~/devel/projects` and ensures `~/devel/tools` exists **before** loading services.
Restore project checkouts and `~/Documents/dev.zeko.miracle` from their actual
sources/backups if using the work runner; do not substitute an empty vault for
data recovery. The dotfiles clone supplies `~/devel/tools`. Runners are optional
personal services, but their configuration is enabled on both existing hosts; missing directories
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

#### Non-NixOS headless server

Complete phases 1–3 first. There is no real foreign server in the host inventory
yet: declare its actual hostname/output using [Adding a New Host](#adding-a-new-host).
Choose `system = "x86_64-linux"`, `profiles = []`, and `mkHomeConfiguration`'s
default `generic-linux` target (do **not** set `target = "nixos"`). Export
`homeConfigurations."zekus@<hostname>"`. The evaluation fixtures are not outputs
you can install. No desktop/Wayland profiles, GPU setup, Amp runners, or
1Password GUI are needed. The shared base is no-GUI, not a minimal closure:
it includes editors, language tooling, and personal CLI configuration.

In the commands below, replace `server-name` with that declared hostname;
keep `zekus` and the checkout path unchanged. Run from the checkout as `zekus`,
never with `sudo`. The temporary secret-tools shell in phase 3 supplies `sops`
for doctor before it is installed in the home:

```nu
make doctor HOST=server-name TARGET=home
nix --extra-experimental-features "nix-command flakes" run --inputs-from . home-manager -- switch -b hm-backup --impure --flake .#zekus@server-name
```

`--inputs-from .` resolves the CLI from **this checkout's `flake.lock`**, not
the latest Home Manager release or a channel. It needs no preinstalled
`home-manager`. Stop if doctor reports errors. Review file collisions and
preserve existing files/backups; `-b hm-backup` does not overwrite an existing
backup. Activation installs the `home-manager` command via
`programs.home-manager.enable`, creates the user profile/configuration, and
starts the user secret service. It does not install the OS or change the
distro's login shell. Keep the existing SSH session open until a second login
works; do not change sshd, PAM, or the login shell as part of this bootstrap.

For a POSIX login shell that is not managed by HM, load the generated session
environment from its login startup file, after the installer's Nix setup. Add
the following once; do not replace the file (this snippet is **sh**, not Nu):

```sh
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
```

For the current POSIX shell, source that same file or log out and back in.
Managed Nushell loads HM session variables itself; do not `source` the POSIX
file in Nu. Start `~/.nix-profile/bin/nu` explicitly if desired without changing
the OS login shell. From a fresh session, confirm `home-manager --version`,
then subsequent applies use:

```nu
cd ~/devel/tools/dotfiles
make home HOST=server-name
```

Continue with the applicable account/key steps in phase 5. Headless SSH keys
and GPG signing credentials are separate restoration steps, not supplied by a
GUI agent. Enabling logout-persistent personal services later may require an
administrator to enable user lingering; it is not required for this basic
interactive setup.

**Validation status:** the locked CLI's version command runs successfully, and
offline preflight has automated coverage. A fresh foreign-Linux installation
through first activation and a subsequent `make home` still needs a
disposable-machine smoke test; this guide does not yet claim clean-install
validation or general distro support.

#### Existing standalone NixOS output

`zekus@nixos` manages the existing workstation's home, **not** a headless server
or NixOS installation. Do not select it on a foreign server or alternate it
with integrated Home Manager without deciding which owns that home. To
bootstrap it intentionally, use the same locked invocation with
`.#zekus@nixos`; later use `make home HOST=nixos`.

Foreign desktops are outside this server bootstrap. They additionally require
the distro to provide sessions, display manager, portals, and drivers. Generic
Linux GPU integration defaults off; graphical hosts must deliberately enable
it (and run `sudo non-nixos-gpu`) or use appropriate nixGL wrappers. Darwin's
platform includes GUI packages even without the `graphical` profile.

## Adding a New Host

Do this before the shared credential and activation phases above. Never replace
`hosts/nixos/hardware-configuration.nix` to add a second machine.

1. Choose a unique hostname, supported architecture, and management target.
   Copy the matching example directory (replace `new-desktop` with your name):

   | Target | Directory to copy | Architecture | Profiles |
   | --- | --- | --- | --- |
   | NixOS Wayland desktop | `nix/hosts/example-nixos` | `x86_64-linux` | `["graphical" "wayland"]` |
   | Apple Silicon Mac | `nix/hosts/example-darwin` | `aarch64-darwin` | `["graphical"]` |
   | Foreign Linux headless server | `nix/hosts/example-headless` | `x86_64-linux` | `[]` |

   ```nu
   cp -r nix/hosts/example-nixos nix/hosts/new-desktop
   ```

   Other architectures are not covered by these examples. All retain the
   `zekus` account and fixed checkout path. Examples enable no personal runners.
2. **NixOS:** replace the copied hardware fixture with the **new machine's**
   generated file, not the existing workstation's hardware file:

   ```nu
   cp /etc/nixos/hardware-configuration.nix nix/hosts/new-desktop/hardware-configuration.nix
   ```

   Edit `configuration.nix`: change `networking.hostName`, use the installer's
   original `system.stateVersion`, and retain its working boot loader and any
   additional storage/encryption/driver settings. The sample uses UEFI with
   systemd-boot; BIOS, NVIDIA, disk encryption and unusual layouts need their
   installer-specific configuration. Keep the installer-created `zekus`
   administrator account/password and recovery access; no password is supplied
   by the example. Preserve the installer's working generation until boot-tested.
   Never format disks to match the example labels: those are build fixtures.

   **Darwin:** edit the three machine names in `configuration.nix`. The shared
   platform supplies state version, primary user, Homebrew and system defaults.
   Start with the existing `zekus` administrator account, Command Line Tools,
   and Determinate Nix. Review the Homebrew migration/`zap` warning in phase 1.

   **Headless Linux:** only `default.nix` is needed. The distro must supply the
   account, boot/storage, networking, SSH access, systemd user session and Nix
   prerequisites in phase 1. HM does not replace system provisioning.
3. Copy the corresponding `exampleHosts` entry in `flake.nix` into `hosts`.
   Rename its key and `hostname` to the new directory name; retain the Darwin
   `systemModules` tap wiring. Leave the original examples intact for checks.
   Export the new host in the matching output attrset, for example:

   ```nix
   # In nixosConfigurations:
   new-desktop = mkNixosSystem hosts.new-desktop;
   # Or in darwinConfigurations, for a new Mac:
   new-mac = mkDarwinSystem hosts.new-mac;
   # Or in homeConfigurations, for a foreign headless server:
   "zekus@new-server" = mkHomeConfiguration hosts.new-server;
   ```

   System builders accept the complete host entry. A standalone HM-only entry
   accepts `hostname`, `system`, `profiles`, `homeModules`, and `homeSpecialArgs`.
   If reusing a system-host entry, forward those home fields explicitly with
   `inherit (hosts.<name>) ...`, not system-only fields. Foreign Linux defaults
   to `generic-linux`; `target = "nixos"` is only for standalone HM on NixOS.
4. `wayland` requires Linux **and** `graphical` (enforced by the builders).
   For NixOS, it now supplies Niri/Hyprland, SDDM with Niri as the default,
   portals, graphics, PipeWire, polkit/PAM and session storage/power services.
   It does not copy Plasma, family accounts, keyboard devices, gaming, VPNs or
   personal services from `nixos`. Foreign Linux gets only HM-side configuration;
   foreign desktops remain outside the supported onboarding path.
5. Review new files for plaintext secrets. In this jj checkout, `jj status`
   tracks new files automatically and makes them visible to the flake; do not
   create a bookmark or commit just to evaluate. In a Git-only clone, stage
   only the new files so the Git-backed flake sees them. Then run:

   ```nu
   make check
   make doctor HOST=new-desktop TARGET=nixos
   nix build --impure --no-link .#nixosConfigurations.new-desktop.config.system.build.toplevel
   # Mac equivalent, on the Mac:
   nix build --impure --no-link .#darwinConfigurations.new-mac.system
   # Server equivalent, on supported Linux:
   nix build --impure --no-link '.#homeConfigurations."zekus@new-server".activationPackage'
   ```

   Use only your target's build command. These build without switching; doctor
   may report credential errors until phase 3. Return to
   [phase 3](#3-restore-credentials-and-service-prerequisites), then activate
   using the appropriate phase-4 command with the **new** output name.

### Example checks versus installation testing

`make check` instantiates **all three examples on either check platform**, so
Linux checks also catch Darwin evaluation failures. It forces the complete
system/activation derivations and their module assertions; it does not build
their closures, activate them, validate real hardware, or test desktop startup.
The examples are build-only `packages`, deliberately absent from installable
system/HM outputs and doctor's inventory. To build the unchanged examples:

```nu
# On x86_64 Linux (no activation):
nix build --impure --no-link .#example-nixos .#example-headless
# On Apple Silicon macOS (no activation):
nix build --impure --no-link .#example-darwin
```

The NixOS and headless examples have completed real builds on Linux. Darwin
has full derivation-evaluation coverage; its closure still needs a native Mac
build. No example has a fresh-install/boot/runtime guarantee. The NixOS sample
hardware is a generic QEMU UEFI/ext4 fixture, replaced during onboarding, not
automatic disk provisioning. Existing host hardware remains untouched.

## 5. Accounts, login, and readiness

After activation and a fresh login, run the local, read-only runtime checks:

```nu
make doctor HOST=nixos TARGET=nixos RUNTIME=1
# On the Mac:
make doctor HOST=mac-machine TARGET=darwin RUNTIME=1
# On a declared headless server:
make doctor HOST=server-name TARGET=home RUNTIME=1
```

Direct invocation also accepts `bash scripts/doctor --runtime`. This adds checks
for the live hostname, managed commands on PATH, and the nonempty rendered SSH
snippet with private permissions. For graphical profiles it checks the agent
socket/environment; for the two existing personal hosts it checks runner service
state, rendered credential presence/permissions and directory existence. For
Wayland it checks Noctalia's service in a Niri/Hyprland session and the generated
Niri include. Optional runner/account/tool gaps are warnings; missing rendered
SSH configuration or a stopped shell in an active Wayland session are errors.
An inactive successful `sops-nix` oneshot is normal: the rendered file, not a
permanently running secret daemon, is the runtime contract.

The command does not start/restart services, sign, invoke account CLIs, contact
SSH hosts, unlock accounts, or show credentials/service environments. Exit 0
means only that automated required checks passed. File presence is not valid
authentication or restored data; an active runner is not proof of its account
or discovery results. Checks use the registry profiles and current personal-host
service names, not full evaluation of arbitrary module overrides. Complete the
applicable checklist below before calling a machine ready.

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
  Keep key directories private (`0700`) and restored key files `0600`/`0400`.
  Keep a second working login/recovery path until a new SSH login succeeds;
  on a headless server, test a second incoming session from your trusted client.
- On desktops, test a fresh login, terminal, launcher, browser, audio, and
  monitor layout. Noctalia references an external wallpaper and `HDMI-A-2` in
  `noctalia/settings.toml`; restore the asset or adjust those personal settings.
  `niri/config.kdl` includes untracked `noctalia.kdl`, and Noctalia enables an
  audio-switcher plugin. The disposable-session findings below distinguish
  automatic recovery from the remaining manual readiness checks.

### Clean Wayland session acceptance check

Use a disposable NixOS install/test account with the supported configuration,
not deletion of state in the daily desktop account. This is an interactive
acceptance test, **not** something doctor performs. Do not reset real state or
restart the current desktop to simulate a clean install.

1. Start with no generated `~/.config/niri/noctalia.kdl`, plugin cache or restored
   wallpaper. Record whether the first Niri login starts or fails before
   Noctalia can generate the include; inspect `niri validate` and the local
   Noctalia service journal. A failed first login is a failed acceptance test,
   even if a later login works. Keep logs private.
2. Establish whether Noctalia generates the include automatically, when it does
   so, and whether it writes beside the installed config or the live symlink
   target. Log in again and confirm `niri validate` succeeds without manually
   copying a generated file. If generation needs a prerequisite session/action,
   record it in this guide before claiming a working first-login path.
3. Confirm the enabled `blackbartblues/audio-switcher` plugin is actually
   available after first launch (not merely listed in settings): open it with
   Mod+Shift+A, select an output/input, and verify the controls work. Record any
   required install/account/network step; plugin enablement alone is not recovery.
4. Restore the wallpaper or deliberately choose a new one; verify monitors,
   terminal, launcher, browser and sound, then log out/in and rerun runtime doctor.

**Validation status (locked configuration, disposable NixOS VM):** first login
starts Niri with its default configuration and a missing-include warning.
Noctalia then generates `~/.config/niri/noctalia.kdl` beside the installed config,
not beside its checkout symlink target; Niri automatically reloads the intended
configuration and `niri validate` succeeds. With network access, Noctalia clones
its official/community plugin sources and materializes/loads the enabled
audio-switcher plugin without a restored cache. Initial "no loaded plugin"
warnings can precede this asynchronous download. Its panel opens and lists the
guest's emulated audio devices.

The Wayland profile seeds a writable Ghostty `noctalia` theme from its bundled
`Kanagawabones` theme **only when absent**, before first-activation validation.
Noctalia replaces that seed with its generated theme and owns future updates;
the file is not Nix-managed. The VM verifies successful first activation,
Ghostty validation/rendering, and an unchanged generated-theme checksum after
another activation. A second boot/login verifies successful activation, both
config validators, plugin recovery, and Ghostty rendering with persisted state.

**Limits:** the VM needed a synced virtual hardware reset because orderly GPU
session teardown stalled; orderly logout/login is not certified. Slow virtual
rendering also exceeded Noctalia's normal two-second CLI timeout, so plugin IPC
was probed with a longer timeout. Device switching, real audio devices, monitor
layout, restored wallpaper, and account/key restoration still require the
applicable checks above. The bootstrap/recovery checks pass, not the entire
interactive checklist; neither doctor nor evaluation certifies a fully ready
desktop.

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
or a working desktop. Plain `make doctor` remains a setup preflight; `RUNTIME=1`
adds the local observations above. Neither verifies signing, account enrollment,
network/disk capacity, actual project/vault contents, desktop assets/plugins or
privacy permissions. The manual checks and clean-session acceptance remain
necessary; no automatic check here certifies a fully restored machine.

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
| `profiles/wayland/` | Hyprland/Niri/Noctalia HM session and NixOS system prerequisites (`system.nix`), stylix, rofi, hyprlock, hypridle, tray services |

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
| `doctor` | ShellCheck + Python CLI tests | Offline preflight/runtime checks, disposable age decryption, error/warning behavior, no-write and no-secret-output checks |
| `updaters` | ShellCheck + Python CLI tests | Copied pins and local HTTP: retries, errors, replacement guards, hashes, optional authentication, and stop-on-failure ordering |
| `eval-*` | instantiation | Darwin system, standalone HM, Linux fixtures, and every copyable host example (including Darwin on Linux) |

Format all Nix files: `make fmt`

## Updating Dependencies

```bash
make update
# Flake inputs only:
nix flake update
# Or diagnose/update one application:
make update-amp-acp
```

`make update` runs `update-amp`, `update-amp-acp`, `update-grokbot`, and
`update-helium` in that order, then `nix flake update`. It stops on failure and
is **not atomic**: earlier successful pin edits remain for review. Fix the
reported problem and rerun the failing target before continuing. The individual
updaters validate release data and all expected replacement fields before
atomically replacing their own pin; a failed updater leaves that pin unchanged.

Downloads retry transient HTTP errors (including 429/504), timeouts, and refused
connections up to four times, with bounded timeouts. Permanent errors still fail
with diagnostics. GitHub lookups can optionally use an existing `GH_TOKEN` or
`GITHUB_TOKEN` environment variable for authenticated rate limits; no token is
required or written into the checkout. Updaters need Bash, curl, Python 3, and
Nix (archive hashes are computed locally, without prefetching into the store).

Review `nix/temporary-overlays.nix` during nixpkgs updates. Each workaround's
removal criterion is a successful affected-platform build with upstream checks
restored, not just an evaluation. The picosvg override has no recorded original
failure; its comment gives the explicit recheck needed before removing it.

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
