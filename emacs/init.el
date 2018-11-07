;;; init.el --- My Emacs configuration file

;; Copyright (C) 2018 Zekeriya Koc

;; Author: Zekeriya Koc <zekzekus@gmail.com>
;; Keywords: use-package
;; License: none, use this however you want without citation
;; 

;;; Commentary:

;; My 1000th attempt to create an Emacs config from scratch


;;; Code:

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)
(defvar zek--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(setq package-enable-at-startup nil)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(unless package--initialized
  (package-initialize))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(set-frame-font "PragmataPro 15" nil t)
(setq custom-file (make-temp-file "emacs-custom"))
(setq mac-command-modifier 'meta
      mac-option-modifier 'none)
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 20
      kept-old-versions 5)
(setq inhibit-splash-screen t)
(setq eldoc-echo-area-use-multiline-p nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq-default tab-width 4)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(show-paren-mode 1)
(electric-pair-mode 1)
;; (global-linum-mode 1)
(save-place-mode 1)
(global-hl-line-mode +1)

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(use-package nord-theme
  :ensure t
  :config
  (load-theme 'nord t))

(use-package telephone-line
  :ensure t
  :init
  (setq telephone-line-primary-left-separator 'telephone-line-gradient
        telephone-line-secondary-left-separator 'telephone-line-nil
        telephone-line-primary-right-separator 'telephone-line-gradient
        telephone-line-secondary-right-separator 'telephone-line-nil)
  (setq telephone-line-height 24
        telephone-line-evil-use-short-tag t)
  (telephone-line-mode 1))

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (with-eval-after-load 'evil
    (defalias #'forward-evil-word #'forward-evil-symbol)))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-commentary
  :ensure t
  :diminish evil-commentary-mode
  :config
  (add-hook 'prog-mode-hook 'evil-commentary-mode))

(use-package magit
  :ensure t
  :commands (magit))

(use-package evil-magit
  :ensure t
  :after (magit evil)
  :config
  (setq evil-magit-state 'normal))

(use-package diminish
  :ensure t
  :config
  (diminish 'eldoc-mode)
  (diminish 'undo-tree-mode))

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-initial-inputs-alist nil))

(use-package counsel :ensure t)

(use-package swiper :ensure t)

(use-package smex :ensure t)

(use-package exec-path-from-shell
  :ensure t
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :diminish which-key-mode)

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config
  (projectile-mode +1)
  (setq projectile-git-submodule-command "")

  (defun zek:find-file ()
    (interactive)
    (if (projectile-project-p)
        (counsel-projectile-find-file)
      (counsel-find-file)))

  (defun zek:find-buffer ()
    (interactive)
    (if (projectile-project-p)
        (counsel-projectile-switch-to-buffer)
      (counsel-ibuffer)))

  (defun zek:grep ()
    (interactive)
    (if (projectile-project-p)
        (counsel-projectile-rg)
      (counsel-rg))))

(use-package counsel-projectile
  :ensure t)

(use-package evil-escape
  :ensure t
  :diminish evil-escape-mode
  :init
  (evil-escape-mode)
  :config
  (setq-default evil-escape-key-sequence "C-["))

(use-package paredit
  :ensure t)

(use-package parinfer
  :ensure t
  :diminish parinfer-mode
  :after paredit
  :init
  (progn
    (setq parinfer-extensions '(defaults pretty-parens evil paredit smart-tab smart-yank))
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(use-package company
  :ensure t
  :diminish company-mode
  :init
  (global-company-mode)
  (setq company-tooltip-limit 20)
  (setq company-idle-delay .3)
  (setq company-echo-delay 0)
  (setq company-begin-commands '(self-insert-command)))

(use-package anaconda-mode
  :ensure t
  :diminish anaconda-mode
  :init
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(use-package company-anaconda
  :ensure t
  :after company
  :init
  (add-to-list 'company-backends '(company-anaconda :with company-capf)))

(use-package rust-mode
  :ensure t
  :mode ("\\.rs\\'" . rust-mode)
  :diminish eldoc-mode
  :config
  (setq company-tooltip-align-annotations t)
  (setq rust-format-on-save t))

(use-package racer
  :ensure t
  :init
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode))

(use-package haskell-mode :ensure t)

(use-package intero
  :ensure t
  :after haskell-mode
  :init
  (add-hook 'haskell-mode-hook 'intero-mode))

(use-package go-mode :ensure t)

(use-package company-go
  :ensure t
  :after company
  :init
  (add-to-list 'company-backends '(company-go :with company-capf)))

(use-package cider
  :ensure t
  :config
  (add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode))

(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "/usr/local/bin/sbcl")
  (setq slime-contribs '(slime-fancy)))

(use-package rjsx-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode)))

(use-package org
  :mode ("\\.org\\'" . org-mode)
  :ensure t
  :config
  (setq org-log-done 'time)
  (setq org-agenda-files "~/org/agenda_files.list"))

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :init
  (global-flycheck-mode))

(use-package general :ensure t
  :config
  (general-evil-setup t)

  (general-define-key
   :states '(normal visual emacs)
   :prefix "SPC"
   "TAB" '(evil-switch-to-windows-last-buffer :which-key "last buffer")
   "SPC" '(counsel-M-x :which-key "M-x")
   "g"  '(:ignore t :which-key "git")
   "gs" '(magit-status :which-key "git status")

   "f"  '(:ignore t :which-key "files")
   "ff" '(zek:find-file :which-key "find")
   "fF" '(counsel-find-file :which-key "find")
   "fs" '(evil-write :which-key "save")

   "b"  '(:ignore t :which-key "buffers")
   "bd" '(evil-delete-buffer :which-key "delete")
   "bb" '(zek:find-buffer :which-key "list")
   "bB" '(counsel-ibuffer :which-key "list")

   "s"  '(:ignore t :which-key "search")
   "sl" '(swiper :which-key "buffer")
   "ss" '(counsel-imenu :which-key "outline")
   "s/" '(counsel-rg :which-key "grep")

   "/" '(zek:grep :which-key "grep")

   "p" '(:ignore t :which-key "projects")
   "pp" '(counsel-projectile-switch-project :which-key "switch project")
   "pf" '(counsel-projectile-find-file :which-key "files")
   "pb" '(counsel-projectile-switch-to-buffer :which-key "buffers")
   "p/" '(counsel-projectile-rg :which-key "grep")

   "t" '(:ignore t :which-key "toggles")
   "tn" '(linum-mode :which-key "line numbers")
   "tN" '(global-linum-mode :which-key "global line numbers")
   "tc" '(company-mode :which-key "completion")
   "tC" '(global-company-mode :which-key "global completion")
   "tf" '(flycheck-mode :which-key "flycheck")
   "tF" '(global-flycheck-mode :which-key "global flycheck")

   "m" '(:ignore t :which-key "majors")
   "mw" '(pyvenv-workon :which-key "workon")

   "q" '(:ignore t :which-key "quit")
   "qq" '(evil-quit-all :which-key "quit all"))

  (general-define-key
   :states '(normal)
   "DEL" 'evil-ex-nohighlight
   "M-x" 'counsel-M-x
   "M-s" 'swiper
   "C-," 'parinfer-toggle-mode
   "] q" 'flycheck-next-error
   "[ q" 'flycheck-previous-error
   "] Q" 'flycheck-last-error
   "[ Q" 'flycheck-first-error)

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'python-mode-map
   "K" 'anaconda-mode-show-doc
   "[ d" 'anaconda-mode-show-doc
   "[ C-d" 'anaconda-mode-find-definitions)

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'rust-mode-map
   "K" 'racer-describe-tooltip
   "[ d" 'racer-describe
   "[ C-d" 'racer-find-definition)

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'clojure-mode-map
   "K" 'cider-doc
   "[ d" 'cider-doc
   "[ C-d" 'cider-find-var)

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'haskell-mode-map
   "K" 'intero-type-at
   "[ d" 'intero-info
   "[ C-d" 'intero-goto-definition)

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'go-mode-map
   "K" 'godef-describe
   "[ d" 'godef-describe
   "[ C-d" 'godef-jump)

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'emacs-lisp-mode-map
   "K" 'describe-symbol
   "[ d" 'describe-symbol
   "[ C-d" 'xref-find-definitions)

  (general-define-key
   :keymaps 'ivy-mode-map
   "C-n" 'ivy-next-line
   "C-p" 'ivy-previous-line
   "C-j" 'ivy-next-line
   "C-k" 'ivy-previous-line)

  (general-define-key
   :keymaps 'company-active-map
   "C-n" 'company-select-next-or-abort
   "C-p" 'company-select-previous-or-abort
   "C-j" 'company-select-next-or-abort
   "C-k" 'company-select-previous-or-abort)

  (define-key key-translation-map (kbd "ESC") (kbd "C-g")))

(add-hook 'emacs-startup-hook
    (lambda ()
      (setq gc-cons-threshold 16777216
            gc-cons-percentage 0.1
            file-name-handler-alist zek--file-name-handler-alist)))

(provide 'init)
;;; init.el ends here
