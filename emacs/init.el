(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(setq package-enable-at-startup nil)

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(set-frame-font "PragmataPro 15" nil t)
(global-hl-line-mode 1)
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

(use-package nord-theme
  :ensure t
  :config
  (load-theme 'nord t))

(use-package evil
  :ensure t
  :config
  (evil-mode))

(use-package smex :ensure t)

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode t)
  (setq ivy-initial-inputs-alist nil))

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)))

(use-package swiper
  :ensure t
  :bind (("M-s" . swiper)))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (add-hook 'after-init-hook 'which-key-mode))

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (add-hook 'prog-mode-hook 'smartparens-mode))

(use-package smart-dash
  :ensure t
  :config
  (add-hook 'python-mode-hook 'smart-dash-mode))

(use-package projectile
  :ensure t
  :config
  (projectile-mode)
  (setq projectile-completion-system 'ivy))

(use-package counsel-projectile
  :ensure t
  :config
  (add-hook 'after-init-hook 'counsel-projectile-mode))

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package magit :ensure t)

(use-package git-gutter
  :ensure t
  :config
  (global-git-gutter-mode 't)
  :diminish git-gutter-mode)

(use-package git-timemachine :ensure t)

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (setq-default flycheck-highlighting-mode 'lines)
  ;; Define fringe indicator / warning levels
  (define-fringe-bitmap 'flycheck-fringe-bitmap-ball
    (vector #b00000000
	    #b00000000
	    #b00000000
	    #b00000000
	    #b00000000
	    #b00000000
	    #b00000000
	    #b00011100
	    #b00111110
	    #b00111110
	    #b00111110
	    #b00011100
	    #b00000000
	    #b00000000
	    #b00000000
	    #b00000000
	    #b00000000))
  (flycheck-define-error-level 'error
			       :severity 2
			       :overlay-category 'flycheck-error-overlay
			       :fringe-bitmap 'flycheck-fringe-bitmap-ball
			       :fringe-face 'flycheck-fringe-error)
  (flycheck-define-error-level 'warning
			       :severity 1
			       :overlay-category 'flycheck-warning-overlay
			       :fringe-bitmap 'flycheck-fringe-bitmap-ball
			       :fringe-face 'flycheck-fringe-warning)
  (flycheck-define-error-level 'info
			       :severity 0
			       :overlay-category 'flycheck-info-overlay
			       :fringe-bitmap 'flycheck-fringe-bitmap-ball
			       :fringe-face 'flycheck-fringe-info))

  (use-package company
    :ensure t
    :diminish
    :config
    (add-hook 'after-init-hook 'global-company-mode)

    (setq company-idle-delay t)

    (use-package company-anaconda
      :ensure t
      :config
      (add-to-list 'company-backends 'company-anaconda)))

(use-package anaconda-mode
  :ensure t
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))
