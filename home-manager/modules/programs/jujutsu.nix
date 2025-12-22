{ ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      ui.default-command = "log";
      user = {
        email = "zekzekus@gmail.com";
        name = "Zekeriya Koc";
      };
    };
  };
}
