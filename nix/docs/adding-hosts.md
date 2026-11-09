# Adding a Host

[Project overview](../../README.md) · [Installation](../README.md) ·
[Architecture](architecture.md) · [Maintenance](maintenance.md)

Use this after [preparing the OS and cloning](../README.md#1-choose-the-target-and-prepare-the-os),
before credentials and first activation. For a reinstall of `nixos` or
`mac-machine`, follow the existing-host path in the installation guide instead.
Never replace the existing workstation's hardware file to add another machine.
Run commands from the checkout; examples use Nushell.

## 1. Copy the matching example

Choose a unique hostname, supported architecture, and management target:

| Target | Directory to copy | Architecture | Profiles |
| --- | --- | --- | --- |
| NixOS Wayland desktop | `nix/hosts/example-nixos` | `x86_64-linux` | `["graphical" "wayland"]` |
| Apple Silicon Mac | `nix/hosts/example-darwin` | `aarch64-darwin` | `["graphical"]` |
| Foreign Linux headless server | `nix/hosts/example-headless` | `x86_64-linux` | `[]` |

For example, replace `new-desktop` with your actual hostname:

```nu
cp -r nix/hosts/example-nixos nix/hosts/new-desktop
```

For a Mac or server, copy its matching example instead. Other architectures are
not covered by these examples. All retain the `zekus` account and fixed checkout
path; none enables personal Amp runners. A headless Linux base has no GUI but
still includes the shared CLI/development tools.

## 2. Supply the machine's own configuration

### NixOS

Replace the copied hardware fixture with the **new machine's** generated file:

```nu
cp /etc/nixos/hardware-configuration.nix nix/hosts/new-desktop/hardware-configuration.nix
```

Edit `configuration.nix`: change `networking.hostName`, use the installer's
original `system.stateVersion`, and retain its working boot loader and additional
storage/encryption/driver settings. The sample uses UEFI with systemd-boot;
BIOS, NVIDIA, encryption, and unusual layouts need installer-specific settings.
Keep the installer-created `zekus` administrator account/password and recovery
access; no password is supplied by the example. Preserve the working generation
until the new configuration is boot-tested. Never format disks to match the
example labels: those are build fixtures.

`wayland` requires Linux **and** `graphical`. On NixOS it supplies Niri/Hyprland,
SDDM (Niri by default), portals, graphics, PipeWire, polkit/PAM, and session
storage/power services. It does not copy Plasma, family accounts, keyboard
devices, gaming, VPNs, or personal services from the `nixos` host.

### Darwin

Edit the three machine names in `configuration.nix`. The shared platform
supplies state version, primary user, Homebrew, and system defaults. Start with
the existing `zekus` administrator account, Command Line Tools, and Determinate
Nix. Review the [Homebrew migration/cleanup warning](../README.md#1-choose-the-target-and-prepare-the-os)
before applying; this can remove undeclared packages and associated data.

### Headless Linux

Only `default.nix` is needed. The distro supplies the account, boot/storage,
networking, SSH, systemd user session, and Nix prerequisites from
[installation phase 1](../README.md#1-choose-the-target-and-prepare-the-os).
HM does not replace system provisioning. Use `profiles = []` and the default
`generic-linux` target, **not** `target = "nixos"`. Foreign desktops remain
outside this bootstrap's scope.

## 3. Declare and export the host

Copy the corresponding `exampleHosts` entry in `flake.nix` into `hosts`.
Rename its key and `hostname` to match the new directory; retain the Darwin
`systemModules` tap wiring. Leave the original examples intact for checks.
Export the new host in the matching output attrset:

```nix
# In nixosConfigurations:
new-desktop = mkNixosSystem hosts.new-desktop;
# Or in darwinConfigurations:
new-mac = mkDarwinSystem hosts.new-mac;
# Or in homeConfigurations:
"zekus@new-server" = mkHomeConfiguration hosts.new-server;
```

Use only the matching entry/output. System builders accept the complete host
entry. An HM-only entry accepts `hostname`, `system`, `profiles`, `homeModules`,
and `homeSpecialArgs`. If reusing a system-host entry, forward those home fields
explicitly with `inherit (hosts.<name>) ...`, not system-only fields. Foreign
Linux defaults to `generic-linux`; `target = "nixos"` is only for standalone HM
on NixOS. See [builder composition](architecture.md#how-builders-assemble-a-host)
for adding modules or reusable profiles.

## 4. Check without activating, then resume installation

Review new files for plaintext secrets. In a jj checkout, `jj status` tracks
new files automatically and makes them visible to the flake; no bookmark or
commit is needed to evaluate. In a Git-only clone, stage only the intended new
files so the Git-backed flake sees them.

```nu
make check
# For the new NixOS desktop:
make doctor HOST=new-desktop TARGET=nixos
nix build --impure --no-link .#nixosConfigurations.new-desktop.config.system.build.toplevel
# Mac equivalent, on the Mac:
make doctor HOST=new-mac TARGET=darwin
nix build --impure --no-link .#darwinConfigurations.new-mac.system
# Server equivalent, on supported Linux:
make doctor HOST=new-server TARGET=home
nix build --impure --no-link '.#homeConfigurations."zekus@new-server".activationPackage'
```

Use only your target's doctor/build pair. Builds do not switch anything;
doctor may report credential errors until the next phase. Return to
[phase 3: credentials](../README.md#3-restore-credentials-and-service-prerequisites),
then use the matching phase-4 bootstrap command with the **new output name**.
For example, substitute `.#new-mac` for `.#mac-machine`, `.#new-desktop` for
`.#nixos`, or `.#zekus@new-server` for the server placeholder. After activation,
complete phase 5; a successful build does not prove boot or runtime readiness.

## Example checks versus installation testing

`make check` instantiates **all three examples on either check platform**, so
Linux checks also catch Darwin evaluation failures. It forces complete
system/activation derivations and assertions; it does not build their closures,
activate them, validate real hardware, or test desktop startup. Examples are
build-only `packages`, absent from installable outputs and doctor's inventory.
To build the unchanged examples:

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
