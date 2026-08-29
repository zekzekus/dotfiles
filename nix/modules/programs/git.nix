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
      pager.diff = "hunk pager";
      init = {
        templateDir = "${common.dotfilesDir}/git/git_template";
      };
      push = {
        default = "current";
      };
      alias = {
        ctags = "!.git/hooks/ctags";
        ctagse = "!.git/hooks/ctagse";
        diffd = "-c pager.diff=delta diff";
        difft = "-c pager.diff=less -c diff.external=difft diff";
      };
      credential."https://ampcode.com".helper = "!amp git-credential-helper";
    };
  };
}
