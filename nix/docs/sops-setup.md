# sops-nix: encrypted secrets

SSH host definitions (hostname/IP, user, key path) are kept out of the repo in
plaintext. They live in `secrets/ssh-config`, encrypted with [sops] using [age]
keys, committed to git, and decrypted on each machine at Home Manager activation
into `~/.ssh/config.d/hosts`, which the managed `~/.ssh/config` pulls in via
`Include`.

The actual private keys (`.pem`/`.key`) are **never** in this repo or in sops —
you place them on each machine manually (e.g. `~/.ssh/keys/<host>.pem`,
`chmod 600`). For SSH, sops only protects the *config metadata* in git.
The NixOS and macOS Amp runners also use sops for their account access tokens,
described below.

## How it is wired

- `flake.nix` — `sops-nix` flake input.
- `nix/lib.nix` — adds `sops-nix.homeManagerModules.sops` to the base layer, so
  every host gets the `sops` module.
- `nix/modules/programs/ssh.nix` — defines the `ssh-hosts` secret and the
  `Include`. Both are gated on `secrets/ssh-config` existing, so the repo
  evaluates cleanly before the secret is first created.
- `.sops.yaml` — lists the age recipients (one per machine) a secret is
  encrypted for.

## Restore or enroll an age key

Start with the [installation and recovery sequence](../README.md). Complete
this phase **before activation**, including for a reinstall. Commands below
use Nushell. Before the first switch, enter a temporary Nushell with the tools
from the locked input (Nushell need not already be installed). Run from the
checkout; this command also works from the OS's initial shell:

```nu
nix --extra-experimental-features "nix-command flakes" shell --inputs-from . nixpkgs#age nixpkgs#sops nixpkgs#nushell --command nu --no-config-file
```

Inside that shell, explicitly set the path (SOPS uses a different default on
macOS). Keep using that shell for the remaining commands in this phase:

```nu
$env.SOPS_AGE_KEY_FILE = ($env.HOME | path join ".config/sops/age/keys.txt")
```

### Reinstall an existing host

Restore that host's backed-up `keys.txt` to `~/.config/sops/age/keys.txt` using
your trusted backup/password manager. Create the parent directory if absent;
do not overwrite an existing key without identifying and backing it up first.
Keep the directory mode `0700` and the key mode `0600`:

```nu
chmod 700 ~/.config/sops/age
chmod 600 ~/.config/sops/age/keys.txt
age-keygen -y ~/.config/sops/age/keys.txt
```

The printed **public** key must match the host's recipient in `.sops.yaml`.
Restoring the original authorized key does not require `updatekeys`. Keep its
private backup off-machine; never commit it or send it through chat.

### Enroll a new host or replace a lost host key

1. **On the new machine**, only if no key exists at that path, generate a unique
   key and back it up securely:

   ```nu
   mkdir ~/.config/sops/age
   chmod 700 ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   chmod 600 ~/.config/sops/age/keys.txt
   age-keygen -y ~/.config/sops/age/keys.txt
   ```

2. Transfer **only the public `age1...` recipient** to a trusted machine that
   can already decrypt the applicable files. On that authorized machine, add a
   named key in `.sops.yaml` and add its alias to each applicable creation rule.
   Both existing hosts need all three files below. A new host needing only SSH
   metadata need not receive the account-wide Amp runner tokens.
3. **On the authorized machine**, point `SOPS_AGE_KEY_FILE` at its existing key
   and rewrap every applicable file. For the existing full host setup:

   ```nu
   sops updatekeys secrets/ssh-config
   sops updatekeys secrets/amp-runner-personal.env
   sops updatekeys secrets/amp-runner-work.env
   ```

   Changing `.sops.yaml` alone does not change existing ciphertext recipients.
   `updatekeys` needs access to an already-authorized private key; it cannot run
   successfully using only the newly generated, unauthorized key.
4. Review the recipient/ciphertext diff and transfer `.sops.yaml` plus all
   changed encrypted files back to the new host (through the normal repository
   workflow or a trusted file transfer). Keep ciphertext Git-tracked so flakes
   see it. Verify decryption on the new machine before activating services.
   No private key needs to move between machines for enrollment.

### No authorized machine remains

Restore a backed-up **already-authorized private age key** on a trusted recovery
machine, then decrypt or enroll a replacement as above. A fresh key, public
recipients, and ciphertext alone cannot recover the data. Without any authorized
private-key backup, recreate SSH metadata from trusted records and issue new
runner tokens through their accounts, encrypting for the new recipients. Old
private SSH/GPG keys and application data need their own backups; age cannot
recover them. Revoke lost/compromised credentials through their providers.
Removing a recipient does not revoke tokens or erase old ciphertext history.

### Verify decryption without printing secrets

Run for every file the selected host consumes, with `SOPS_AGE_KEY_FILE` set.
The explicit `sh` wrapper discards plaintext and preserves SOPS's exit status:

