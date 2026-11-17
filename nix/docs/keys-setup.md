# SSH and GPG Key Restoration

Use the [installation and recovery guide](../README.md) for prerequisites,
cloning, age recovery **before activation**, and first system activation. Return
here after activation and a fresh login. This is not an alternative first-build
sequence. Examples use Nushell.

## How it works

Every machine uses the same SSH key and GPG signing key. 1Password holds the
backups and is used **once per machine** to copy them out; daily use never
touches it:

- **SSH**: the key lives in `~/.ssh/id_<type>` with a passphrase. On Linux, Home
  Manager runs the OpenSSH agent as a user service; on macOS, the system agent
  is used. `AddKeysToAgent yes` loads the key on first use, so the passphrase is
  asked once per login. On macOS, `UseKeychain yes` stores it in the login
  Keychain, so it is not asked again after reboots.
- **GPG**: the signing key is imported into `~/.gnupg`. gpg-agent caches its
  passphrase for up to three days (259200 seconds; an agent restart or reboot
  clears it sooner). On macOS, pinentry's **Save in Keychain** checkbox removes
  later prompts.

The private age key used by SOPS is a third, independent credential; see
[age recovery](sops-setup.md#restore-or-enroll-an-age-key).

| Configuration | Responsibility |
| --- | --- |
| `nix/modules/programs/ssh.nix` | SSH config, Linux OpenSSH agent, macOS Keychain |
| `nix/profiles/wayland/system.nix` | Disables GCR's competing SSH agent on NixOS desktops |
| `nix/modules/programs/gpg.nix`, `git.nix` | gpg-agent and signing by default with key `6716516470AD2D7A` |
| `scripts/restore-keys` (`make keys`) | One-time copy of both keys from 1Password |
| `nix/hosts/nixos/configuration.nix`, `nix/platforms/darwin/configuration.nix` | 1Password app and CLI |

## Restore keys on a new machine

Requires the 1Password CLI (`op`); headless hosts without it can copy
`~/.ssh/id_*` over from a trusted machine instead. Run from the checkout:

```nu
make keys
```

The script signs `op` in if needed: through desktop app integration, or in the
terminal otherwise. It then:

1. Copies the 1Password **SSH Key** item to `~/.ssh/id_<type>` (mode `0600`,
   with its `.pub` beside it). If the vault has several SSH Key items, it
   lists them and stops; rerun with `make keys SSH_ITEM=<ID>`. The exported key
   has no passphrase, so the script asks you to choose one and installs nothing
   without it.
2. Streams the **GPG Private Key** and **GPG Ownertrust** Documents into
   `gpg --import` and `gpg --import-ownertrust` for git's configured signing
   key. Set `GPG_KEY_DOCUMENT` / `GPG_TRUST_DOCUMENT` to item IDs when titles
   are ambiguous.

Existing keys are skipped; a different key already at the target path stops
the script. Rerunning is safe.

Then test both in a fresh terminal:

```nu
ssh -T git@github.com
echo "test" | gpg --local-user 6716516470AD2D7A --clearsign
```

GitHub should say `Hi zekzekus! You've successfully authenticated...`. The
command normally exits with status 1 because GitHub offers no shell; judge the
message. `ssh-add -l` afterwards lists the loaded key. The signing test must
produce a signed message; a successful rebuild alone cannot prove signing.

File-based SSH keys referenced by the encrypted hosts config are separate;
restore them as described in [SOPS host editing](sops-setup.md#add-or-edit-a-host).
If the 1Password app's **Use the SSH Agent** setting is still on, turn it off;
nothing uses its socket anymore.

## Preparing backups on an existing machine

To back up an existing SSH key, use 1Password's **New Item → SSH Key → Import
from file**. After authenticating `op`, stream GPG exports into new Documents.
Choose unique titles or deliberately update existing items; do not create
ambiguous copies:

```nu
gpg --export-secret-keys --armor 6716516470AD2D7A | op document create - --title "GPG Private Key"
gpg --export-ownertrust | op document create - --title "GPG Ownertrust"
```

Verify that `make keys` can restore both on a trusted recovery machine before
retiring any original key. Keep password manager recovery access and the
separate age backup independent of one device.

## Troubleshooting

### Agent unavailable

On Linux, check the managed agent and the socket in a fresh login:

```nu
systemctl --user status ssh-agent
$env.SSH_AUTH_SOCK
ssh-add -l
```

`SSH_AUTH_SOCK` should be `$XDG_RUNTIME_DIR/ssh-agent`, unless the session
came in over SSH with agent forwarding, which is kept. On macOS it points at the
launchd-managed system agent.

### Asked for the SSH passphrase every time

Check that `ssh-add -l` lists the key after the first use. If it does not,
`SSH_AUTH_SOCK` points at a different or dead agent; open a fresh login. To load
the key up front, run `ssh-add` (on macOS, `ssh-add --apple-use-keychain`).

### SSH succeeds but signing fails

List secret keys and repeat the signing test above. Check that pinentry can
reach the terminal or desktop. Desktop Linux uses Qt pinentry and needs a
reachable graphical session; headless Linux uses terminal pinentry; macOS uses
native pinentry.

### Too many authentication failures

Limit which SSH key is offered for the destination in its host block. File-based
PEM hosts should use `IdentitiesOnly yes` as described in
[SOPS host editing](sops-setup.md#add-or-edit-a-host).
