;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Zekeriya Koc"
      user-mail-address "zekeriya@hey.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Berkeley Mono" :size 15))
(setq doom-variable-pitch-font (font-spec :family "Berkeley Mono" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(load! "menguless-theme")

(setq doom-theme 'parchment)
(setq display-line-numbers-type nil)
(setq mac-command-modifier 'meta
      mac-option-modifier 'meta)
(setq resize-mini-windows nil)
(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish"))
(global-auto-revert-mode 1)
(rainbow-delimiters-mode -1)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; (map! :leader :prefix ("M" . "Searcha"))
;; (map! :leader :desc "Jump to char" "/c" #'avy-goto-char)

(after! org
  (setq org-directory "~/org")
  (setq org-agenda-files '("~/org" "~/org/daily"))
  (setq org-log-done 'time)
  (setq org-refile-targets '(("gtd_work.org" :maxlevel . 2)
                             ("gtd_personal.org" :maxlevel . 2)
                             ("gtd_tickler.org" :maxlevel . 2)
                             ("gtd_someday.org" :level . 1)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-tags-column -102)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "STARTED(s)" "FOLLOW(f)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-default-notes-file (concat org-directory "/Inbox.org"))
  (setq org-capture-templates '(("t" "Todo [inbox]" entry
                                 (file+headline org-default-notes-file "Tasks")
                                 "* TODO %i%?")
                                ("T" "Tickler" entry
                                 (file+headline (concat org-directory "/tickler.org") "Tickler")
                                 "* %i%? \n %U")))
  (setq org-id-link-to-org-use-id 'create-if-interactive)
  (setq org-superstar-cycle-headline-bullets 2)
  (setq org-agenda-prefix-format
        '((agenda . " %i %?-12t% s")
          (todo . " %i ")
          (tags . " %i ")
          (search . " %i ")))
  ;; (add-hook! 'org-mode-hook (turn-off-smartparens-mode))
  (add-hook! 'org-mode-hook (writeroom-mode 1)))

(after! (org org-roam)
  (setq org-roam-directory "~/org")
  (setq org-roam-completion-system 'ivy)
  (setq org-roam-completion-everywhere nil)
  (setq org-roam-capture-templates
        '(("d" "default" plain
           "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n\n")
           :unnarrowed t)
          ("p" "project" plain
           "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project\n\n")
           :unnarrowed t)))
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "* %<%I:%M %p>: %?"
           :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  (map! :map org-mode-map
        :i "C-c C-r" 'org-roam-node-insert))

(setq flymake-allowed-file-name-masks nil)

(after! deft
  (setq deft-directory "~/org")
  (setq deft-recursive t)
  (setq deft-use-filename-as-title t)
  (setq deft-file-naming-rules '( (noslash . "-"))))

(after! evil
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (map! :n "DEL" 'evil-ex-nohighlight))

(after! writeroom-mode
  (setq writeroom-mode-line t)
  (setq writeroom-width 100)
  (setq +zen-text-scale 0))

(after! sly
  (setq sly-command-switch-to-existing-lisp 'always)
  (setq inferior-lisp-program "sbcl")
  (set-company-backend! 'sly-mrepl-mode nil))

;; (after! company
;;   (setq company-idle-delay nil))

(use-package! w3m
  :commands (w3m))

(custom-theme-set-faces! 'menguless
  '(org-block-begin-line :box (:color "#ccccbb" :line-width -1))
  '(org-block-end-line :box (:color "#ccccbb" :line-width -1)))

(custom-theme-set-faces! 'parchment
  '(org-level-1 :height 1.1 :weight bold :overline t :foreground "#000000" :background "#eaeaea")
  '(org-document-title :height 1.5 :weight bold :foreground "#000000")
  '(org-agenda-structure :height 1.3))
;;   '(org-level-1 :overline nil :background nil :height 1.1)
;;   '(org-level-2 :overline nil :background nil)
;;   '(org-level-3 :overline nil :background nil)
;;   '(org-level-4 :overline nil :background nil)
;;   '(org-level-5 :overline nil :background nil)
;;   '(org-level-6 :overline nil :background nil)