```nu
sh -c 'sops decrypt secrets/ssh-config > /dev/null'
sh -c 'sops decrypt secrets/amp-runner-personal.env > /dev/null'
sh -c 'sops decrypt secrets/amp-runner-work.env > /dev/null'
```

Each must exit successfully; stop on any error. Do not use `cat`, shell tracing,
or logs to inspect credentials. If a required encrypted file is missing, recover
its ciphertext from backup/history or recreate its contents deliberately;
do not use placeholder tokens. Return to the installation guide's activation
phase once the host's directories and credentials are ready.

## Add or edit a host

```nu
sops edit secrets/ssh-config
```

This opens the decrypted contents in `$EDITOR` (a tempfile; plaintext is never
written to the repo). The file is a plain SSH config snippet — for example:

```sshconfig
Host myhost
  HostName 203.0.113.10
  User ubuntu
  IdentityFile ~/.ssh/keys/myhost.pem
  IdentitiesOnly yes
  IdentityAgent none
```

`IdentitiesOnly yes` + `IdentityAgent none` matter: on graphical hosts the
global `Host *` block routes auth through the 1Password agent, which will not
hold a manually-placed PEM, so these two lines make SSH use the file instead.

## Apply

Ensure changed ciphertext is Git-tracked and contains no plaintext. First
activation and later target selection follow the
[installation guide](../README.md#4-first-activation); do not substitute a
`make` command for a missing bootstrap tool. Place the PEM separately
(`~/.ssh/keys/myhost.pem`, mode `0600`) and test `ssh myhost`.

## NixOS Amp runners

Two user services in `nix/hosts/nixos/default.nix` use separate account tokens:

| Service / runner ID | Discovery roots | Additional directory |
| --- | --- | --- |
| `amp-runner-personal` / `nixos-personal` | `~/devel/projects/personal`, `~/devel/projects/playground` (depth 2); `~/devel/tools` (depth 1) | None |
| `amp-runner-work` / `nixos-work` | `~/devel/projects/work` (depth 2) | `~/Documents/dev.zeko.miracle` |

Only discovered Git checkouts and explicitly listed directories are served;
the working directory itself is not automatically served. Amp has one depth
setting per runner, so an absolute `~/devel/tools/*/*` exclusion prevents
descending into tools' grandchildren while keeping the other roots at depth 2.
These lists organize access, not isolate processes: both runners run as the
same Linux user.

### Create the account credentials

Create one access token in each account's
[Amp security settings](https://ampcode.com/settings/security#access-token).
Treat these as account credentials, not directory-scoped permissions.

Run the following on the NixOS host in a normal terminal or SSH session, not
an Amp runner terminal that will disconnect when the old runner stops. Use
Nushell and stop at any failed step.

1. Enter the repository and verify the existing age key. Do not generate or
   overwrite it. The printed public key must match `&nixos` in `.sops.yaml`:

   ```nu
   cd ~/devel/tools/dotfiles
   age-keygen -y ~/.config/sops/age/keys.txt
   ```

2. Edit the two encrypted dotenv files. These commands keep SOPS editor
   temporary files in the runtime directory and disable Neovim configuration,
   swap files, and persistent editor history:

```nu
with-env {
    SOPS_AGE_KEY_FILE: ($env.HOME | path join ".config/sops/age/keys.txt"),
    TMPDIR: $env.XDG_RUNTIME_DIR,
    EDITOR: "nvim -u NONE -i NONE -n"
} {
    sops edit secrets/amp-runner-personal.env
    sops edit secrets/amp-runner-work.env
}
```

In each editor buffer, keep a single `AMP_API_KEY=` assignment and paste the
corresponding token after `=`. Do not put tokens in shell commands, Nix strings,
chat, or logs. The saved repository files must contain encrypted values, never
plaintext. `.sops.yaml` encrypts these files for both the NixOS and mac-machine
age keys. Keep secure backups of the private keys, such as in a password manager.

The encrypted files are intentionally not supplied with placeholder tokens.
Until each exists, its service cannot start. A missing environment file or
empty token fails startup rather than falling back to the CLI's selected account.

### Apply and verify

3. Check that SOPS reports both files as encrypted, then inspect the Git diff
   and ensure new ciphertext files are tracked:

```nu
sops filestatus secrets/amp-runner-personal.env
sops filestatus secrets/amp-runner-work.env
git status --short
```

4. Validate and build before interrupting the running service. Both commands
   must succeed. Building does not activate the new configuration:

```nu
make check
nix build --impure .#nixosConfigurations.nixos.config.system.build.toplevel --no-link
```

5. Wait for active runner threads to finish and switch from a normal terminal:

```nu
make nixos HOST=nixos
```

6. Only after a successful switch, decrypt and start the two new runners:

```nu
systemctl --user restart sops-nix.service
systemctl --user restart amp-runner-personal.service amp-runner-work.service
```

7. Verify both services are active, then inspect each runner under its own CLI
   account. `amp runner list` and `amp runner dirs list` use account-scoped
   sockets: a runner belonging to another account appears missing even when
   its service is healthy. Replace `PERSONAL_EMAIL` and `WORK_EMAIL` below
   with the corresponding addresses from `amp account list`:

```nu
systemctl --user is-active amp-runner-personal.service amp-runner-work.service
amp account list
amp account switch PERSONAL_EMAIL
amp runner list
amp runner dirs list --runner-id nixos-personal
amp account switch WORK_EMAIL
amp runner list
amp runner dirs list --runner-id nixos-work
```

Switching the CLI account does not change these services' account tokens:
each is pinned by its SOPS environment file. Afterwards, select whichever
account you want for future interactive CLI commands.

Both services require successful SOPS decryption before startup. On this host,
all SOPS plaintext generations live under `$XDG_RUNTIME_DIR/secrets.d` rather
than `~/.cache`; stable symlinks live under `$XDG_RUNTIME_DIR/secrets`. Token
files have mode `0600`. The existing SSH Include path remains a symlink to its
decrypted file. Only ciphertext and runtime paths enter the Nix store.

8. Confirm `nixos-personal` appears under the personal account and `nixos-work`
   under work, with the directory lists above. Personal must include
   `~/devel/tools/dotfiles`, but no repository two levels below `~/devel/tools`.
   Check personal/playground/work still include repositories at depth 2 and
   exclude deeper ones. `dev.zeko.miracle` must appear only under work.

No token values are needed for these checks. The tokens enter the runner
processes' environment and may be inherited by their subprocesses; this setup
does not provide user isolation.

To rotate a token, edit its encrypted file, apply the configuration, restart
`sops-nix.service`, and restart the corresponding runner. Verify the new token
works before revoking the old one. Removing an age recipient does not revoke
old tokens or erase ciphertext from repository history.

## macOS Amp runners

`nix/hosts/mac-machine/default.nix` defines two Home Manager LaunchAgents with
the same directory lists as NixOS, including `~/Documents/dev.zeko.miracle`
for work. Their runner IDs are `mac-machine-personal` and `mac-machine-work`;
their launchd labels are `org.nix-community.home.amp-runner-personal` and
`org.nix-community.home.amp-runner-work`.

They use the same two encrypted account tokens. Complete
[key restoration/enrollment](#restore-or-enroll-an-age-key) and the installation
guide's directory restoration before activation. Restoring the Mac's original
authorized key needs no recipient changes; a new key needs authorized-machine
rewrapping of every applicable file.

SOPS publishes mode-`0600` dotenv files through the Mac's configured SOPS paths.
Each runner reads exactly one nonempty `AMP_API_KEY=` assignment; keep its value
unquoted, without comments or additional assignments. The value is read as
literal data, never executed as shell code. Missing or malformed credentials
stop startup instead of falling back to the interactive CLI account. launchd
retries at five-second intervals while waiting for SOPS; it does not itself
retry failed SOPS decryption.

The agents run at login and restart on exit. Unlike NixOS user lingering, they
do not run before login or after logout, and the Mac must remain awake to serve
threads. They inherit the configured user tools and 1Password SSH socket, but
not the Linux Podman socket; Docker uses the Mac's selected Docker context.
Both accounts still run as the same macOS user, and subprocesses may inherit
their runner's account token.

Build without switching:

```nu
make check
make darwin-build
```

For an already-bootstrapped Mac, run `make darwin HOST=mac-machine` from a
normal terminal when ready. For first activation use the installation guide.
Inspect the SOPS and runner jobs/logs without printing credential files:

```nu
let domain = $"gui/(id -u | str trim)"
launchctl print $"($domain)/org.nix-community.home.sops-nix"
launchctl print $"($domain)/org.nix-community.home.amp-runner-personal"
launchctl print $"($domain)/org.nix-community.home.amp-runner-work"
```

Runner logs are `~/Library/Logs/amp-runner-{personal,work}.log` and
`~/Library/Logs/amp-runner-{personal,work}.err.log`; SOPS logs are under
`~/Library/Logs/SopsNix/`. Use `amp runner list` and
`amp runner dirs list --runner-id mac-machine-personal` or `mac-machine-work`
under the corresponding CLI account, as in the NixOS verification above.
If the work runner reports permission errors for the Documents vault, check
macOS Privacy & Security permissions for the runner; terminal access does not
establish that a LaunchAgent can read the same directory.

For token rotation, wait for active threads to finish, update the encrypted
file and switch. Check that the SOPS job has finished with exit code 0 before
restarting the affected runner with `launchctl kickstart -k` and its job label.
A running runner does not reread credentials, and an existing secret file can
belong to the previous generation if decryption fails. Apply the updated token
and restart the corresponding NixOS runner too; verify both hosts before
revoking the old token.

[sops]: https://github.com/getsops/sops
[age]: https://github.com/FiloSottile/age
