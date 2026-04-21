_: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "neobones";
      editor = {
        color-modes = true;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        statusline = {
          left = ["mode" "spacer" "version-control" "spacer" "spinner"];
          center = ["file-name" "read-only-indicator" "file-modification-indicator"];
          right = ["diagnostics" "workspace-diagnostics" "separator" "file-type" "separator" "position" "position-percentage"];
          separator = "│";
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
      };
      keys.normal = {
        esc = ["collapse_selection" "keep_primary_selection"];
      };
    };
    themes = import ./helix/themes.nix;
  };
}
