;;; menguless-theme.el --- A mostly colorless theme inspired by a tweet from @mengu

;; Copyright (C) 2020 Zekeriya Koc
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;; Author: Zekeriya Koc <info@zeko.dev>
;; URL: https://github.com/zekzekus/dotfiles/tree/master/emacs/doom/menguless-theme.el
;; Version: 0.1
;; Package-Requires: ((colorless-themes "0.1"))
;; License: GPL-3
;; Keywords: faces theme

;;; Commentary:
;; This is a so-called colorless theme, derived thanks to the macro of the
;; colorless-themes[1] package.  The main source of inspiration of this theme is
;; a tweet[2] and a design on behance[3]
;;
;; [1]: https://git.sr.ht/~lthms/colorless-themes
;; [2]: https://twitter.com/mengukagan/status/1269001361821241345
;; [3]: https://www.behance.net/gallery/98359575/UI-Designs-for-Caves-of-Qud

;;; Code:
(require 'colorless-themes)

(deftheme menguless "A mostly colorless theme")

(colorless-themes-make menguless
                       "#022120"    ; bg
                       "#053837"    ; bg+
                       "#053837"    ; current-line
                       "#053837"    ; fade
                       "#357247"    ; fg
                       "#E5E9F0"    ; fg+
                       "#46606b"    ; docs
                       "#873c30"    ; red
                       "#99875e"    ; orange
                       "#cec040"    ; yellow
                       "#78f94d")    ; green

;;;###autoload
(when (and (boundp 'custom-theme-load-path) load-file-name)
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'menguless)
(provide 'menguless-theme)
;;; menguless-theme.el ends here
