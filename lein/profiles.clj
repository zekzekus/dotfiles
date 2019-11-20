{:user {:plugins [[cider/cider-nrepl "RELEASE"]
                  [refactor-nrepl "RELEASE"]]
        :dependencies [[cljfmt "RELEASE"]]
        :repl-options {:init (require 'cljfmt.core)}}}
