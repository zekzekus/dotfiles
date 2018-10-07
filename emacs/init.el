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
;; (package-initialize)

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

(use-package diminish
  :ensure t
  :config
  (diminish 'eldoc-mode)
  (diminish 'undo-tree-mode))

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :bind
  (:map ivy-mode-map)
  ("C-j" . ivy-next-line)
  ("C-k" . ivy-previous-line)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-initial-inputs-alist nil))

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)))

(use-package swiper
  :ensure t
  :bind (("M-s" . swiper)))

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
  (projectile-mode +1))

(use-package counsel-projectile
  :ensure t)

(use-package general :ensure t
  :config
  (general-evil-setup t)

  (general-define-key
   :states '(normal visual emacs)
   :prefix "SPC"
   "TAB" '(evil-switch-to-windows-last-buffer :which-key "Last Buffer")
   "g"  '(:ignore t :which-key "Git")
   "gs" '(magit-status :which-key "Git Status")

   "f"  '(:ignore t :which-key "Files")
   "ff" '(counsel-find-file :which-key "Find")
   "fs" '(evil-write :which-key "Save")

   "b"  '(:ignore t :which-key "Buffers")
   "bd" '(evil-delete-buffer :which-key "Delete")
   "bb" '(counsel-ibuffer :which-key "List")

   "s"  '(:ignore t :which-key "Search")
   "ss" '(swiper :which-key "Buffer")

   "/" '(counsel-rg :which-key "Grep")

   "p" '(:ignore t :which-key "Projects")
   "pp" '(counsel-projectile-switch-project :which-key "Switch Project")
   "pf" '(counsel-projectile-find-file :which-key "Files")
   "pb" '(counsel-projectile-switch-to-buffer :which-key "Buffers")
   "p/" '(counsel-projectile-rg :which-key "Grep")

   "q" '(:ignore t :which-key "Quit")
   "qq" '(evil-quit-all :which-key "Quit All")
   )

  (general-define-key
   :states '(normal)
   "DEL" 'evil-ex-nohighlight)
  )

;;; init-use-package.el ends here
