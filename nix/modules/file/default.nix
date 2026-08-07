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
      ".config/amp/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/agents/adapters/amp/AGENTS.md";
      ".config/amp/languages/clojure.md".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/agents/adapters/amp/languages/clojure.md";
      ".config/amp/languages/python.md".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/agents/adapters/amp/languages/python.md";

      ".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/agents/adapters/claude/CLAUDE.md";
      ".claude/rules/clojure.md".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/agents/adapters/claude/rules/clojure.md";
      ".claude/rules/python.md".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/agents/adapters/claude/rules/python.md";

      ".config/opencode/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/agents/AGENTS.md";

      ".ctags".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/ctags/ctags";
      ".tmuxinator".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/tmuxinator";
      ".config/doom".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/misc/emacs/doom";

      "bin/gg".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
      "bin/gk".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
      "bin/gp".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";

      "bin/yy".source = "${common.dotfilesDir}/scripts/yaziproject.sh";
    }
    // skillLinks ".config/agents/skills"
    // skillLinks ".claude/skills"
    // skillLinks ".config/opencode/skills";
}
