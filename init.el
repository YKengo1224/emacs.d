;;;
;;; General
;;;

;;バックアップファイルをすべてこのディレクトリに作成するよう設定
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


;;welcome screenを非表示
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

;;
;;org-mode config
;;
(setq org-export-latex-coding-system 'utf-8)
(setq org-export-latex-date-format "%Y-%m-%d")
(setq org-export-latex-classes nil)
(add-to-list 'org-export-latex-classes
  '("jsarticle"
    "\\documentclass[a4j]{jsarticle}"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
    ("\\paragraph{%s}" . "\\paragraph*{%s}")
    ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
))
(setq org-export-latex-packages-alist
  '(("AUTO" "inputenc"  t)
    ("T1"   "fontenc"   t)
    ))
;;; LaTeX 形式のファイル PDF に変換するためのコマンド
(setq org-latex-pdf-process
      '("platex %f"
        "platex %f"
        "bibtex %b"
        "platex %f"
        "platex %f"
        "dvipdfmx %b.dvi"))
;;;
;;; Anthy on Emacs
;;;日本語入力(aptでAnthyをインストールする必要あり)
;; (setq default-input-method "japanese-egg-anthy")


;;package
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			                      ("gnu" . "http://elpa.gnu.org/packages/")))
(require 'package)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-verilog fkycheck rustic lsp-ui cargo rust-mode company-irony irony verilog-ext package-utils php-mode all-the-icons eldoc-box which-key use-package mozc mew company eglot)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;自動補完機能
(require 'company)
(global-company-mode 1)
(setq company-backends (remove 'company-clang company-backends))
(define-key company-active-map (kbd "C-n") #'company-select-next)
(define-key company-active-map (kbd "C-p") #'company-select-previous)
(define-key company-active-map (kbd "C-h") nil)
(define-key company-active-map (kbd "C-S-h") #'company-show-doc-buffer)

(setq company-transformers '(company-sort-by-backend-importance))
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 2)
(setq company-selection-wrap-around t)
(setq company-deabbrev-downcase nil)

;;行番号を表示
(global-display-line-numbers-mode)
(setq display-line-numbers-widen t)
(setq display-line-numbers-mode-start 3)

(setq initial-scratch-message nil)


;; mew default settings
;; (setq mew-mail-domain-list '("pca.cis.nagasaki-u.ac.jp"))
;; (let ((menu-bar (lookup-key global-map [menu-bar])))
;;   (define-key-after (lookup-key menu-bar [tools]) [rmail]
;;     '("Mew (read/write mail)" . mew)
;;     [rmail]))
;; (add-hook 'mew-draft-mode-hook
;;           (lambda ()
;;             (Set-Buffer-File-coding-system 'junet)))
;; (setq mew-icon-directory "/opt/share/emacs/site-lisp/mew/etc/")
;; (setq mew-smtp-server "pcamx.cis.nagasaki-u.ac.jp")
;; (setq mew-mailbox-type 'mbox)
;; (setq mew-mbox-command "incm")
;; (setq mew-mbox-command-arg (concat "-d " (concat (getenv "HOME") "/.Maildir/")))

;; yatex
;; (setq auto-mode-alist
;;   (cons (cons "\.tex$" 'yatex-mode) auto-mode-alist))
;; (autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
;; (add-to-list 'load-path "/opt/share/emacs/site-lisp/yatex")
;; (setq YaTeX-help-file "/opt/share/emacs/site-lisp/yatex/help/YATEXHLP.eng")
(setq tex-command "platex")
(setq dvi2-command "xdvi")
(setq tex-pdfview-command "evince")

;; ;;
;; (autoload 'sfl-mode "sfl-mode-c" "SFL editing mode" t)
;; (setq auto-mode-alist (cons (cons "\\.sfl" 'sfl-mode) auto-mode-alist))

;;Mozcの設定(aptでemacs-mozc-binをインストールする必要あり)
(require 'mozc)
(setq default-input-method "japanese-mozc")
(setq mozc-candidate-style 'echo-area)
 (global-set-key "\C-o" 'toggle-input-method)

;;テーマの設定
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
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :hook
  (after-init . doom-modeline-mode)
)

;; (use-package ace-window
;;   :ensure t
;;   :functions hydra-frame-window/body
;;   :bind
;;   ("C-M-o" . hydra-frame-window/body)
;;   :custom
;;   (aw-keys '(?j ?k ?l ?i ?o ?h ?y ?u ?p))
;;   :custom-face
;;   (aw-leading-char-face ((t (:height 4.0 :foreground "#f1fa8c"))))
;;   )
 



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
  (show-paren-when-point-in-periphery t))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :hook (after-init . which-key-mode))

(use-package eldoc-box
  :ensure t
  :hook (eglot-managed-mode . eldoc-box-hover-at-point-mode))

(use-package all-the-icons
  :ensure t)

;;;;;;;;;;
;;;php
(use-package php-mode
  :ensure t
  :config
  (setq php-mode-coding-style 'psr2)
  (setq php-mode-indent-num-args 4)
  (setq php-mode-indent-line t)
  (setq php-mode-require-semi nil)
  )



;; (require 'eglot)
;; (add-hook 'c-mode-hook #'eglot-ensure)
;; (use-package eglot
;;   :ensure t
;;   :config
;;   (add-to-list 'eglot-server-programs '(c++-mode . ("ccls")))
;;   (add-to-list 'eglot-server-programs '(rustic-mode . ("rust-analyzer")))
;;   (add-hook 'c++-mode-hook 'eglot-ensure)
;;   (add-hook 'rustic-mode-hook 'eglot-ensure)
;;   (define-key eglot-mode-map (kbd "C-c e f") 'eglot-format)
;;   (define-key eglot-mode-map (kbd "C-c e n") 'eglot-rename)  
;;   )

;;fkycheck
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode t)
  )


;;flymake
;; (use-package flymake
;;   :init
;;   (add-hook 'c-mode-common-hook 'flymake-mode)
;;   :commands
;;   flymake-mode
;;  )


;; setup Rust development
(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))

(use-package rust-mode
  :ensure t
  :custom rust-format-on-save t)
(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))


(use-package rustic
  :ensure t
  
 )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;#lsp

(use-package lsp-mode
  :ensure t
  :init (yas-global-mode)
  :hook((verilog-mode c-mode c++-mode rust-mode) . lsp)
  :bind("C-c h" . lsp-describe-thing-at-point)
  :custom
  (lsp-rust-server 'rust-analyzer)
  :config
  (setq lsp-clients-clangd-executable "ccls")
  )
(use-package lsp-ui
  :ensure t)





;; Add this after your current company configuration
;; (use-package company-verilog
;;   :ensure t
;;   :config
;;   (add-to-list 'company-backends 'company-verilog))


(use-package verilog-mode
  :ensure t
  :mode ("\\.v\\'" "\\.sv\\'")
  :hook (verilog-mode . my-verilog-mode-hook)
  :config
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("svls"))
		    :major-modes '(verilog-mode)
		    :priority -1
		    ))
  (setq verilog-auto-newline t
        verilog-tab-always-indent t
        verilog-indent-level 3
        verilog-indent-level-behavioral 3
        verilog-indent-level-declaration 3
        verilog-indent-level-module 3)
  (defun my-verilog-mode-hook ()
    (font-lock-mode 1)
    (setq indent-tabs-mode nil)))


;;;;;setup maxima
 (add-to-list 'load-path "/usr/share/emacs/site-lisp/maxima/")
 (autoload 'maxima-mode "maxima" "Maxima mode" t)
 (autoload 'imaxima "imaxima" "Frontend for maxima with Image support" t)
 (autoload 'maxima "maxima" "Maxima interaction" t)
 (autoload 'imath-mode "imath" "Imath mode for math formula input" t)
 (setq imaxima-use-maxima-mode-flag t)
 (add-to-list 'auto-mode-alist '("\\.ma[cx]\\'" . maxima-mode))
