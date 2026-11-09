# Maintenance

[Project overview](../../README.md) · [Installation](../README.md) ·
[Adding a Host](adding-hosts.md) · [Architecture](architecture.md)

Run commands from `~/devel/tools/dotfiles`. Examples use Nushell. These are
**post-bootstrap** workflows; a fresh machine needs the locked first-use
commands in [Installation and Recovery](../README.md#4-first-activation).

## Apply and build

Make normally selects the current username and short hostname. Use an explicit
`HOST` when that is not the intended output. `USER` selects a Home Manager
output but does not change the configured `zekus` account. `FLAKE` defaults to
`.`. Run `make help` to see the detected account/host and all commands.

| Target | Apply | Without activation |
| --- | --- | --- |
| macOS, including HM | `make darwin HOST=mac-machine` | `make darwin-build HOST=mac-machine` — actual build |
| NixOS, including HM | `make nixos HOST=nixos` | `make nixos-build HOST=nixos` — **dry-run only** |
| Standalone HM on Linux | `make home HOST=server-name` | `make home-build HOST=server-name` — **dry-run only** |

Replace `server-name` with a declared host. The existing `zekus@nixos` HM output
belongs to the workstation, not a foreign server. Do not alternate it with
integrated HM without deciding which owns that home. There is no standalone
Darwin home output; use `make darwin` on the Mac.

A dry-run plans downloads/builds; it does not prove that the closure builds.
For an actual no-switch build on the target platform:

```nu
# NixOS workstation:
nix build --impure --no-link .#nixosConfigurations.nixos.config.system.build.toplevel
# A declared standalone Linux host:
nix build --impure --no-link '.#homeConfigurations."zekus@server-name".activationPackage'
```

Use only the relevant command. `--impure` is intentional for this repository's
environment/path policy. `make clean` removes the local `result` build link;
it does not garbage-collect the Nix store.

## Edit and apply ownership

| Source | How changes take effect |
| --- | --- |
| Nix settings, Ghostty, tmux | Rebuild the chosen system/HM output |
| Live-linked Neovim, Niri, Noctalia, agents, tmuxinator, Doom | Edit in the fixed checkout; reload/restart the application as needed |
| Repo-relative script snapshots and Git templates | Rebuild; editing the source does not update the installed snapshot |
| Age/SSH/GPG keys, tokens, accounts, project data, generated assets | Restore/enroll separately; reapply/restart consumers where required |

Keep the checkout in place. A rebuild cannot recreate missing private keys,
application accounts, wallpapers, project data, or independently installed tools.

## Updating dependencies

```nu
make update          # All pinned applications, then flake inputs
make update-pinned   # Only the pinned applications
make update-amp
make update-amp-acp
make update-grokbot
make update-helium
# Flake inputs only:
nix flake update
# One flake input, for example:
nix flake update rex
```

`make update` runs `update-amp`, `update-amp-acp`, `update-grokbot`, and
`update-helium` in that order, then `nix flake update`. It stops on failure and
is **not atomic**: earlier successful pin edits remain for review. Fix the
reported problem and rerun the failing target before continuing. Each app
updater validates release data and all expected replacement fields before
atomically replacing its own pin; a failed updater leaves that pin unchanged.

Downloads retry transient HTTP errors (including 429/504), timeouts, and refused
connections up to four times, with bounded timeouts. Permanent errors still fail
with diagnostics. GitHub lookups can optionally use an existing `GH_TOKEN` or
`GITHUB_TOKEN` environment variable for authenticated rate limits; no token is
required or written into the checkout. Updaters need Bash, curl, Nix, and
standard shell utilities; Python 3 is only needed for tests.

Review the lock/pin diff, run the relevant checks/build, then apply the target
configuration deliberately. Updating files alone does not install new versions.
Review `nix/temporary-overlays.nix` during nixpkgs updates: remove a workaround
only after a successful affected-platform build with upstream checks restored,
not merely an evaluation. The picosvg override's comment specifies its recheck.

### Grok Bot

Linux uses a version-pinned x64 AppImage, desktop launcher, and `grok-bot`
command. `make update-grokbot` resolves the official stable link and updates
version, release revision, and hash. Apply with `make nixos` (or `make home`
for standalone HM), rather than in-app updates. macOS uses the Homebrew
`grok-bot` cask through `make darwin`; its app supports in-app updates.
`make update-grokbot` only updates Linux.

## Checks and their limits

```nu
make check           # nix flake check --impure
make fmt             # Format Nix files with alejandra
make doctor HOST=nixos TARGET=nixos
make doctor HOST=nixos TARGET=nixos RUNTIME=1
```

Use `HOST=mac-machine TARGET=darwin` on the Mac or
`HOST=server-name TARGET=home` for a declared standalone host. `TARGET` changes
doctor's selection only; it does not change which activation command to use.

| Check | Coverage |
| --- | --- |
| `formatting` | Alejandra Nix formatting |
| `deadnix`, `statix` | Unused Nix code and anti-patterns |
| `doctor` | ShellCheck + offline Python CLI tests; disposable age decryption, warning/error behavior, no writes or secret output |
| `updaters` | ShellCheck + Python CLI tests with copied pins and local HTTP; retries, errors, replacement guards, hashes, authentication, failure ordering |
| `eval-*` | System/home derivations and assertions, including all three host examples on either check platform |

Checks are provided for `x86_64-linux` and `aarch64-darwin`. Evaluation does not
build target closures or certify boot, activation, credentials, or desktop
readiness. See [example validation](adding-hosts.md#example-checks-versus-installation-testing)
and the [post-login checklist](../README.md#5-accounts-login-and-readiness).

### Doctor reference

Plain doctor checks the selected output, configured identity/architecture/home,
checkout location, bootstrap tools/features, age-key permissions, and SSH
ciphertext decryption. Optional runner ciphertext/directories are warnings.
Missing `darwin-rebuild`/`home-manager` is a bootstrap warning: use the guide's
first-activation command instead of the everyday Make switch target.
Standalone Linux also needs a reachable systemd user manager.

Doctor reads local setup metadata through a dummy Nix store without resolving
flake inputs or evaluating packages/HM. It needs Nix installed, but works before
caches are populated. It does not create files, download inputs, install tools,
start services, or apply configurations. Only run repository code you trust.

`RUNTIME=1` adds local PATH, hostname, rendered SSH snippet/permissions, relevant
agent socket/environment, personal-host runner state/directories/credential
presence, and Wayland session checks. It does not authenticate accounts, sign,
contact SSH hosts, unlock vaults, expose credentials, or prove restored data is
correct. An inactive successful sops-nix oneshot is normal; the rendered file
is the runtime contract.

Exit 0 means required automated checks passed, **not** that the machine is fully
ready. Exit 1 means blocked/unverified. Direct script invocation uses exit 2 for
invalid arguments; Make wraps command failures with exit 2. For example, if
Make is missing, `bash scripts/doctor --host mac-machine --target darwin` still
runs and reports it. The script also accepts `--runtime`.

Metadata follows registry profiles and shared builder policy, not full
evaluation of arbitrary host overrides. Runtime runner checks use the existing
personal-host service names. Manual account, signing, data, and session checks
remain necessary.

## Troubleshooting

| Symptom | First check |
| --- | --- |
| Unknown/wrong output | `make help`, then explicit `HOST` and doctor's available-output list; export a new host before applying |
| Missing bootstrap command | Use the target's [first activation](../README.md#4-first-activation), not a channel/latest CLI |
| File collision or existing `.hm-backup` | Identify the owner and back up the file; do not blindly delete backups |
| Age decryption fails | [Restore/enroll the authorized key](sops-setup.md#restore-or-enroll-an-age-key); a new key cannot decrypt old ciphertext |
| Agent or signing fails | [1Password/GPG troubleshooting](1password-setup.md#troubleshooting); SSH and GPG are separate |
| Activation succeeds but session/services are incomplete | Fresh login, runtime doctor, then the [readiness checklist](../README.md#5-accounts-login-and-readiness) |
| Updated config seems unchanged | Check [edit/apply ownership](#edit-and-apply-ownership): live link, store snapshot, or external state? |

## Nushell completions

Nushell uses prefix matching for native completions, so short names do not match
unrelated words inside long registered subcommands. External commands try
Carapace, then Fish when Carapace fails or returns no suggestions. `asdf`, `mvn`,
and `tailscale` use Fish directly. If neither has suggestions, Nushell can fall
back to files. This uses named completer inputs (`place.command`) in the pinned
Nushell.

The Fish bridge loads bundled, vendor, user, and man-page-generated completions,
including Home Manager's generated completion directory. HM generates these
from installed packages by default. Refresh Fish's separate cache from current
system man pages with:

```nu
fish -c 'fish_update_completions'
```

Custom definitions belong in `~/.config/fish/completions/<command>.fish`.
Project scripts still need definitions; providers cannot infer subcommands.
The bridge does not provide Fish syntax or functions defined only at interactive
Fish startup.
