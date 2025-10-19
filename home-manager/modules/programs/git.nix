{ common, ... }:

{
  enable = true;
  signing.key = "6716516470AD2D7A";
  signing.signByDefault = false;

  settings = {
    user.name = "Zekeriya Koc";
    user.email = "zekzekus@gmail.com";
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
