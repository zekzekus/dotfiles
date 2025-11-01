# Hyprland Setup

## Installation

1. Rebuild your NixOS system:
```bash
sudo nixos-rebuild switch --flake ~/devel/tools/dotfiles/home-manager#nixos
```

2. Reboot or logout

3. At the GDM login screen, click the gear icon and select "Hyprland" instead of "GNOME"

## Key Bindings

- `Super + Return` - Open terminal (Ghostty)
- `Super + Space` - Application launcher (Rofi)
- `Super + Q` - Close active window
- `Super + M` - Exit Hyprland
- `Super + E` - File manager (Nautilus)
- `Super + V` - Toggle floating mode
- `Super + P` - Pseudo tiling
- `Super + J` - Toggle split

### Navigation
- `Super + h/j/k/l` - Move focus (vim keys)
- `Super + 1-9` - Switch to workspace
- `Super + Shift + 1-9` - Move window to workspace
- `Super + S` - Toggle special workspace
- `Super + Mouse Wheel` - Switch workspaces

### Mouse
- `Super + Left Mouse` - Move window
- `Super + Right Mouse` - Resize window

## Tools Included

- **Waybar** - Status bar
- **Rofi** - Application launcher
- **Mako** - Notification daemon
- **Hyprpaper** - Wallpaper manager
- **Hyprshot** - Screenshot tool
- **Cliphist** - Clipboard manager
- **NetworkManager Applet** - Network management
- **Pavucontrol** - Audio control

## Customization

Configuration files:
- Hyprland: `~/.config/hypr/hyprland.conf` (managed by home-manager)
- Waybar: `~/.config/waybar/config` (managed by home-manager)
- Wallpaper: Place your wallpaper at `~/.config/wallpaper.png`

Edit `home-manager/modules/programs/hyprland.nix` to customize settings.

## Switching Between GNOME and Hyprland

Both desktop environments are installed. At login:
1. Select your username
2. Click the gear icon (⚙️) at the bottom right
3. Choose either "GNOME" or "Hyprland"

Your choice will be remembered for future logins.
