# 1Password SSH and GPG Restoration

Use the [installation and recovery guide](../README.md) for prerequisites,
cloning, age recovery **before activation**, and first system activation. Return
here after activation and a fresh login. This is not an alternative first-build
sequence. Examples use Nushell.

## How it works

1Password's graphical app holds SSH keys and serves them through
`~/.1password/agent.sock`. GPG signing is separate: it uses keys restored into
`~/.gnupg`. The private age key used by SOPS is a third, independent credential;
see [age recovery](sops-setup.md#restore-or-enroll-an-age-key).

| Configuration (under `nix/`) | Responsibility |
| --- | --- |
| `modules/programs/ssh.nix` | SSH config and stable socket path (macOS links the real Group Containers socket) |
| `profiles/graphical/default.nix` | `SSH_AUTH_SOCK` and `IdentityAgent`; headless hosts do not select this agent |
| `profiles/graphical/linux/default.nix` | 1Password GUI autostart on Linux |
| `modules/programs/nushell.nix` | Home Manager session-environment loader |
| `modules/programs/gpg.nix`, `git.nix` | GPG agent and signing by default with key `6716516470AD2D7A` |
| `hosts/nixos/configuration.nix` | NixOS 1Password CLI/GUI and polkit integration |
| `platforms/darwin/configuration.nix` | macOS 1Password app/CLI through Homebrew |

## Account and key restoration

### 1. Sign in and enable the SSH agent

Open 1Password and sign in with your account/recovery and 2FA material. In
**Settings → Developer**, enable **Use the SSH Agent**. Restore/import the SSH
key item if it is not already in your vault. File-based SSH keys referenced by
the encrypted hosts config must be restored separately; the agent does not
recover those files.

For fewer prompts, set **Ask approval for each new** to **Application**.
**Remember key approval** supports 4, 12, or 24 hours; **Until 1Password quits**
can retain approval across days while the app stays running. A locked vault
still needs unlocking. These settings are managed in the app, not Nix.

Open a fresh login/terminal to pick up managed environment changes, then:

```nu
ssh-add -l
ssh -T git@github.com
```

For the intended account, GitHub should say `Hi zekzekus! You've successfully
authenticated...`. This test normally exits with status 1 because GitHub offers
no interactive shell; judge the message, not just the exit status.

Switching the repository remote to SSH is optional; HTTPS remains valid:

```nu
git remote set-url origin git@github.com:zekzekus/dotfiles.git
```

### 2. Restore GPG private key and ownertrust

Enable 1Password's CLI app integration, unlock the app, and verify `op whoami`
before importing (see [CLI setup](https://developer.1password.com/docs/cli/get-started/)).
The Documents below must be your actual backups; use their unique item IDs if
titles are ambiguous. Prefer streaming to avoid plaintext export files:

```nu
op whoami
op document get "GPG Private Key" | gpg --import
op document get "GPG Ownertrust" | gpg --import-ownertrust
gpg --list-secret-keys
```

Stop on an error and confirm the expected secret signing key is present. Do
not paste private keys into commands, chat, or logs.

If CLI integration is unavailable, download those two Documents into a private
directory (mode `0700`) on encrypted local storage. Import each with
`gpg --import <private-key-file>` and
`gpg --import-ownertrust <ownertrust-file>`, then remove only those temporary
exports after verification. Deletion (including `shred` or `rm -P`) does not
guarantee erasure on SSDs, snapshots, or copy-on-write filesystems. Never put
exports in the repository or a shared `/tmp` path; retain the secure backups.

### 3. Test the configured signing key

```nu
git config user.signingkey
echo "test" | gpg --local-user 6716516470AD2D7A --clearsign
```

The first command should identify `6716516470AD2D7A`; the second must produce a
signed message with that key. A successful rebuild alone cannot prove signing.
GPG's passphrase cache has three-day idle and maximum lifetimes (259200 seconds);
agent restart/reboot clears it sooner. During that window, processes running as
your user can sign without another prompt. Desktop Linux uses Qt pinentry and
needs a reachable graphical session; headless Linux uses terminal pinentry;
macOS uses native pinentry.

Return to the [readiness checklist](../README.md#5-accounts-login-and-readiness)
for services, permissions, and application/data restoration.

## Preparing backups on an existing machine

To move an existing SSH key into 1Password, use **New Item → SSH Key → Import
from file**. Verify the agent works before retiring its original file; do not
bulk-move or delete `~/.ssh/id_*` without identifying their consumers and keeping
verified backups.

After authenticating `op`, stream GPG exports into new Documents. Choose unique
titles or deliberately update existing items; do not create ambiguous copies:

```nu
gpg --export-secret-keys --armor 6716516470AD2D7A | op document create - --title "GPG Private Key"
gpg --export-ownertrust | op document create - --title "GPG Ownertrust"
```

Verify the intended key was exported and that both Documents can be imported
on a trusted recovery machine before retiring any original key. Keep password
manager recovery access and the separate age backup independent of one device.

## Troubleshooting

### Agent unavailable or connection refused

Confirm 1Password is running/unlocked and its SSH agent is enabled. In a fresh
managed graphical session, inspect the socket path, not key contents:

```nu
$env.SSH_AUTH_SOCK
ls -l ~/.1password/agent.sock
ssh-add -l
```

The environment should select `~/.1password/agent.sock`. Headless hosts do not
have this graphical-agent contract; configure appropriate SSH authentication
for them rather than assuming a GUI exists.

### SSH succeeds but signing fails

List secret keys and repeat the explicit signing test above. Check that pinentry
can reach the terminal/desktop and that the correct private key was restored;
SSH-agent success says nothing about GPG recovery.

### Too many authentication failures

Limit which SSH key is offered for the destination using per-host SSH/1Password
configuration. File-based PEM hosts should use `IdentitiesOnly yes` and
`IdentityAgent none` as described in [SOPS host editing](sops-setup.md#add-or-edit-a-host).
