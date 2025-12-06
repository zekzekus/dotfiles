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

    waybar.enable = true;
    mako.enable = true;
    vicinae.systemd = true;
    dankMaterialShell.enable = false;
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

    waybar.enable = false;
    mako.enable = false;
    vicinae.systemd = false;
    dankMaterialShell.enable = true;
  };

  # Add more shells here, e.g.:
  # ags = {
  #   launcher = "ags -t launcher";
  #   clipboard = "ags -t clipboard";
  #   ...
  # };
}
