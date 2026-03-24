{common, ...}: {
  programs.git = {
    enable = true;
    signing = {
      key = common.gpgKey;
      format = "openpgp";
      signByDefault = true;
    };

    settings = {
      user.name = common.userFullName;
      user.email = common.userEmail;
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
  };
}
