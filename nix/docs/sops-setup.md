# sops-nix: encrypted SSH host definitions

SSH host definitions (hostname/IP, user, key path) are kept out of the repo in
plaintext. They live in `secrets/ssh-config`, encrypted with [sops] using [age]
keys, committed to git, and decrypted on each machine at Home Manager activation
into `~/.ssh/config.d/hosts`, which the managed `~/.ssh/config` pulls in via
`Include`.

The actual private keys (`.pem`/`.key`) are **never** in this repo or in sops —
you place them on each machine manually (e.g. `~/.ssh/keys/<host>.pem`,
`chmod 600`). sops only protects the *config metadata* in git.

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

[sops]: https://github.com/getsops/sops
[age]: https://github.com/FiloSottile/age
