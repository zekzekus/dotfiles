{
  pkgs,
  practicalli-clojure-cli-config,
  ...
}: {
  home.packages = with pkgs; [
    clojure
    clojure-lsp
  ];

  xdg.configFile = {
    "clojure/deps.edn".source = "${practicalli-clojure-cli-config}/deps.edn";
    "clojure/rebel_readline.edn".source = "${practicalli-clojure-cli-config}/rebel_readline.edn";
    "clojure/.cljstyle".source = "${practicalli-clojure-cli-config}/.cljstyle";
  };
}
