;;;
;;; General
;;;

;;バックアップファイルをすべてこのディレクトリに作成するように設定
(setq backup-directory-alist
      (cons (cons ".*" (expand-file-name "~/.emacs.d/backup-files"))
	    backup-directory-alist))

;;auto save ファイルをすべてこのディレクトリに作成するように設定
(setq auto-save-file-name-transforms
      `((".*",(expand-file-name "~/.emacs.d/auto-save-files/") t)))


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.


;;welcom screenを非表示
(setq inhibit-startup-message t)
(mouse-wheel-mode t)
;;ツールバーを非表示
(tool-bar-mode 0)
(menu-bar-mode 0)
;;括弧などのオートペアリングを有効
(electric-pair-mode t)
;;正規表現による置換をAlt+qにセット
(global-set-key "\M-q" 'query-replace-regexp)
;;tab -> space 4
(setq-default tab-width 1 indent-tabs-mode nil)

(if (not window-system) (menu-bar-mode 0))

;;行番号を表示
(global-display-line-numbers-mode)
(setq display-line-numbers-widen t)
(setq display-line-numbers-mode-start 3)

(setq initial-scratch-message nil)



;;package
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			                      ("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ))
(require 'package)



(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(doom-modeline use-package mozc mew company eglot)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;Mozcの設定(aptでemacs-mozc-binをインストールする必要あり)
(require 'mozc)
(setq default-input-method "japanese-mozc")
(setq mozc-candidate-style 'echo-area)
(global-set-key "\C-o" 'toggle-input-method)


;; テーマの設定
(use-package doom-themes
             :ensure t
             :custom
             (doom-themes-enable-italic t)
             (doom-themes-enable-bold t)
             :custom-face
             (doom-modeline-bar ((t (:background "#6272a4"))))
             :config
             (load-theme 'doom-dracula t)
             (doom-themes-neotree-config)
             (doom-themes-org-config)
             )
(use-package doom-modeline
             :ensure t
             :hook
             (after-init . doom-modeline-mode)
             )

