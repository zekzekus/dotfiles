{:repl {:plugins [[cider/cider-nrepl "0.18.0-snapshot"]]
        :dependencies [[cljfmt "0.5.1"]]
        :repl-options {:init (require 'cljfmt.core)}}}
