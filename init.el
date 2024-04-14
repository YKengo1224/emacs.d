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


;;welcom screenを非表示
(setq inhibit-startup-message t)
(mouse-wheel-mode t)

;;ツールバーを非表示
(tool-bar-mode 0)
(menu-bar-mode 0)

;;画面最大化
(push '(fullscreen . maximized) default-frame-alist)

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


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.


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
 '(package-selected-packages
   '(swiper which-key doom-modeline use-package mozc mew company eglot)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;Mozcの設定(aptでemacs-mozc-binをインストールする必要あり)
;; (require 'mozc)
;; (setq default-input-method "japanese-mozc")
;; (setq mozc-candidat-style 'echo-area)
;; (global-set-key "\C-o" 'toggle-input-method)
(use-package mozc
  :ensure t
  )
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(prefer-coding-system 'utf-8)
(use-package mozc-popup
  :ensure t
  )
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
;;モードラインの設定
(use-package doom-modeline
  :ensure t
  :custom
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon nil)
  (doom-modeline-minor-modes nil)
  :hook
  (after-init . doom-modeline-mode)
  :config
  (line-number-mode 0)
  (column-number-mode 0))


;;括弧のハイライト表示
(use-package paren
  :ensure nil
  :hook
  (after-init . show-paren-mode)
  :custom-face
  (show-paren-match ((nil (:background "#44475a" :foreground "#f1fa8c"))))
  :custom
  (show-paren-style 'mixed)
  (show-paren-when-point-inside-paren t)
  (show-paren-when-point-in-periphery t)  
  )

;;次のキー候補を表示
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :hook
  (after-init . which-key-mode)
  )

(use-package all-the-icons
  :if(display-graphic-p))

;;検索機能の強化
(use-package swiper
  :ensure t
  :config
  (defun isearch-forward-or-swiper (use-swiper)
    (interactive "p")
    ;; (interactive "P") ;; 大文字のPだと，C-u C-sでないと効かない
    (let (current-prefix-arg)
      (call-interactively (if use-swiper 'swiper 'isearch-forward))))
  (global-set-key (kbd "C-s") 'isearch-forward-or-swiper)  
  )
(use-package ivy
  :ensure t
  )

;;emacsclient(いるかどうかわからない)
(use-package server
  :config
  (unless (server-running-p)
    (server-start))
  )


