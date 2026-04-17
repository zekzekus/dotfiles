_: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "kanagawa";
      editor = {
        color-modes = true;
        bufferline = "multiple";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        statusline = {
          left = [ "mode" "version-control" "spacer" "spinner" ];
          center = [ "file-name" "read-only-indicator" "file-modification-indicator" ];
          right = [ "diagnostics" "workspace-diagnostics" "separator" "file-type" "separator" "position" "position-percentage" ];
          separator = "│";
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
      };
      keys.normal = {
        esc = [ "collapse_selection" "keep_primary_selection" ];
        space.q.q = ":quit";
        space.w = ":write";
      };
    };
  };
}
