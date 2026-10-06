# sops-nix: encrypted secrets

SSH host definitions (hostname/IP, user, key path) are kept out of the repo in
plaintext. They live in `secrets/ssh-config`, encrypted with [sops] using [age]
keys, committed to git, and decrypted on each machine at Home Manager activation
into `~/.ssh/config.d/hosts`, which the managed `~/.ssh/config` pulls in via
`Include`.

The actual private keys (`.pem`/`.key`) are **never** in this repo or in sops —
you place them on each machine manually (e.g. `~/.ssh/keys/<host>.pem`,
`chmod 600`). For SSH, sops only protects the *config metadata* in git.
The NixOS Amp runners also use sops for their account access tokens, described
below.

## How it is wired

- `flake.nix` — `sops-nix` flake input.
- `nix/lib.nix` — adds `sops-nix.homeManagerModules.sops` to the base layer, so
  every host gets the `sops` module.
- `nix/modules/programs/ssh.nix` — defines the `ssh-hosts` secret and the
  `Include`. Both are gated on `secrets/ssh-config` existing, so the repo
  evaluates cleanly before the secret is first created.
- `.sops.yaml` — lists the age recipients (one per machine) a secret is
  encrypted for.

## One-time bootstrap, per machine

`sops` and `age` ship in `home.packages`, but on a machine that has not switched
yet, grab them temporarily:

```bash
nix shell nixpkgs#age nixpkgs#sops
```

1. **Generate this machine's age key** (private key stays local, never committed):

   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   ```

   Back up this key — losing it on every machine means the secret cannot be
   decrypted. Storing a copy in 1Password is a good idea.

2. **Print its public key** and add it to `.sops.yaml` under `keys:` (and to the
   `creation_rules` key group):

   ```bash
   age-keygen -y ~/.config/sops/age/keys.txt   # prints age1...
   ```

3. **Re-encrypt** the secret for the updated recipient set (skip on the very
   first machine, which instead does step 4 to create it):

   ```bash
   sops updatekeys secrets/ssh-config
   ```

## Add or edit a host

```bash
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

`IdentitiesOnly yes` + `IdentityAgent none` matter: the global `Host *` block
routes auth through the 1Password agent, which will not hold a manually-placed
PEM, so these two lines make SSH use the file instead.

## Apply

```bash
git add secrets/ssh-config .sops.yaml   # flakes only see git-tracked files
make check                              # validates evaluation
make darwin                             # or `make home` / `make nixos`
```

Then place the PEM (`~/.ssh/keys/myhost.pem`, `chmod 600`) and test: `ssh myhost`.

## Adding a new machine later

Run the bootstrap (generate key → add public key to `.sops.yaml` →
`sops updatekeys secrets/ssh-config` → commit) on the new machine. Until its
public key is a recipient, that machine cannot decrypt the secret.

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
plaintext. `.sops.yaml` encrypts these files only for this NixOS machine's age
key. Keep a secure backup of that private key, such as in a password manager.

The encrypted files are intentionally not supplied with placeholder tokens.
Until each exists, its service cannot start. A missing environment file or
empty token fails startup rather than falling back to the CLI's selected account.

### Apply and verify

3. Check that SOPS reports both files as encrypted, then ensure both appear in
   `jj status` (which snapshots new files in this repository):

```nu
sops filestatus secrets/amp-runner-personal.env
sops filestatus secrets/amp-runner-work.env
jj status
```

4. Validate and build before interrupting the running service. Both commands
   must succeed. Building does not activate the new configuration:

```nu
make check
nix build --impure .#nixosConfigurations.nixos.config.system.build.toplevel --no-link
```

5. Wait for active runner threads to finish. Stop the old service and switch:

```nu
systemctl --user stop amp-runner.service
make nixos
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

[sops]: https://github.com/getsops/sops
[age]: https://github.com/FiloSottile/age
