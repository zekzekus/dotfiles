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
              ~/.1password/agent.sock  ◄─── SSH_AUTH_SOCK
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

---

## New Machine Bootstrap

### Step 1: Clone via HTTPS

Since 1Password isn't installed yet, clone via HTTPS:

```bash
# Create directory structure
mkdir -p ~/devel/tools
cd ~/devel/tools

# Clone via HTTPS (not SSH)
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
2. Go to **Settings → Developer**
3. Check **"Use the SSH Agent"**
4. Expand **Advanced** section and configure as desired

### Step 4: Import SSH Key from 1Password

Your SSH key is already stored in 1Password. It will automatically be available via the agent.

Verify:
```bash
# Open a NEW terminal (important!)
ssh-add -l
```

You should see your key listed.

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

Your GPG keys are stored as Documents in 1Password. Import them:

#### Option A: Via 1Password CLI

```bash
# Sign in to 1Password CLI (if not already)
# On first use, you may need to enable CLI integration in 1Password Settings → Developer
eval $(op signin)

# Import GPG private key
op document get "GPG Private Key" --output - | gpg --import

# Import ownertrust
op document get "GPG Ownertrust" --output - | gpg --import-ownertrust

# Verify
gpg --list-secret-keys
```

#### Option B: Manual Export from 1Password

1. Open 1Password → find "GPG Private Key" document
2. Click **⋮** → **Save As** → save to `/tmp/gpg-private.asc`
3. Do the same for "GPG Ownertrust" → save to `/tmp/gpg-ownertrust.txt`

```bash
# Import
gpg --import /tmp/gpg-private.asc
gpg --import-ownertrust /tmp/gpg-ownertrust.txt

# Verify
gpg --list-secret-keys

# Securely delete temp files
shred -u /tmp/gpg-private.asc /tmp/gpg-ownertrust.txt
# On macOS (no shred): rm -P /tmp/gpg-private.asc /tmp/gpg-ownertrust.txt
```

### Step 8: Test GPG Signing

```bash
echo "test" | gpg --clearsign
```

---

## Existing Machine: Initial Setup

If you're setting this up on a machine that already has SSH/GPG keys:

### Add SSH Key to 1Password

1. Open **1Password**
2. Click **+ New Item** → **SSH Key**
3. Click **"Import from file"** → select `~/.ssh/id_ed25519` (or your key)

### Backup GPG Keys to 1Password

```bash
# Export private key (use your key ID)
gpg --export-secret-keys --armor YOUR_KEY_ID > /tmp/gpg-private.asc

# Export ownertrust
gpg --export-ownertrust > /tmp/gpg-ownertrust.txt
```

In 1Password:
1. Click **+ New Item** → **Document**
2. Attach `/tmp/gpg-private.asc`, title: "GPG Private Key"
3. Create another Document for `/tmp/gpg-ownertrust.txt`, title: "GPG Ownertrust"

Securely delete temp files:
```bash
# Linux
shred -u /tmp/gpg-private.asc /tmp/gpg-ownertrust.txt

# macOS
rm -P /tmp/gpg-private.asc /tmp/gpg-ownertrust.txt
```

### Clean Up Old SSH Keys (optional)

Once verified working, you can remove local SSH keys:

```bash
# Backup first
mkdir -p ~/.ssh/backup
mv ~/.ssh/id_* ~/.ssh/backup/

# Later, if everything works, delete backup
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
4. **New terminal?** Environment variables require a new shell session after `make nixos/darwin`.

### "Connection refused"

1Password isn't running. Start it and try again.

### SSH works but GPG signing fails

```bash
# Verify key is available
gpg --list-secret-keys

# Check git config
git config user.signingkey

# Test signing manually
echo "test" | gpg --clearsign
```

### "Too many authentication failures"

If you have many SSH keys in 1Password, servers may reject before trying the right key.

Configure per-host key in 1Password:
- Open key in 1Password → scroll to "Use for" section → add specific hosts

---

## Platform-Specific Notes

### macOS

- 1Password installed via Homebrew: `brew install --cask 1password`
- 1Password CLI via Homebrew: `brew install 1password-cli`
- Socket path: `~/.1password/agent.sock` (symlinked from `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`)

### NixOS

- 1Password installed via NixOS modules: `programs._1password.enable` and `programs._1password-gui.enable`
- Socket path: `~/.1password/agent.sock` (created directly by 1Password)
- Polkit integration enabled for system authentication prompts

---

## Files Changed

| File | Purpose |
|------|---------|
| `modules/programs/ssh.nix` | SSH config pointing to 1Password agent |
| `modules/programs/nushell.nix` | SSH_AUTH_SOCK for Nushell |
| `hosts/nixos/configuration.nix` | 1Password packages for NixOS |
| `hosts/mac-machine/configuration.nix` | 1Password via Homebrew for macOS |

---

## Quick Reference

| Task | Command |
|------|---------|
| List SSH keys | `ssh-add -l` |
| Test GitHub SSH | `ssh -T git@github.com` |
| List GPG keys | `gpg --list-secret-keys` |
| Test GPG signing | `echo "test" \| gpg --clearsign` |
| 1Password CLI signin | `eval $(op signin)` |
