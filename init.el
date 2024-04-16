
;;; package --- Summary
;;; Commentary:
;;; General
;;;


;;; Code:
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;package config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;package
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			                      ("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ))
(require 'package)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;staraight use-packageの設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 何も考えず公式のREADMEからコピペすればいいコード
;; straight.el自身のインストールと初期設定を行ってくれる
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq package-enable-at-startup nil)


;; use-packageをインストールする
(straight-use-package 'use-package)

;; オプションなしで自動的にuse-packageをstraight.elにフォールバックする
;; 本来は (use-package hoge :straight t) のように書く必要がある
(setq straight-use-package-by-default t)

;; ;; init-loaderをインストール&読み込み
;; (use-package init-loader
;;   :ensure t
;;   )

;; ;; ~/.emacs.d/init/ 以下のファイルを全部読み込む
;; (init-loader-load "~/.emacs.d/init")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-statistics mwim neotree auto-package-update all-the-icons highlight-indent-guides swiper which-key doom-modeline use-package mozc mew company eglot))
 '(verilog-ext-formatter-column-limit 100)
 '(verilog-ext-formatter-indentation-spaces 4))
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
  :ensure t
  :if (display-graphic-p))

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

;;日本語をローマ字で検索可能にする
;; (use-package migemo
;;   :ensure t
;;   :config
;;   ;; C/Migemo を使う場合は次のような設定を .emacs に加えます．
;;   (setq migemo-command "cmigemo")
;;   (setq migemo-options '("-q" "--emacs" "-i" "\a"))
;;   ;(setq migemo-dictionary "/usr/local/Cellar/cmigemo/20110227/share/migemo/utf-8/migemo-dict")  ;; 各自の辞書の在り処を指示
;;   (setq migemo-user-dictionary nil)
;;   (setq migemo-regex-dictionary nil)
;;   ;; charset encoding
;;   (setq migemo-coding-system 'utf-8-unix))

;; (use-package avy-migemo
;;   :ensure t
;;   :config
;;   (avy-migemo-mode 1)
;;   (setq avy-timeout-seconds nil)
;;   (require 'avy-migemo-e.g.swiper)
;;   (global-set-key (kbd "C-M-;") 'avy-migemo-goto-char-timer)
;;   ;;  (global-set-key (kbd "M-g m m") 'avy-migemo-mode)
;;   )

;;emacsclient(いるかどうかわからない)
(use-package server
  :config
  (unless (server-running-p)
    (server-start))
  )

;;現在行を強調表示
(use-package hl-line
  :init
  (global-hl-line-mode +1)
  )

;;他プロセスの編集をバッファに反映
(use-package autorevert
  :init
  (global-auto-revert-mode +1)
  )

;;インデントの位置を強調表示
(use-package highlight-indent-guides
  :ensure t
  :delight
  :hook ((prog-mode-hook yaml-mode-hook) . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method  'character)
  (highlight-indent-guides-auto-enabled t)
  (highlight-indent-guides-responsive t)
  (highlight-indent-guides-character ?|)
  )

;;パッケージを自動的に更新(package-upgrade-all機能はバグがある)
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-interval 1)
  (auto-package-update-maybe))


(use-package emacs-rotate
  :straight '(emacs-rotate
              :type git
              :host github
              :repo "daichirata/emacs-rotate")
  :ensure t
  )

;;neotree(ファイルブラウザを表示)
(use-package neotree
  :ensure t
  :init
  (setq-default neo-keymap-style 'concize)
  :config
  (setq neo-create-file-auto-open t)
  (setq neo-show-hidden-files t)
  (setq neo-theme (if (display-graphic-p) 'icon 'arrow))
  (bind-key "C-q" 'neotree-toggle)
  )


;;emacs中でのterminal
(use-package vterm
  :ensure t)

;;vtermのトグルの設定
(use-package vterm-toggle
  :ensure t
  :bind
  (("C-`" . vterm-toggle))
  :config
  ;; Show vterm buffer in the window located at bottom
  (add-to-list 'display-buffer-alist
               '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
                 (display-buffer-reuse-window display-buffer-in-direction)
                 (direction . bottom)
                 (reusable-frames . visible)
                 (window-height . 0.4)))
  )


(use-package magit
  :ensure t
  :bind
  (("C-x g" . magit-status))
  )

;;行末、行頭への移動を拡張
(use-package mwim
  :ensure t
  :bind
  (("C-a" . mwim-beginning-of-code-or-line)
   ("C-e" . mwim-end-of-code-or-line))
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;coding setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;補完機能
(use-package company
  :ensure t
  :after company-statistics
  :bind(
        ("M-<tab>" . company-complete)  ;;Tabで自動補完を起動
        :map company-active-map
        ;;C-n,C-pで補完候補を移動
        ("M-n" . nil)
        ("M-p" . nil)
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)
        ("C-s" . company-filter-candidates)
        :map company-search-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)        
        )
  :init
  (global-company-mode) ;; 全部バッファで有効
  :config
  (define-key emacs-lisp-mode-map (kbd "C-M-i") nil) ;; CUI版のためにemacs-lisp-modeでバインドされるC-M-iをアンバインド
  (global-set-key (kbd "C-M-i") 'company-complete)   ;; CUI版ではM-<tab>はC-M-iに変換されるのでそれを利用
  (setq completion-ignore-case t)
  (setq company-idle-delay 0)                    ;; 待ち時間を0秒にする
  (setq company-minimum-prefix-length 2)         ;; 補完できそうな文字が2文字以上入力されたら候補を表示
  (setq company-selection-wrap-around t)         ;; 候補の一番下でさらに下に行こうとすると一番上に戻る
  (setq company-transformers '(company-sort-by-occurrence company-sort-by-backend-importance)) ;; 利用頻度が高いものを候補の上に表示する
  )

;;補完候補を少し変更(いい感じに)
(use-package company-statistics
  :ensure t
  :init
  (company-statistics-mode)
  )

;;補完候補の絞り込みを拡張
(use-package company-dwim
  :straight '(company-dwim
              :type git
              :host github
              :repo "zk-phi/company-dwim")
  :ensure t
  :init
  (define-key company-active-map (kbd "TAB") 'company-dwim)
  (setq company-frontends
      '(company-pseudo-tooltip-unless-just-one-frontend
        company-dwim-frontend
        company-echo-metadata-frontend))
  )

;;カーソルがどこにあっても補完可能に
(use-package company-anywhere
  :straight '(company-anywhere
              :type git
              :host github
              :repo "zk-phi/company-anywhere")
  :ensure t)




;;校正ツール
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode t)
  )

(provide 'init)
;;; init.el ends here


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;LSP setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package eglot
  :ensure t
  :config
  (add-to-list 'eglot-server-programs '(c-mode "ccls"))
  (add-to-list 'eglot-server-programs '(c++-mode "ccls"))
  (add-to-list 'eglot-server-programs '(python-mode "pylsp"))
  (add-to-list 'eglot-server-programs '(rustic "rust-analyzer"))
  (add-to-list 'eglot-server-programs '(verilog-mode "svls"))
  :hook
  (python-mode . eglot-ensure)
  (c-mode . eglot-ensure)
  (c++-mode . eglot-ensure)
  ) 

;;校正
(use-package flymake
  :ensure t
  :bind
  (nil
   :map flymake-mode-map
   ("C-c C-p" . flymake-goto-prev-error)
   ("C-c C-n" . flymake-goto-prev-error)
   )
  :init
  (add-hook 'python-mode-common-hook 'flymake-mode)
  (add-hook 'verilog-mode-hook 'flymake-mode)
  :commands
  flymake-mode
  )


;;エラー表示をカーソル位置に表示
(use-package flymake-diagnostic-at-point
  :ensure t
  :after flymake
  :config
  (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode)
  (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake))

;;c setting
;;c言語の補完
(use-package irony
  :ensure t
  :defer t
  :commands irony-mode
  :init
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'c++-mode-hook 'irony-mode)
  :config
  ;; C言語用にコンパイルオプションを設定する.
  (add-hook 'c-mode-hook
            '(lambda ()
               (setq irony-additional-clang-options '("-std=c11" "-Wall" "-Wextra"))))
  ;; C++言語用にコンパイルオプションを設定する.
  (add-hook 'c++-mode-hook
            '(lambda ()
               (setq irony-additional-clang-options '("-std=c++14" "-Wall" "-Wextra"))))
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  ;; Windows環境でパフォーマンスを落とす要因を回避.
  (when (boundp 'w32-pipe-read-delay)
    (setq w32-pipe-read-delay 0))
  ;; バッファサイズ設定(default:4KB -> 64KB)
  (when (boundp 'w32-pipe-buffer-size)
    (setq irony-server-w32-pipe-buffer-size (* 64 1024)))
  )

(use-package company-irony
  :ensure t
  :defer t
  :config
  ;; companyの補完のバックエンドにironyを使用する.
  (add-to-list 'company-backends '(company-irony-c-headers company-irony))
  )





;;python setting
(use-package python-mode
  :ensure nil
  )


;;rust setting
(use-package rustic
  :ensure t
  :custom
  (rustic-analyzer-command '("rustup" "run" "stable" "rust-analyzer")))

(setq rustic-lsp-client 'eglot)
(add-hook 'eglot--managed-mode-hook (lambda () (flymake-mode -1)))




(use-package verilog-mode
  :ensure t)

;;https://github.com/gmlarumbe/verilog-ts-mode
;;M-x で
(use-package verilog-ts-mode
  :ensure t
  )
(add-to-list 'auto-mode-alist '("\\.s?vh?\\'" . verilog-ts-mode))


;;https://github.com/gmlarumbe/verilog-ext
(use-package verilog-ext
  :ensure t
  :hook ((verilog-mode . verilog-ext-mode))
  :init
  ;; Can also be set through `M-x RET customize-group RET verilog-ext':
  ;; Comment out/remove the ones you do not need
  (setq verilog-ext-feature-list
        '(font-lock
          xref
          capf
          hierarchy
          eglot
          ;lsp
          ;lsp-bridge
          ;lspce
          flycheck
          beautify
          navigation
          template
          formatter
          compilation
          imenu
          which-func
          hideshow
          typedefs
          time-stamp
          block-end-comments
          ports))
  :config
  (verilog-ext-eglot-set-server 've-svls) ;'eglot' config
  (verilog-ext-mode-setup))

;;verilog xref config
(setq verilog-ext-tags-backend 'tree-sitter)

;; sintax highlight config
(set-face-attribute 'verilog-ts-font-lock-grouping-keywords-face nil :foreground "dark olive green")
(set-face-attribute 'verilog-ts-font-lock-punctuation-face nil       :foreground "burlywood")
(set-face-attribute 'verilog-ts-font-lock-operator-face nil          :foreground "burlywood" :weight 'extra-bold)
(set-face-attribute 'verilog-ts-font-lock-brackets-face nil          :foreground "goldenrod")
(set-face-attribute 'verilog-ts-font-lock-parenthesis-face nil       :foreground "dark goldenrod")
(set-face-attribute 'verilog-ts-font-lock-curly-braces-face nil      :foreground "DarkGoldenrod2")
(set-face-attribute 'verilog-ts-font-lock-port-connection-face nil   :foreground "bisque2")
(set-face-attribute 'verilog-ts-font-lock-dot-name-face nil          :foreground "gray70")
(set-face-attribute 'verilog-ts-font-lock-brackets-content-face nil  :foreground "yellow green")
(set-face-attribute 'verilog-ts-font-lock-width-num-face nil         :foreground "chartreuse2")
(set-face-attribute 'verilog-ts-font-lock-width-type-face nil        :foreground "sea green" :weight 'bold)
(set-face-attribute 'verilog-ts-font-lock-module-face nil            :foreground "green1")
(set-face-attribute 'verilog-ts-font-lock-instance-face nil          :foreground "medium spring green")
(set-face-attribute 'verilog-ts-font-lock-time-event-face nil        :foreground "deep sky blue" :weight 'bold)
(set-face-attribute 'verilog-ts-font-lock-time-unit-face nil         :foreground "light steel blue")
(set-face-attribute 'verilog-ts-font-lock-preprocessor-face nil      :foreground "pale goldenrod")
(set-face-attribute 'verilog-ts-font-lock-modport-face nil           :foreground "light blue")
(set-face-attribute 'verilog-ts-font-lock-direction-face nil         :foreground "RosyBrown3")
(set-face-attribute 'verilog-ts-font-lock-translate-off-face nil     :background "gray20" :slant 'italic)
(set-face-attribute 'verilog-ts-font-lock-attribute-face nil         :foreground "orange1")
