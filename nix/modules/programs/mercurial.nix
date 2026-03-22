{common, ...}: {
  programs.mercurial = {
    enable = true;
    inherit (common) userEmail;
    userName = common.userFullName;
  };
}
