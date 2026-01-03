{ pkgs, mkOutOfStoreSymlink, dotfilesDir }:

let
  mediaBinds = [
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPrev, exec, playerctl previous"
  ];
in
{
  default = {
    launcher       = "hyprlauncher";
    clipboard      = "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
    lock           = "hyprlock";
    volumeMute     = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    volumeDown     = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-";
    volumeUp       = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+";
    brightnessUp   = "brightnessctl set +5%";
    brightnessDown = "brightnessctl set 5%-";

    bindType    = "exec";
    idleLockCmd = "pidof hyprlock || hyprlock";
    extraBinds  = mediaBinds;

    packages = with pkgs; [ hyprlauncher hyprpolkitagent ];
    homeFiles = {};

    enableWaybar            = true;
    enableDankMaterialShell = false;
    enableCaelestia         = false;
    enableNoctalia          = false;

    enableCliphist  = true;
    enableMako      = true;
    enableHyprpaper = true;
    enableHypridle  = true;

    enableHyprpolkitagent    = true;
    enableHyprlauncherDaemon = true;
  };

  dms = {
    launcher       = "dms ipc spotlight toggle";
    clipboard      = "dms ipc call clipboard toggle";
    lock           = "dms ipc call lock lock";
    volumeMute     = "dms ipc call audio mute";
    volumeDown     = "dms ipc call audio decrement 3";
    volumeUp       = "dms ipc call audio increment 3";
    brightnessUp   = "dms ipc call brightnessctl increment 5";
    brightnessDown = "dms ipc call brightnessctl decrement 5";

    bindType    = "exec";
    idleLockCmd = "dms ipc call lock isLocked | grep -q true || dms ipc call lock lock";
    extraBinds  = mediaBinds;

    packages = [];
    homeFiles = {
      ".config/DankMaterialShell/settings.json".source =
        mkOutOfStoreSymlink "${dotfilesDir}/dms/settings.json";
    };

    enableWaybar            = false;
    enableDankMaterialShell = true;
    enableCaelestia         = false;
    enableNoctalia          = false;

    enableCliphist  = false;
    enableMako      = false;
    enableHyprpaper = false;
    enableHypridle  = true;

    enableHyprpolkitagent    = false;
    enableHyprlauncherDaemon = false;
  };

  caelestia = {
    launcher       = "caelestia:launcher";
    clipboard      = null;
    lock           = "caelestia:lock";
    volumeMute     = null;
    volumeDown     = null;
    volumeUp       = null;
    brightnessUp   = "caelestia:brightnessUp";
    brightnessDown = "caelestia:brightnessDown";

    bindType    = "global";
    idleLockCmd = "caelestia shell -s lock";
    extraBinds  = [
      "$mod, V, exec, pkill fuzzel || caelestia clipboard"

      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-"
      ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%+"

      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"

      "$mod SHIFT, Escape, global, caelestia:session"
      "$mod, Delete, global, caelestia:clearNotifs"
    ];

    packages = with pkgs; [ hyprpolkitagent ];
    homeFiles = {};

    enableWaybar            = false;
    enableDankMaterialShell = false;
    enableCaelestia         = true;
    enableNoctalia          = false;

    enableCliphist  = true;
    enableMako      = false;
    enableHyprpaper = false;
    enableHypridle  = true;

    enableHyprpolkitagent    = true;
    enableHyprlauncherDaemon = false;
  };

  noctalia = {
    launcher       = "noctalia-shell ipc call launcher toggle";
    clipboard      = "noctalia-shell ipc call launcher clipboard";
    lock           = "noctalia-shell ipc call lockScreen lock";
    volumeMute     = "noctalia-shell ipc call volume muteOutput";
    volumeDown     = "noctalia-shell ipc call volume decrease";
    volumeUp       = "noctalia-shell ipc call volume increase";
    brightnessUp   = "noctalia-shell ipc call brightness increase";
    brightnessDown = "noctalia-shell ipc call brightness decrease";

    bindType    = "exec";
    idleLockCmd = "noctalia-shell ipc call lockScreen lock";
    extraBinds  = [
      ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
      ", XF86AudioNext, exec, noctalia-shell ipc call media next"
      ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"

      "$mod, C, exec, noctalia-shell ipc call controlCenter toggle"
      "$mod SHIFT, S, exec, noctalia-shell ipc call settings toggle"

      "$mod SHIFT, Escape, exec, noctalia-shell ipc call sessionMenu toggle"
      "$mod, Delete, exec, noctalia-shell ipc call notifications dismissAll"
      "$mod SHIFT, Delete, exec, noctalia-shell ipc call notifications clear"

      "$mod, D, exec, noctalia-shell ipc call darkMode toggle"
      "$mod, W, exec, noctalia-shell ipc call wallpaper toggle"
    ];

    packages = with pkgs; [ hyprpolkitagent ];
    homeFiles = {};

    enableWaybar            = false;
    enableDankMaterialShell = false;
    enableCaelestia         = false;
    enableNoctalia          = true;

    enableCliphist  = true;
    enableMako      = false;
    enableHyprpaper = false;
    enableHypridle  = true;

    enableHyprpolkitagent    = true;
    enableHyprlauncherDaemon = false;
  };
}
