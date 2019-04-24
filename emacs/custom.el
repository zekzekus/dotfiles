(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-safe-themes
   (quote
	("cc0dbb53a10215b696d391a90de635ba1699072745bf653b53774706999208e3" default)))
 '(hl-sexp-background-color "#efebe9")
 '(package-selected-packages
   (quote
	(use-package nord-theme flycheck flycheck-rust doom-modeline ace-window shell-pop evil evil-collection evil-commentary magit evil-magit diminish ivy ivy-hydra hydra counsel swiper smex exec-path-from-shell which-key projectile counsel-projectile evil-escape paredit parinfer company anaconda-mode pyvenv company-anaconda rust-mode racer haskell-mode intero go-mode company-go cider slime rjsx-mode org evil-org markdown-mode flycheck restclient treemacs treemacs-evil treemacs-projectile general)))
 '(safe-local-variable-values
   (quote
	((eval progn
		   (put
			(quote defendpoint)
			(quote clojure-doc-string-elt)
			3)
		   (put
			(quote api/defendpoint)
			(quote clojure-doc-string-elt)
			3)
		   (put
			(quote defsetting)
			(quote clojure-doc-string-elt)
			2)
		   (put
			(quote setting/defsetting)
			(quote clojure-doc-string-elt)
			2)
		   (put
			(quote s/defn)
			(quote clojure-doc-string-elt)
			2)
		   (define-clojure-indent
			 (assert 1)
			 (assoc 1)
			 (ex-info 1)
			 (execute-sql! 2)
			 (expect 0)
			 (match 1)
			 (merge-with 1)
			 (with-redefs-fn 1))))))
 '(shell-pop-full-span t)
 '(shell-pop-shell-type
   (quote
	("ansi-term" "*ansi-term*"
	 (lambda nil
	   (ansi-term shell-pop-term-shell))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-inline-error ((t (:inherit compilation-error :background "black" :box (:line-width 1 :color "grey75" :style released-button)))))
 '(flycheck-inline-info ((t (:inherit compilation-info :background "black" :box (:line-width 1 :color "grey75" :style released-button)))))
 '(flycheck-inline-warning ((t (:inherit compilation-warning :background "black" :box (:line-width 1 :color "grey75" :style released-button)))))
 '(org-checkbox-statistics-done ((t (:inherit org-done :box (:line-width 1 :color "grey75" :style released-button)))))
 '(org-checkbox-statistics-todo ((t (:inherit org-todo :box (:line-width 1 :color "grey75" :style released-button)))))
 '(org-level-1 ((t (:background "gray18" :foreground "#FE8019" :overline "grey75"))))
 '(org-level-2 ((t (:background "gray18" :foreground "#FE8019" :overline "grey75")))))
