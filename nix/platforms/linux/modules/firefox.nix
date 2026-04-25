_: {
  programs.firefox = {
    enable = false;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };
  };
}
