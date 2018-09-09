(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(setq package-enable-at-startup nil)

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq custom-file (make-temp-file "emacs-custom"))
(setq ring-bell-function 'ignore)
(setq inhibit-startup-screen t)
(setq mac-command-modifier 'meta
      mac-option-modifier 'none)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 20
      kept-old-versions 5)
(add-to-list 'load-path "~/.emacs.d/lisp/")

(use-package evil
  :ensure t
  :config
  (evil-mode))
