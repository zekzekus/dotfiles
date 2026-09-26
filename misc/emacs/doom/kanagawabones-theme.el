;;; kanagawabones-theme.el --- Kanagawabones theme for Doom Emacs -*- lexical-binding: t; no-byte-compile: t; -*-

;; Author: Zekeriya Koc
;; Source: https://github.com/mcchrish/zenbones.nvim

;;; Commentary:
;; A Doom Emacs port of Kanagawabones, preserving its restrained syntax
;; palette while giving editor state, diagnostics, and version control the
;; original Kanagawa accent colors.

;;; Code:

(require 'doom-themes)

(defgroup kanagawabones-theme nil
  "Options for the `kanagawabones' theme."
  :group 'doom-themes)

(defcustom kanagawabones-padded-modeline doom-themes-padded-modeline
  "If non-nil, add padding to the mode line.
An integer specifies the exact padding."
  :group 'kanagawabones-theme
  :type '(choice integer boolean))

(def-doom-theme kanagawabones
  "A low-color dark theme inspired by Kanagawa."
  :family 'kanagawabones
  :background-mode 'dark

  ((bg         '("#1F1F28" "#1c1c1c" "black"))
   (bg-alt     '("#232330" "#262626" "brightblack"))
   (base0      '("#16161D" "black" "black"))
   (base1      '("#181820" "#1c1c1c" "brightblack"))
   (base2      '("#1B1B23" "#262626" "brightblack"))
   (base3      '("#292934" "#303030" "brightblack"))
   (base4      '("#363644" "#3a3a3a" "brightblack"))
   (base5      '("#484856" "#4e4e4e" "brightblack"))
   (base6      '("#646476" "#626262" "brightblack"))
   (base7      '("#BBB79E" "#b2b2b2" "brightwhite"))
   (base8      '("#E9E3C5" "#eeeeee" "white"))
   (fg         '("#DDD8BB" "#d7d7af" "white"))
   (fg-alt     '("#A29E89" "#afaf87" "brightwhite"))

   (grey       base6)
   (red        '("#E46A78" "#d75f5f" "red"))
   (orange     '("#E5C283" "#d7af87" "brightred"))
   (green      '("#98BB6C" "#87af5f" "green"))
   (teal       '("#7EB3C9" "#87afaf" "brightgreen"))
   (yellow     '("#E5C283" "#d7af87" "yellow"))
   (blue       '("#7EB3C9" "#87afaf" "brightblue"))
   (dark-blue  '("#547C8C" "#5f8787" "blue"))
   (magenta    '("#957FB8" "#8787af" "magenta"))
   (violet     '("#AE9FCA" "#af87af" "brightmagenta"))
   (cyan       '("#7EB3C9" "#87afaf" "brightcyan"))
   (dark-cyan  '("#547C8C" "#5f8787" "cyan"))

   ;; The subdued Bones syntax palette.
   (syntax-dim     '("#696977" "#6c6c6c" "brightblack"))
   (syntax-type    '("#9797A5" "#949494" "brightwhite"))
   (syntax-value   '("#A29E89" "#afaf87" "brightwhite"))
   (syntax-special '("#ADA992" "#afaf87" "brightwhite"))
   (syntax-var     '("#BBB79E" "#b2b2b2" "brightwhite"))
   (selection      '("#49473E" "#4e4e4e" "brightblack"))
   (match          '("#614A82" "#5f5f87" "magenta"))
   (line-bg        '("#272732" "#262626" "brightblack"))
   (popup-bg       '("#31313F" "#303030" "brightblack"))

   ;; Required Doom face categories.
   (highlight      violet)
   (vertical-bar   base5)
   (builtin        syntax-special)
   (comments       syntax-dim)
   (doc-comments   syntax-dim)
   (constants      syntax-value)
   (functions      fg)
   (keywords       fg)
   (methods        fg)
   (operators      fg)
   (type           syntax-type)
   (strings        syntax-value)
   (variables      syntax-var)
   (numbers        syntax-value)
   (region         selection)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    blue)
   (vc-added       green)
   (vc-deleted     red)

   (-modeline-pad
    (when kanagawabones-padded-modeline
      (if (integerp kanagawabones-padded-modeline)
          kanagawabones-padded-modeline
        4)))
   (modeline-bg base4)
   (modeline-bg-inactive base3)
   (modeline-fg fg)
   (modeline-fg-inactive base6))

  ((cursor :background base8 :foreground bg)
   (fringe :background bg :foreground base6)
   (hl-line :background line-bg)
   ((line-number &override) :foreground base6)
   ((line-number-current-line &override) :foreground fg :weight 'bold)
   ((font-lock-builtin-face &override) :foreground builtin :weight 'bold)
   ((font-lock-comment-face &override) :foreground comments :slant 'italic)
   ((font-lock-comment-delimiter-face &override) :foreground comments :slant 'italic)
   ((font-lock-constant-face &override) :foreground constants :slant 'normal)
   ((font-lock-keyword-face &override) :foreground keywords :weight 'bold)
   ((font-lock-preprocessor-face &override) :foreground keywords :weight 'bold)
   ((font-lock-string-face &override) :foreground strings :slant 'normal)
   ((font-lock-type-face &override) :foreground type :weight 'normal)
   (highlight :background base3)
   (isearch :background violet :foreground bg :weight 'bold)
   (lazy-highlight :background match :foreground fg)
   (match :background match :foreground fg)
   (show-paren-match :foreground syntax-special :weight 'bold)
   (show-paren-mismatch :foreground red :weight 'bold)
   (tooltip :background popup-bg :foreground fg)
   (vertical-border :foreground base5)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-inactive
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))

   ;;;; completion
   (company-tooltip :background popup-bg :foreground fg)
   (company-tooltip-selection :background base5 :foreground fg :weight 'bold)
   (company-tooltip-annotation :foreground syntax-value)
   (corfu-default :background popup-bg :foreground fg)
   (corfu-current :background base5 :foreground fg :weight 'bold)
   (vertico-current :background base5 :foreground fg :weight 'bold)
   ;;;; diff / version control
   (diff-added :background "#2A331F" :foreground green)
   (diff-removed :background "#47272A" :foreground red)
   (diff-changed :background "#22333A" :foreground blue)
   (diff-refine-added :background green :foreground bg)
   (diff-refine-removed :background red :foreground bg)
   (diff-hl-insert :background green :foreground bg)
   (diff-hl-delete :background red :foreground bg)
   (diff-hl-change :background blue :foreground bg)
   ;;;; Doom UI
   (doom-dashboard-banner :foreground fg)
   (doom-dashboard-menu-title :foreground fg :weight 'bold)
   (doom-dashboard-menu-desc :foreground syntax-value)
   (doom-modeline-bar :background blue)
   (doom-modeline-buffer-file :foreground fg :weight 'bold)
   (doom-modeline-buffer-modified :foreground yellow)
   (doom-modeline-project-dir :foreground syntax-value)
   ;;;; diagnostics
   (flycheck-error :underline `(:style wave :color ,red))
   (flycheck-warning :underline `(:style wave :color ,yellow))
   (flycheck-info :underline `(:style wave :color ,blue))
   (flymake-error :underline `(:style wave :color ,red))
   (flymake-warning :underline `(:style wave :color ,yellow))
   (flymake-note :underline `(:style wave :color ,blue))
   ;;;; Magit
   (magit-section-heading :foreground fg :weight 'bold)
   (magit-section-highlight :background line-bg)
   (magit-diff-hunk-heading :background base3 :foreground base7)
   (magit-diff-hunk-heading-highlight :background base4 :foreground fg)
   (magit-diff-added :background "#2A331F" :foreground green)
   (magit-diff-added-highlight :background "#303B23" :foreground green)
   (magit-diff-removed :background "#47272A" :foreground red)
   (magit-diff-removed-highlight :background "#512D30" :foreground red)
   ;;;; Org
   (org-document-title :foreground fg :height 1.5 :weight 'bold)
   (org-level-1
    :background base3 :foreground fg :extend t :height 1.1
    :overline base5 :weight 'extra-bold)
   (org-level-2 :foreground syntax-var :weight 'bold)
   (org-level-3 :foreground syntax-special :weight 'bold)
   (org-level-4 :foreground syntax-type :weight 'bold)
   (org-agenda-structure :foreground blue :height 1.3 :weight 'bold)
   (org-agenda-date :foreground syntax-var :weight 'bold)
   (org-agenda-date-today :foreground fg :slant 'normal :weight 'extra-bold)
   (org-block :background bg-alt)
   (org-block-begin-line :background base2 :foreground base6 :extend t)
   (org-block-end-line :background base2 :foreground base6 :extend t)
   (org-code :foreground syntax-value)
   (org-date :foreground blue)
   (org-done :foreground green :weight 'bold)
   (org-document-info :foreground syntax-var)
   (org-document-info-keyword :foreground base6 :weight 'bold)
   (org-headline-done :foreground syntax-var)
   (org-meta-line :foreground base6)
   (org-quote :background line-bg :foreground syntax-var :extend t :slant 'italic)
   (org-tag :foreground syntax-value)
   (org-table :foreground syntax-var)
   (org-todo
    :foreground yellow :weight 'bold
    :box `(:line-width -1 :color ,yellow))
   ;;;; Treemacs
   (treemacs-root-face :foreground fg :weight 'bold)
   (treemacs-directory-face :foreground syntax-var)
   (treemacs-file-face :foreground fg)
   ;;;; solaire-mode
   (solaire-default-face :background bg-alt)
   (solaire-mode-line-face :inherit 'mode-line :background modeline-bg)
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive :background modeline-bg-inactive))

  ())

;;; kanagawabones-theme.el ends here
