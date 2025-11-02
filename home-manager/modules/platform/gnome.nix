{ lib, ... }:

{
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
      overlay-key = "";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };
    "org/gnome/desktop/interface" = {
      scaling-factor = lib.hm.gvariant.mkUint32 2;
    };
    "org/gnome/shell/keybindings" = {
      toggle-overview = [ "<Super>space" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
    };
  };
}
