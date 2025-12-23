{ ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      ui = {
        default-command = "log";
        diff.diff-formatter = ["difft" "--color=always" "$left" "$right"];
      };
      user = {
        email = "zekzekus@gmail.com";
        name = "Zekeriya Koc";
      };
      signing = {
        backend = "gpg";
        behavior = "own";
        key = "6716516470AD2D7A";
      };
    };
  };
}
