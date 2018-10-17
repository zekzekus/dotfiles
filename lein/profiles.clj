{:user {:plugins [[cider/cider-nrepl "0.18.0"]
                  [refactor-nrepl "2.4.0"]]
        :dependencies [[cljfmt "0.5.1"]]
        :repl-options {:init (require 'cljfmt.core)}}}
