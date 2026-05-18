{
  pkgs,
  practicalli-clojure-cli-config,
  ...
}: let
  # nrepl >= 1.3 passes a non-string port to rebel-readline.main, which
  # crashes inside tools.cli (Integer cannot be cast to CharSequence).
  # Pin nrepl to 1.2.0 only inside Practicalli's rebel-launching aliases.
  patched-deps = pkgs.runCommand "practicalli-deps-patched" {} ''
    cp ${practicalli-clojure-cli-config}/deps.edn $out
    chmod u+w $out
    ${pkgs.gnused}/bin/sed -i -E '
      /^[[:space:]]*:repl\/(rebel|reloaded)[[:space:]]*$/,/^[[:space:]]*$/ {
        s|nrepl/nrepl[[:space:]]+\{:mvn/version "1\.7\.0"\}|nrepl/nrepl {:mvn/version "1.2.0"}|
      }
    ' $out
  '';
in {
  home.packages = with pkgs; [
    clojure
    clojure-lsp
  ];

  xdg.configFile = {
    "clojure/deps.edn".source = patched-deps;
    "clojure/rebel_readline.edn".source = "${practicalli-clojure-cli-config}/rebel_readline.edn";
    "clojure/.cljstyle".source = "${practicalli-clojure-cli-config}/.cljstyle";
  };
}
