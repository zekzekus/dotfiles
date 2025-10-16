{ common, ... }:

{
  enable = true;
  userName = "Zekeriya Koc";
  userEmail = "zekzekus@gmail.com";
  signing.key = "6716516470AD2D7A";
  signing.signByDefault = false;
  delta = {
    enable = true;
    options = {
      navigate = true;
      light = false;
    };
  };

  extraConfig = {
    core = {
      excludesFile = "${common.dotfilesDir}/git/gitignore_global";
    };
    init = {
      templateDir = "${common.dotfilesDir}/git/git_template";
    };
    push = {
      default = "current";
    };
  };
}
