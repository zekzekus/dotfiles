;;; init.el --- My Emacs configuration file

;; Copyright (C) 2018 Zekeriya Koc

;; Author: Zekeriya Koc <zekzekus@gmail.com>
;; Keywords: use-package
;; License: none, use this however you want without citation
;; 

;;; Commentary:

;; My 1000th attempt to create an emacs config from scratch


;;; Code:

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

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

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(show-paren-mode 1)
(electric-pair-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

(use-package nord-theme
  :ensure t
  :config
  (load-theme 'nord t))

(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(use-package magit
  :ensure t
  :commands (magit))

(use-package evil-magit
  :ensure t
  :after (magit evil)
  :config
  (setq evil-magit-state 'normal))

;;; init-use-package.el ends here
