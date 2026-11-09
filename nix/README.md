# Installation and Recovery

[Project overview](../README.md) · [Adding a Host](docs/adding-hosts.md) ·
[Architecture](docs/architecture.md) · [Maintenance](docs/maintenance.md)

This is the authoritative sequence for first installation, reinstalling an
existing host, and adding a machine. Credential guides linked below describe
individual phases, not alternative bootstrap sequences. Commands work in
Nushell unless explicitly marked `sh` (run those in `sh`); stop on any failure.
Do not run system activation in an orb or against a different machine.

**Follow in order:** [OS prerequisites](#1-choose-the-target-and-prepare-the-os)
→ [checkout and host](#2-clone-and-select-the-host-explicitly)
→ [credentials](#3-restore-credentials-and-service-prerequisites)
→ [first activation](#4-first-activation)
→ [login and readiness](#5-accounts-login-and-readiness).
For an additional machine, declare it using [Adding a Host](docs/adding-hosts.md)
after cloning, then return to credentials here. For a reinstall, retain the
existing host identity and restore its backups instead.

## 1. Choose the target and prepare the OS

| Target | Architecture | Output | First activation |
| --- | --- | --- | --- |
| Existing Mac `mac-machine` | Apple Silicon, `aarch64-darwin` | `darwinConfigurations.mac-machine` | [macOS](#macos) |
| Existing NixOS workstation `nixos` | `x86_64-linux` | `nixosConfigurations.nixos` | [NixOS](#nixos) |
| Standalone HM on `nixos` | `x86_64-linux` | `homeConfigurations."zekus@nixos"` | [Standalone NixOS home](#existing-standalone-nixos-output) |
| Additional machine | Explicit host/output required | Not auto-generated | [Adding a Host](docs/adding-hosts.md) first |

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
`nix/platforms/darwin/configuration.nix` and inventory/back up Homebrew packages and
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

Doctor checks the output, account/architecture/paths, bootstrap tools, and age
decryption without changing the machine or displaying credentials. Credential
errors are expected before phase 3: restore/enroll the key and rerun. Missing
`darwin-rebuild` or `home-manager` is a bootstrap warning; phase 4 supplies the
locked first-use CLI. Stop on required errors before activation. Exit 0 means
required automated checks passed, not that the machine is fully ready.
See the [doctor reference](docs/maintenance.md#doctor-reference) for exact scope,
exit codes, and invocation without Make.

### Adding a New Host

Follow [Adding a Host](docs/adding-hosts.md) for the copyable NixOS desktop,
Apple Silicon Mac, or headless Linux example. It covers machine-specific
hardware, registry/output wiring, no-switch builds, and what the example checks
do and do not establish. Complete it now, **before phase 3**, then return here
for credentials and activation with your new output name. Do not apply an
existing machine's output to new hardware.

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

Choose **one** target below. Commands name the existing hosts; for an additional
machine, use the output you declared in [Adding a Host](docs/adding-hosts.md).
Do not run a separate Home Manager switch after a NixOS or Darwin system switch.

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

**Reinstalling the existing `nixos` host:** compare the installer's generated
storage/boot configuration with
`nix/hosts/nixos/configuration.nix` (including boot loader and other hardware policy).
Only for that replacement, back up the old hardware file and copy the generated
one into this host:

```nu
cp /etc/nixos/hardware-configuration.nix nix/hosts/nixos/hardware-configuration.nix
```

**Additional machine:** use its own hardware/configuration prepared in
[Adding a Host](docs/adding-hosts.md), not the copy command above.

**Either path:** from the checkout, activate the selected host. Replace
`.#nixos` below with `.#your-hostname` for an additional machine:

```nu
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
`make nixos HOST=nixos` (or your new hostname); it also applies Home Manager.

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

## 5. Accounts, login, and readiness

After activation and a fresh login, run the local, read-only runtime checks:

```nu
make doctor HOST=nixos TARGET=nixos RUNTIME=1
# On the Mac:
make doctor HOST=mac-machine TARGET=darwin RUNTIME=1
# On a declared headless server:
make doctor HOST=server-name TARGET=home RUNTIME=1
```

Runtime doctor checks local commands, rendered secrets/permissions, and relevant
agent/session/runner state without starting services or authenticating accounts.
An inactive successful sops-nix oneshot is normal. Exit 0 is not proof of signing,
account enrollment, correct project data, or a working desktop. See the
[doctor reference](docs/maintenance.md#doctor-reference) for scope and complete
the applicable checklist below before calling a machine ready.

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

For normal setup, complete the desktop checks above. The expandable procedure
below is for validating clean-session recovery on a disposable system, not a
prerequisite to reinstalling the workstation.

<details>
<summary>Disposable-session procedure, recorded results, and limits</summary>

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

**Recorded validation (disposable NixOS VM):** these results are point-in-time,
not a guarantee for every lock-file update. First login
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

</details>

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

After bootstrap, use [Maintenance](docs/maintenance.md) for the edit/apply table,
everyday rebuilds, dependency updates, checks, and troubleshooting. See
[Architecture and Extension](docs/architecture.md) to choose the correct module
or add a reusable profile. Keep first-install/recovery changes in this guide;
the references do not replace its ordered sequence.
