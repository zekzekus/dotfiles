{ ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "zekzekus@gmail.com";
        name = "Zekeriya Koc";
      };

      signing = {
        backend = "gpg";
        behavior = "own";
        key = "6716516470AD2D7A";
      };

      ui = {
        default-command = "log";
        diff-formatter = "difft";
        log-synthetic-elided-nodes = true;
      };

      merge-tools.difft = {
        program = "difft";
        diff-args = ["--color=always" "$left" "$right"];
      };

      revsets = {
        log = "present(@) | ancestors(immutable_heads().., 5) | present(trunk())";
      };

      # Helper revset for the "tug" alias below
      revset-aliases = {
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
        "immutable_heads()" = "builtin_immutable_heads() | remote_bookmarks()";
      };

      git = {
        auto-local-bookmark = false;
        private-commits = "description(glob:'wip*')";
      };

      aliases = {
        tug = ["bookmark" "move" "--from" "closest_bookmark(@-)" "--to" "@-"];
        gut = ["rebase" "-d" "trunk()"];
      };
    };
  };
}
