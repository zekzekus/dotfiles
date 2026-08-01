{
  config,
  lib,
  common,
  ...
}: let
  skillNames =
    builtins.attrNames
    (lib.filterAttrs
      (_: type: type == "directory")
      (builtins.readDir ../../../agents/skills));

  skillLinks = destination:
    builtins.listToAttrs
    (map (name: {
        name = "${destination}/${name}";
        value.source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/agents/skills/${name}";
      })
      skillNames);
in {
  home.file =
    {
      ".config/amp/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/agents/AGENTS.md";
      ".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/agents/AGENTS.md";

      ".ctags".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/ctags/ctags";
      ".tmuxinator".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/tmuxinator";
      ".config/doom".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/misc/emacs/doom";

      "bin/gg".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
      "bin/gk".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
      "bin/gp".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";

      "bin/yy".source = "${common.dotfilesDir}/scripts/yaziproject.sh";
    }
    // skillLinks ".config/agents/skills"
    // skillLinks ".claude/skills";
}
