{
  default = {
    launcher = "hyprlauncher";
    clipboard = "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
    lock = "hyprlock";
    volumeMute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    volumeDown = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-";
    volumeUp = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+";
    brightnessUp = "brightnessctl set +5%";
    brightnessDown = "brightnessctl set 5%-";

    bindType = "exec";

    idleLockCmd = "pidof hyprlock || hyprlock";

    waybar.enable = true;
    mako.enable = true;
    hyprlauncher.enable = true;
    hyprpaper.enable = true;
    dankMaterialShell.enable = false;
    caelestia.enable = false;
    noctalia.enable = false;

    hyprpolkitagent.enable = true;
    cliphist.enable = true;
    hypridle.enable = true;
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

    idleLockCmd = "dms ipc call lock isLocked | grep -q true || dms ipc call lock lock";

    waybar.enable = false;
    mako.enable = false;
    hyprlauncher.enable = false;
    hyprpaper.enable = false;
    dankMaterialShell.enable = true;
    caelestia.enable = false;
    noctalia.enable = false;

    hyprpolkitagent.enable = false;
    cliphist.enable = false;
    hypridle.enable = true;
  };

  caelestia = {
    launcher = "caelestia:launcher";
    clipboard = null;
    lock = "caelestia:lock";
    volumeMute = null;
    volumeDown = null;
    volumeUp = null;
    brightnessUp = "caelestia:brightnessUp";
    brightnessDown = "caelestia:brightnessDown";

    bindType = "global";

    idleLockCmd = "caelestia shell -s lock";

    waybar.enable = false;
    mako.enable = false;
    hyprlauncher.enable = false;
    hyprpaper.enable = false;
    dankMaterialShell.enable = false;
    caelestia.enable = true;
    noctalia.enable = false;

    hyprpolkitagent.enable = true;
    cliphist.enable = true;
    hypridle.enable = true;
  };

  noctalia = {
    launcher = "noctalia-shell ipc call launcher toggle";
    clipboard = "noctalia-shell ipc call launcher clipboard";
    lock = "noctalia-shell ipc call lockScreen lock";
    volumeMute = "noctalia-shell ipc call volume muteOutput";
    volumeDown = "noctalia-shell ipc call volume decrease";
    volumeUp = "noctalia-shell ipc call volume increase";
    brightnessUp = "noctalia-shell ipc call brightness increase";
    brightnessDown = "noctalia-shell ipc call brightness decrease";

    bindType = "exec";

    idleLockCmd = "noctalia-shell ipc call lockScreen lock";

    waybar.enable = false;
    mako.enable = false;
    hyprlauncher.enable = false;
    hyprpaper.enable = false;
    dankMaterialShell.enable = false;
    caelestia.enable = false;
    noctalia.enable = true;

    hyprpolkitagent.enable = true;
    cliphist.enable = true;
    hypridle.enable = true;
  };
}
