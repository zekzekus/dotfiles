{ pkgs, common, ... }:

{
  enable = true;
  tmuxinator.enable = true;
  shell = "${pkgs.fish}/bin/fish";
  escapeTime = 0;
  prefix = "C-a";
  baseIndex = 0;
  mouse = true;
  terminal = "xterm-ghostty";
  keyMode = "vi";
  plugins = with pkgs.tmuxPlugins; [
    sensible
    vim-tmux-navigator
    urlview
    extrakto
    tmux-fzf
  ];
  extraConfig = ''
    set -g default-command "${pkgs.fish}/bin/fish"
    set -g visual-activity on
    setw -g pane-base-index 1
    setw -g monitor-activity on
    unbind C-b
    bind C-s send-prefix
    bind C-l send-keys 'C-l'
    bind C-h send-keys 'C-h'
    bind C-a last-window
    bind-key Escape copy-mode
    bind-key p paste-buffer
    bind-key -T copy-mode-vi 'v' send -X begin-selection
    bind-key -T copy-mode-vi 'V' send -X select-line
    bind-key -T copy-mode-vi 'r' send -X rectangle-toggle
    bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "pbcopy"
    if-shell "test -f ${common.dotfilesDir}/tmux/tmuxline.gruvbox.conf" "source ${common.dotfilesDir}/tmux/tmuxline.gruvbox.conf"
  '';
}