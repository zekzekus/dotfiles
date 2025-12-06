{
  default = {
    launcher = "$launcher";
    clipboard = "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
    lock = "hyprlock";
    volumeMute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    volumeDown = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-";
    volumeUp = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+";
    brightnessUp = "brightnessctl set +5%";
    brightnessDown = "brightnessctl set 5%-";

    # Use "exec" bind type for direct commands
    bindType = "exec";

    waybar.enable = true;
    mako.enable = true;
    vicinae.systemd = true;
    hyprpaper.enable = true;
    dankMaterialShell.enable = false;
    caelestia.enable = false;
    noctalia.enable = false;
  };

  dms = {
    launcher = "dms ipc spotlight toggle";
    clipboard = "dms ipc call clipboard toggle";
    lock = "dms ipc call lock lock";
    volumeMute = "dms ipc call audio mute";
    volumeDown = "dms ipc call audio decrement 3";
    volumeUp = "dms ipc call audio increment 3";
    brightnessUp = "dms ipc call brightnessctl increment 5";
    brightnessDown = "dms ipc call brightnessctl decrement 5";

    bindType = "exec";

    waybar.enable = false;
    mako.enable = false;
    vicinae.systemd = false;
    hyprpaper.enable = true;
    dankMaterialShell.enable = true;
    caelestia.enable = false;
    noctalia.enable = false;
  };

  caelestia = {
    # Caelestia uses Hyprland global shortcuts instead of exec commands
    launcher = "caelestia:launcher";
    clipboard = null; # handled via Super+V -> caelestia clipboard command
    lock = "caelestia:lock";
    volumeMute = null; # uses wpctl directly
    volumeDown = null;
    volumeUp = null;
    brightnessUp = "caelestia:brightnessUp";
    brightnessDown = "caelestia:brightnessDown";

    # Use "global" bind type for Hyprland global shortcuts
    bindType = "global";

    waybar.enable = false;
    mako.enable = false;
    vicinae.systemd = false;
    hyprpaper.enable = false; # caelestia manages wallpapers
    dankMaterialShell.enable = false;
    caelestia.enable = true;
    noctalia.enable = false;
  };

  noctalia = {
    # Noctalia uses IPC commands via noctalia-shell
    launcher = "noctalia-shell ipc call launcher toggle";
    clipboard = "noctalia-shell ipc call launcher clipboard";
    lock = "noctalia-shell ipc call lockScreen lock";
    volumeMute = "noctalia-shell ipc call volume muteOutput";
    volumeDown = "noctalia-shell ipc call volume decrease";
    volumeUp = "noctalia-shell ipc call volume increase";
    brightnessUp = "noctalia-shell ipc call brightness increase";
    brightnessDown = "noctalia-shell ipc call brightness decrease";

    bindType = "exec";

    waybar.enable = false;
    mako.enable = false;
    vicinae.systemd = false;
    hyprpaper.enable = false; # noctalia manages wallpapers
    dankMaterialShell.enable = false;
    caelestia.enable = false;
    noctalia.enable = true;
  };
}
