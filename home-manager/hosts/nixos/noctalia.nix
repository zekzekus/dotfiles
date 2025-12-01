{ ... }:

{
  services.noctalia-shell = {
    enable = true;
    target = "hyprland-session.target";
  };
}
