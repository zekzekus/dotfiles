;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Zekeriya Koc"
      user-mail-address "zekzekus@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "PragmataPro" :size 15))
(setq doom-variable-pitch-font (font-spec :family "PragmataPro" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(load! "menguless-theme")

(setq doom-theme 'menguless)
(setq display-line-numbers-type nil)
(setq mac-command-modifier 'meta
      mac-option-modifier 'none)
(setq org-directory "~/org")

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
  (setq org-agenda-files '("~/org"))
  (setq org-log-done 'time)
  (setq org-refile-targets '(("work.org" :maxlevel . 2)
                             ("personal.org" :maxlevel . 2)
                             ("tickler.org" :maxlevel . 2)
                             ("someday.org" :level . 1)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-tags-column -89)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "STARTED(s)" "FOLLOW(f)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-default-notes-file (concat org-directory "/inbox.org"))
  (setq org-capture-templates '(("t" "Todo [inbox]" entry
                                 (file+headline org-default-notes-file "Tasks")
                                 "* TODO %i%?")
                                ("T" "Tickler" entry
                                 (file+headline (concat org-directory "/tickler.org") "Tickler")
                                 "* %i%? \n %U")))
  (setq org-journal-dir "~/org")
  (setq org-journal-file-type 'weekly)
  (setq org-journal-file-format "journal-%Y-%m-%d.org")
  (setq org-journal-file-header "#+TITLE: %B %dth, %Y (W%W)")
  (setq org-journal-date-format "%A, %eth.")
  (setq org-journal-carryover-items nil)
  (setq org-id-link-to-org-use-id t)
  (setq org-superstar-cycle-headline-bullets 2)
  (add-hook! 'org-mode-hook (turn-off-smartparens-mode))
  (add-hook! 'org-mode-hook (writeroom-mode 1)))

(after! (org org-roam)
  (setq org-roam-directory "~/org")
  (setq org-roam-completion-system 'ivy)
  (setq org-roam-capture-templates
        '(("d" "default" plain #'org-roam-capture--get-point "%?"
           :file-name "%<%Y%m%d%H%M%S>-${slug}"
           :head "#+TITLE: ${title}\n"
           :unnarrowed t
           :immediate-finish t))))

(after! deft
  (setq deft-directory "~/org")
  (setq deft-recursive t)
  (setq deft-use-filename-as-title t)
  (setq deft-file-naming-rules '( (noslash . "-"))))

(after! evil
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (map! :n "DEL" 'evil-ex-nohighlight))

(after! ivy
  (setq ivy-use-virtual-buffers t))

(after! projectile
  (setq projectile-completion-system 'ivy))

(after! writeroom-mode
  (setq writeroom-mode-line t)
  (setq writeroom-width 100)
  (setq +zen-text-scale 0))

(use-package! w3m
  :commands (w3m))

(custom-theme-set-faces! 'nordless
  '(font-lock-string-face :background "#2E3440"))

;; (custom-set-faces!
;;   '(org-level-1 :height 1.1 :overline nil)
;;   '(org-level-2 :height 1.0 :overline nil)
;;   '(org-level-3 :height 1.0 :overline nil)
;;   '(org-level-4 :height 1.0 :overline nil)
;;   '(org-level-5 :height 1.0 :overline nil)
;;   '(org-level-6 :height 1.0 :overline nil)
;;   '(org-document-title :height 1.1))
