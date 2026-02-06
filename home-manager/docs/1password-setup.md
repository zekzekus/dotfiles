# 1Password SSH & GPG Setup Guide

This setup uses **1Password SSH Agent** for SSH key management while keeping **GPG signing** with your existing GPG keys.

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                    1Password SSH Agent                       │
│            (private keys never leave 1Password)              │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
              ~/.1password/agent.sock  ◄── SSH_AUTH_SOCK
                            │
            ┌───────────────┼───────────────┐
            │               │               │
            ▼               ▼               ▼
          git            ssh           other tools
            │
            ▼
    GPG Signing (separate)
    uses ~/.gnupg keys
```

### Implementation

The 1Password SSH integration is managed declaratively via two modules:

- **`modules/programs/ssh.nix`** -- Configures SSH to use the 1Password agent socket, sets `SSH_AUTH_SOCK`, and handles platform-specific socket paths:
  - **macOS**: Symlinks from `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock` to `~/.1password/agent.sock`
  - **Linux**: Creates `~/.1password/` directory; 1Password writes the socket directly. Also sets up a systemd user service to autostart 1Password.

- **`modules/programs/nushell.nix`** -- Sets `SSH_AUTH_SOCK` in Nushell's environment (Nushell requires separate env var configuration).

### 1Password Installation

- **macOS**: Installed via Homebrew casks in `hosts/mac-machine/configuration.nix` (`1password`, `1password-cli`)
- **NixOS**: Installed via NixOS modules in `hosts/nixos/configuration.nix` (`programs._1password.enable`, `programs._1password-gui.enable` with polkit)

---

## New Machine Bootstrap

### Step 1: Clone via HTTPS

Since 1Password isn't installed yet, clone via HTTPS:

```bash
mkdir -p ~/devel/tools
cd ~/devel/tools
git clone https://github.com/zekzekus/dotfiles
cd dotfiles
```

### Step 2: First Build

```bash
# NixOS
make nixos

# macOS
make darwin
```

This installs:
- **NixOS**: 1Password GUI + CLI via `programs._1password` and `programs._1password-gui`
- **macOS**: 1Password via Homebrew cask + 1password-cli via brew formula

### Step 3: Configure 1Password SSH Agent

1. **Open 1Password** and sign in to your account
2. Go to **Settings > Developer**
3. Check **"Use the SSH Agent"**
4. Expand **Advanced** section and configure as desired

### Step 4: Verify SSH Key

Your SSH key stored in 1Password will automatically be available via the agent.

```bash
# Open a NEW terminal (important for env vars to take effect)
ssh-add -l
```

### Step 5: Test SSH

```bash
ssh -T git@github.com
```

Expected output: `Hi zekzekus! You've successfully authenticated...`

### Step 6: Switch Git Remote to SSH (optional)

```bash
cd ~/devel/tools/dotfiles
git remote set-url origin git@github.com:zekzekus/dotfiles.git
```

### Step 7: Import GPG Keys

GPG keys are stored as Documents in 1Password. Import them:

#### Option A: Via 1Password CLI

```bash
eval $(op signin)

# Import GPG private key
op document get "GPG Private Key" --output - | gpg --import

# Import ownertrust
op document get "GPG Ownertrust" --output - | gpg --import-ownertrust

# Verify
gpg --list-secret-keys
```

#### Option B: Manual Export from 1Password

1. Open 1Password, find "GPG Private Key" document
2. Save to `/tmp/gpg-private.asc`
3. Do the same for "GPG Ownertrust" to `/tmp/gpg-ownertrust.txt`

```bash
gpg --import /tmp/gpg-private.asc
gpg --import-ownertrust /tmp/gpg-ownertrust.txt

gpg --list-secret-keys

# Securely delete temp files
shred -u /tmp/gpg-private.asc /tmp/gpg-ownertrust.txt
# On macOS (no shred): rm -P /tmp/gpg-private.asc /tmp/gpg-ownertrust.txt
```

### Step 8: Test GPG Signing

```bash
echo "test" | gpg --clearsign
```

Git is configured to sign commits by default using key `6716516470AD2D7A` (see `modules/programs/git.nix`).

---

## Existing Machine: Initial Setup

If you're setting this up on a machine that already has SSH/GPG keys:

### Add SSH Key to 1Password

1. Open **1Password**
2. Click **+ New Item** > **SSH Key**
3. Click **"Import from file"** > select `~/.ssh/id_ed25519` (or your key)

### Backup GPG Keys to 1Password

```bash
gpg --export-secret-keys --armor YOUR_KEY_ID > /tmp/gpg-private.asc
gpg --export-ownertrust > /tmp/gpg-ownertrust.txt
```

In 1Password:
1. **+ New Item** > **Document**, attach `/tmp/gpg-private.asc`, title: "GPG Private Key"
2. Create another Document for `/tmp/gpg-ownertrust.txt`, title: "GPG Ownertrust"

Securely delete temp files:
```bash
# Linux
shred -u /tmp/gpg-private.asc /tmp/gpg-ownertrust.txt

# macOS
rm -P /tmp/gpg-private.asc /tmp/gpg-ownertrust.txt
```

### Clean Up Old SSH Keys (optional)

Once verified working:

```bash
mkdir -p ~/.ssh/backup
mv ~/.ssh/id_* ~/.ssh/backup/

# Later, if everything works
rm -rf ~/.ssh/backup
```

---

## Troubleshooting

### "Could not open a connection to your authentication agent"

1. **Is 1Password running?** The SSH agent only works when 1Password is open.
2. **Is SSH_AUTH_SOCK set?** 
   ```bash
   echo $SSH_AUTH_SOCK
   # Should be: ~/.1password/agent.sock
   ```
3. **Is the socket there?**
   ```bash
   ls -la ~/.1password/agent.sock
   ```
4. **New terminal?** Environment variables require a new shell session after `make nixos`/`make darwin`.

### "Connection refused"

1Password isn't running. Start it and try again.

### SSH works but GPG signing fails

```bash
gpg --list-secret-keys
git config user.signingkey
echo "test" | gpg --clearsign
```

### "Too many authentication failures"

If you have many SSH keys in 1Password, servers may reject before trying the right key. Configure per-host key in 1Password: open key > scroll to "Use for" section > add specific hosts.

---

## Files Changed

| File | Purpose |
|------|---------|
| `modules/programs/ssh.nix` | SSH config, 1Password agent socket, activation scripts, Linux autostart service |
| `modules/programs/nushell.nix` | `SSH_AUTH_SOCK` for Nushell environment |
| `modules/programs/gpg.nix` | GPG agent configuration |
| `modules/programs/git.nix` | Git commit signing (`signByDefault = true`, key ID) |
| `hosts/nixos/configuration.nix` | 1Password packages for NixOS (`_1password`, `_1password-gui` with polkit) |
| `hosts/mac-machine/configuration.nix` | 1Password via Homebrew casks for macOS |

---

## Quick Reference

| Task | Command |
|------|---------|
| List SSH keys | `ssh-add -l` |
| Test GitHub SSH | `ssh -T git@github.com` |
| List GPG keys | `gpg --list-secret-keys` |
| Test GPG signing | `echo "test" \| gpg --clearsign` |
| 1Password CLI signin | `eval $(op signin)` |
