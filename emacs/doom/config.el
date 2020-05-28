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

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-nord-light)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type nil)

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

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq mac-command-modifier 'meta
      mac-option-modifier 'none)

(after! org
  (setq org-log-done 'time)
  (setq org-directory "~/org")
  (setq org-agenda-files "agenda_files.list")
  (setq org-refile-targets '(("work.org" :maxlevel . 2)
                             ("personal.org" :maxlevel . 2)
                             ("tickler.org" :maxlevel . 2)
                             ("someday.org" :level . 1)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-tags-column -89)
  (setq org-todo-keywords
        '((sequence "TODO" "ONGOING" "FOLLOW" "WAITING" "|" "JIRA" "DONE" "CANCELLED")))
  (setq org-default-notes-file (concat org-directory "/inbox.org"))
  (setq org-capture-templates '(("t" "Todo [inbox]" entry
                                 (file+headline org-default-notes-file "Tasks")
                                 "* TODO %i%?")
                                ("T" "Tickler" entry
                                 (file+headline (concat org-directory "/tickler.org") "Tickler")
                                 "* %i%? \n %U")))
  (setq org-journal-file-format "%Y-%m-%d.org")
  (setq org-superstar-cycle-headline-bullets 2))

(add-hook! 'org-mode-hook (turn-off-smartparens-mode))

(after! org-roam
  (setq org-roam-directory "~/org")
  (setq org-roam-completion-system 'ivy))

(after! evil
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (map! :n "DEL" 'evil-ex-nohighlight))

(after! ivy
  (setq ivy-use-virtual-buffers t))

(after! projectile
  (setq projectile-completion-system 'ivy))

(after! deft
  (setq deft-recursive t)
  (setq deft-use-filter-string-for-filename t)
  (setq deft-default-extension "org")
  (setq deft-directory "~/org"))

(after! mu4e
  (setq! mu4e-maildir (expand-file-name "~/Mail/zekpisano") ; the rest of the mu4e folders are RELATIVE to this one
         mu4e-get-mail-command "offlineimap -a ZekPisano"
         mu4e-index-update-in-background t
         mu4e-compose-signature-auto-include t
         mu4e-use-fancy-chars t
         mu4e-view-show-addresses t
         mu4e-view-show-images t
         mu4e-compose-format-flowed t
         ;mu4e-compose-in-new-frame t
         mu4e-change-filenames-when-moving t ;; http://pragmaticemacs.com/emacs/fixing-duplicate-uid-errors-when-using-mbsync-and-mu4e/
         mu4e-maildir-shortcuts
         '( ("/Inbox" . ?i)
            ("/All Mail" . ?a)
            ("/Drafts" . ?d)
            ("/Trash" . ?t)
            ("/Sent Mail" . ?s))

         ;; Message Formatting and sending
         message-send-mail-function 'smtpmail-send-it
         message-signature-file ""
         message-citation-line-format "On %a %d %b %Y at %R, %f wrote:\n"
         message-citation-line-function 'message-insert-formatted-citation-line
         message-kill-buffer-on-exit t

         ;; Org mu4e
         org-mu4e-convert-to-html t))

(set-email-account! "zekeriya.koc@pisano.co"
                    '((user-mail-address      . "zekeriya.koc@pisano.co")
                      (user-full-name         . "Zekeriya Koç")
                      (smtpmail-smtp-server   . "")
                      (smtpmail-smtp-service  . 587)
                      (smtpmail-stream-type   . starttls)
                      (smtpmail-debug-info    . t)
                      (mu4e-drafts-folder     . "/Drafts")
                      (mu4e-refile-folder     . "/All Mail")
                      (mu4e-sent-folder       . "/Sent Mail")
                      (mu4e-trash-folder      . "/Trash")
                      (mu4e-update-interval   . 1800))
                      ;(mu4e-sent-messages-behavior . 'delete)
                    nil)
