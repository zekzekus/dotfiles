_: {
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
        pager = "delta";
        diff-formatter = ":git";
        log-synthetic-elided-nodes = true;
      };

      merge-tools.difft = {
        program = "difft";
        diff-args = ["--color=always" "$left" "$right"];
      };

      templates = {
        log = ''
          if(root, format_root_commit(self),
            label(if(current_working_copy, "working_copy"),
              concat(
                separate(" ",
                  format_short_change_id_with_change_offset(self),
                  label("commit_id", format_short_id(commit_id)),
                  if(empty, label("empty", "(empty)")),
                  if(description, description.first_line(), label(if(empty, "empty"), description_placeholder)),
                  bookmarks,
                  tags,
                  working_copies,
                  if(self.contained_in("first_parent(@)"), label("git_head", "HEAD")),
                  if(conflict, label("conflict", "conflict")),
                ) ++ "\n",
              ),
            ),
          )
        '';
        log_node = ''
          label("node",
            coalesce(
              if(!self, label("elided", "~")),
              if(current_working_copy, label("working_copy", "@")),
              if(conflict, label("conflict", "×")),
              if(immutable, label("immutable", "◆")),
              label("normal", "○"),
            ),
          )
        '';
        draft_commit_description = ''
          concat(
            coalesce(description, default_commit_description, "\n"),
            surround("\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\nJJ: ignore-rest\n",
            diff.git(),
          )
        '';
      };

      colors = {
        node = "bright black";
        elided = "bright black";
        immutable = "bright blue";
        working_copy = {
          bold = true;
          fg = "green";
        };
        conflict = {
          bold = true;
          fg = "red";
        };
        bookmark = "cyan";
        remote_bookmark = "bright cyan";
        git_head = {
          bold = true;
          fg = "magenta";
        };
        empty = "bright black";
        description_placeholder = "bright black";
      };

      revsets = {
        log = "present(@) | ancestors(immutable_heads().., 10) | present(trunk())";
      };

      revset-aliases = {
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
        "immutable_heads()" = "builtin_immutable_heads() | remote_bookmarks()";
        "stack()" = "descendants(trunk()) & ::@";
        "ahead_behind(x, y)" = "y..x | x..y | x | y:: | fork_point(x | y)";
      };

      git = {
        auto-local-bookmark = false;
        private-commits = "description(glob:'wip*')";
        write-change-id-header = true;
      };

      aliases = {
        difft = ["diff" "--tool" "difft"];
        tug = ["bookmark" "move" "--from" "closest_bookmark(@-)" "--to" "@-"];
        gut = ["rebase" "-d" "trunk()"];

        lstk = ["log" "-r" "stack()"];
        ltb = ["log" "-r" "ahead_behind(trunk(), @)"];

        ll = ["log" "-T" "builtin_log_compact"];
        ld = ["log" "-T" "builtin_log_detailed"];

        fetch = ["git" "fetch"];
        push = ["git" "push"];
      };
    };
  };
}
