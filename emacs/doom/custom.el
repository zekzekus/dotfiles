(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(neuron-default-tags '("stub"))
 '(neuron-default-zettelkasten-directory "/Users/zekus/zettelkasten")
 '(neuron-tag-specific-title-faces '(("stub" neuron-stub-face)))
 '(safe-local-variable-values
   '((cider-cljs-repl-types
      (edge "(do (require 'dev-extras) ((resolve 'dev-extras/cljs-repl)))"))
     (cider-default-cljs-repl . edge)
     (cider-clojure-cli-global-options . "-A:dev:build:dev/build")
     (cider-clojure-cli-global-options . "-A:dev")
     (cider-repl-init-code "(dev)")
     (cider-ns-refresh-after-fn . "dev-extras/resume")
     (cider-ns-refresh-before-fn . "dev-extras/suspend"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
