;;; init.el --- My init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; My init.el.

;;; Code:

;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/{{pkg}}/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu"   . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; ここにいっぱい設定を書く


;;warningを無視
(setq warning-minimum-level :emergency)




(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom((imenu-list-size . 30)
            (imenu-list-position . 'left))
    )
  )


;;テーマの設定
(leaf doom-themes
  :ensure t
  :init
  (let ((custom--inhibit-theme-enable nil))
    (unless (memq 'use-package custom-known-themes)
      (deftheme use-package)
      (enable-theme 'use-package)
      (setq custom-enabled-themes (remq 'use-package custom-enabled-themes)))
    (custom-theme-set-variables 'use-package
				'(doom-themes-enable-italic t nil nil "Customized with use-package doom-themes")
				'(doom-themes-enable-bold t nil nil "Customized with use-package doom-themes")))
  (apply #'face-spec-set
	 (backquote
	  (doom-modeline-bar
	   ((t
	     (:background "#6272a4"))))))
  :require t
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-neotree-config)
  (doom-themes-org-config))


(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))


;;バックアップファイルをすべてこのディレクトリに作成するよう設定
(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            ;; (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "auto-save-files") t)))
            ;; (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup-files"))
            (auto-save-file-name-transforms . '((".*" ,"~/.eamcs.d/auto-save-files" t)))
            (backup-directory-alist . '((".*" . ,"~/.emacs.d/backup-files")

                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))


;; ;;welcome screenを非表示
;; (leaf leaf-convert
;;   :setq ((inhibit-startup-message . t)))(mouse-wheel-mode t)
;; ;;ツールバーを非表示
;; (leaf leaf-convert
;;   :config
;;   (tool-bar-mode 0)
;;   (menu-bar-mode 0)
;;   (electric-pair-mode t))

;;welcome screenを非表示
;;ツールバーを非表示
;;括弧などのオートペアリングを有効
;;正規表現による置換をAlt+qにセット
;;tab -> space 4
;;行番号を表示
(leaf leaf-convert
  :setq ((inhibit-startup-message . t)
         (display-line-numbers-widen . t)
	 (display-line-numbers-mode-start . 3)
	 (initial-scratch-message))
  :setq-default ((tab-width . 1)
		 (indent-tabs-mode))
  :config
  (mouse-wheel-mode t)
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (electric-pair-mode t)
  (global-display-line-numbers-mode))





;;Out revert
(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 1))
  :global-minor-mode global-auto-revert-mode)


;;cc-mode
(leaf cc-mode
  :doc "major mode for editing C and similar languages"
  :tag "builtin"
  :defvar (c-basic-offset)
  :bind (c-mode-base-map
         ("C-c c" . compile))
  :mode-hook
  (c-mode-hook . ((c-set-style "bsd")
                  (setq c-basic-offset 4)))
  (c++-mode-hook . ((c-set-style "bsd")
                    (setq c-basic-offset 4))))


;;タブ補完強化
(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t))

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)
  
(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)


(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "compat-29.1.3.4" "dash-20221013" "git-commit-20230101" "magit-section-20230101" "seq-2.24" "transient-20230201" "with-editor-20230118"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :url "https://github.com/magit/magit"
  :added "2023-10-05"
  :emacs>= 25.1
  :ensure t
  :after compat git-commit magit-section with-editor)

;;eglot
(leaf eglot
  :doc "The Emacs Client for LSP servers"
  :tag "builtin"
  :added "2023-10-05"  
  :ensure t
  :config
  (add-hook 'cc-mode-hook 'eglot-ensure)
  (add-hook 'rust-mode-hook 'eglot-ensure)
  ;; (define-key eglot-mode-map (kbd "C-c e f") 'eglot-format)
  ;; (define-key eglot-mode-map (kbd "C-c e n") 'eglot-rename)
  )




(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "minor-mode" "tools" "languages" "convenience" "emacs>=24.3"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)


(leaf company
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode)


(leaf company-c-headers
  :doc "Company mode backend for C/C++ header files"
  :req "emacs-24.1" "company-0.8"
  :tag "company" "development" "emacs>=24.1"
  :added "2020-03-25"
  :emacs>= 24.1
  :ensure t
  :after company
  :defvar company-backends
  :config
  (add-to-list 'company-backends 'company-c-headers))


;;;;rust config

(defun my/find-rust-project-root (dir)                                                                           
   (when-let ((root (locate-dominating-file dir "Cargo.toml")))                                                         
     (list 'vc 'Git root)))

(defun my/rust-mode-hook ()
  (setq-local project-find-functions (list #'my/find-rust-project-root)))

(add-hook 'rust-mode-hook #'my/rust-mode-hook)


(leaf leaf-convert
  :config
  (leaf rust-mode
    :ensure t
    :init
    (let ((custom--inhibit-theme-enable nil))
      (unless (memq 'use-package custom-known-themes)
        (deftheme use-package)
        (enable-theme 'use-package)
        (setq custom-enabled-themes (remq 'use-package custom-enabled-themes)))
      (custom-theme-set-variables 'use-package
                                  '(rust-format-on-save t nil nil "Customized with use-package rust-mode")))
    :require t)

  (leaf cargo
    :ensure t
    :commands cargo-minor-mode
    :hook ((rust-mode-hook . cargo-minor-mode)))

  (leaf rustic
    :ensure t
    :require t))
;;;;;



(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
