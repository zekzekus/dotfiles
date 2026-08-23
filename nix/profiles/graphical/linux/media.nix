{pkgs, ...}: {
  home.packages = with pkgs; [
    haruna
    loupe
    papers
  ];
}
