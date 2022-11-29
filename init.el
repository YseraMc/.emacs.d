(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))
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
;; leaf拡張
(leaf leaf-convert :ensure t)

;; バックアップファイル
(setq backup-directory-alist '((".*" . "~/.backup")))

;; 自動保存ファイルリスト
(setq auto-save-list-file-prefix nil)

;; ロックファイル
(setq create-lockfiles nil)

;; テーマ
(leaf monokai-theme
  :doc "A fruity color theme for Emacs."
  :url "http://github.com/oneKelvinSmith/monokai-emacs"
  :added "2022-11-28"
  :ensure t
  :config (load-theme 'monokai t)
  (set-face-background 'region "DarkGreen")
  )

;;文字コード
(prefer-coding-system 'utf-8)

;; カラム番号
(column-number-mode t)

;; 行番号
(global-linum-mode t)

;; カーソル行を強調表示
(global-hl-line-mode t)

;;括弧
(setq show-paren-delay 0)
(show-paren-mode t)

;; カーソル見た目
(add-to-list 'default-frame-alist '(cursor-type . bar))

;;音消す
(setq ring-bell-function 'ignore)

;; メニューバー
(unless (eq window-system 'ns)
  (menu-bar-mode 0))

;; ツールバー
(when window-system
  (tool-bar-mode 0)
  (scroll-bar-mode 0))

;; スタートメニュー
(setq inhibit-startup-message t)

;; マウス操作
(xterm-mouse-mode t)
(mouse-wheel-mode t)
(global-set-key [mouse-4] '(lambda () (interactive) (scroll-down 3)))
(global-set-key [mouse-5] '(lambda () (interactive) (scroll-up   3)))

;; ファイルツリー
(leaf neotree
  :doc "A tree plugin like NerdTree for Vim"
  :req "cl-lib-0.5"
  :url "https://github.com/jaypei/emacs-neotree"
  :added "2022-11-28"
  :ensure t
  :bind ([f8] . 'neotree-toggle)
  :init (leaf all-the-icons
          :doc "A library for inserting Developer icons"
          :req "emacs-24.3"
          :tag "lisp" "convenient" "emacs>=24.3"
          :url "https://github.com/domtronn/all-the-icons.el"
          :added "2022-11-28"
          :emacs>= 24.3
          :ensure t)
  :config (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-show-hidden-files t)
  )

;; ウィンドウ自動サイズ変更
(leaf golden-ratio
  :doc "Automatic resizing of Emacs windows to the golden ratio"
  :tag "resizing" "window"
  :added "2022-11-28"
  :ensure t
  :config (golden-ratio-mode 1)
  (add-to-list 'golden-ratio-exclude-buffer-names " *NeoTree*"))

;; ウィンドウ操作
(global-set-key (kbd "<C-left>")  'windmove-left)
(global-set-key (kbd "<C-down>")  'windmove-down)
(global-set-key (kbd "<C-up>")    'windmove-up)
(global-set-key (kbd "<C-right>") 'windmove-right)

;; eshell + shell-pop
(leaf shell-pop
  :doc "helps you to use shell easily on Emacs. Only one key action to work."
  :req "emacs-24" "cl-lib-0.5"
  :tag "tools" "terminal" "shell" "emacs>=24"
  :url "http://github.com/kyagi/shell-pop-el"
  :added "2022-11-28"
  :emacs>= 24
  :ensure t
  :config (setq shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
  (global-set-key (kbd "C-c o") 'shell-pop))

;; fish mode
(leaf fish-mode
  :ensure t
  :setq
  (fish-enable-auto-indent . t)
  :mode ("\\.fish$"))

;; 括弧自動補完
(leaf smartparens
  :doc "Automatic insertion, wrapping and paredit-like navigation with user defined pairs."
  :req "dash-2.13.0" "cl-lib-0.3"
  :tag "editing" "convenience" "abbrev"
  :url "https://github.com/Fuco1/smartparens"
  :added "2022-11-29"
  :ensure t
  :hook (after-init-hook . smartparens-global-strict-mode) ; strictモードを有効化
  :require smartparens-config
  :custom ((electric-pair-mode . nil)))

;; 括弧色分け
(leaf rainbow-delimiters
  :doc "Highlight brackets according to their depth"
  :tag "tools" "lisp" "convenience" "faces"
  :url "https://github.com/Fanael/rainbow-delimiters"
  :added "2022-11-29"
  :ensure t
  :hook
  ((prog-mode-hook       . rainbow-delimiters-mode)))

;; インデント強調
(leaf highlight-indent-guides
  :doc "Minor mode to highlight indentation"
  :req "emacs-24.1"
  :tag "emacs>=24.1"
  :url "https://github.com/DarthFennec/highlight-indent-guides"
  :added "2022-11-29"
  :emacs>= 24.1
  :ensure t
  :blackout t
  :hook (((prog-mode-hook yaml-mode-hook) . highlight-indent-guides-mode))
  :custom (
           (highlight-indent-guides-method . 'character)
           (highlight-indent-guides-auto-enabled . t)
           (highlight-indent-guides-responsive . t)
           (highlight-indent-guides-character . ?\|)))

;; 空白・タブ強調
(leaf whitespace
  :doc "minor mode to visualize TAB, (HARD) SPACE, NEWLINE"
  :tag "builtin"
  :added "2022-11-29"
  :ensure t
  :commands whitespace-mode
  :bind ("C-c W" . whitespace-cleanup)
  :custom ((whitespace-style . '(face
                                trailing
                                tabs
                                spaces
                                empty
                                space-mark
                                tab-mark))
           (whitespace-display-mappings . '((space-mark ?\u3000 [?\u25a1])
                                            (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
           (whitespace-space-regexp . "\\(\u3000+\\)")
           (whitespace-global-modes . '(emacs-lisp-mode shell-script-mode sh-mode python-mode org-mode))
           (global-whitespace-mode . t))

  :config
  (set-face-attribute 'whitespace-trailing nil
                      :background "Black"
                      :foreground "DeepPink"
                      :underline t)
  (set-face-attribute 'whitespace-tab nil
                      :background "Black"
                      :foreground "LightSkyBlue"
                      :underline t)
  (set-face-attribute 'whitespace-space nil
                      :background "Black"
                      :foreground "GreenYellow"
                      :weight 'bold)
    (set-face-attribute 'whitespace-empty nil
                        :background "Black"))

;; コードの先頭・末尾への移動と行頭・行末への移動
(leaf mwim
  :doc "Switch between the beginning/end of line or code"
  :tag "convenience"
  :url "https://github.com/alezost/mwim.el"
  :added "2022-11-29"
  :ensure t
  :bind (("C-a" . mwim-beginning-of-code-or-line)
            ("C-e" . mwim-end-of-code-or-line)))

;; コード補完
(leaf company
  :doc "Modular text completion framework"
  :req "emacs-25.1"
  :tag "matching" "convenience" "abbrev" "emacs>=25.1"
  :url "http://company-mode.github.io/"
  :added "2022-11-29"
  :emacs>= 25.1
  :ensure t
  :leaf-defer nil
  :blackout company-mode
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("C-i" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-tooltip-limit         . 12)
           (company-idle-delay            . 0) ;; 補完の遅延なし
           (company-minimum-prefix-length . 2) ;; 1文字から補完開始
           (company-transformers          . '(company-sort-by-occurrence))
           (global-company-mode           . t)
           (company-selection-wrap-around . t)))

;; スニペット
(leaf yasnippet
  :doc "Yet another snippet extension for Emacs"
  :req "cl-lib-0.5"
  :tag "emulation" "convenience"
  :url "http://github.com/joaotavora/yasnippet"
  :added "2022-11-29"
  :ensure t
  :blackout yas-minor-mode
      :custom ((yas-indent-line . 'fixed)
               (yas-global-mode . t)
                                     )
      :bind ((yas-keymap
              ("<tab>" . nil))            ; conflict with company
             (yas-minor-mode-map
              ("C-c y i" . yas-insert-snippet)
              ("C-c y n" . yas-new-snippet)
              ("C-c y v" . yas-visit-snippet-file)
              ("C-c y l" . yas-describe-tables)
              ("C-c y g" . yas-reload-all)))
      :config
      (leaf yasnippet-snippets :ensure t)
      (leaf yatemplate
        :ensure t
        :config
        (yatemplate-fill-alist))
      (defvar company-mode/enable-yas t
        "Enable yasnippet for all backends.")
      (defun company-mode/backend-with-yas (backend)
        (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
            backend
          (append (if (consp backend) backend (list backend))
                  '(:with company-yasnippet))))
      (defun set-yas-as-company-backend ()
        (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
        )
      :hook
      ((company-mode-hook . set-yas-as-company-backend))
      )

;; docker tramp
(leaf docker-tramp
  :doc "TRAMP integration for docker containers"
  :req "emacs-24" "cl-lib-0.5"
  :tag "convenience" "docker" "emacs>=24"
  :url "https://github.com/emacs-pe/docker-tramp.el"
  :added "2022-11-30"
  :emacs>= 24
  :ensure t)

;; LSP
(leaf lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :config
  :custom ((lsp-keymap-prefix                  . "C-c l")
           (lsp-log-io                         . t)
           (lsp-keep-workspace-alive           . nil)
           (lsp-document-sync-method           . 2)
           (lsp-response-timeout               . 5)
           (lsp-enable-file-watchers           . nil))
  :hook (lsp-mode-hook . lsp-headerline-breadcrumb-mode)
  :init (leaf lsp-ui
          :ensure t
          :after lsp-mode
          :custom ((lsp-ui-doc-enable            . t)
                   (lsp-ui-doc-position          . 'at-point)
                   (lsp-ui-doc-header            . t)
                   (lsp-ui-doc-include-signature . t)
                   (lsp-ui-doc-max-width         . 150)
                   (lsp-ui-doc-max-height        . 30)
                   (lsp-ui-doc-use-childframe    . nil)
                   (lsp-ui-doc-use-webkit        . nil)
                   (lsp-ui-peek-enable           . t)
                   (lsp-ui-peek-peek-height      . 20)
                   (lsp-ui-peek-list-width       . 50))
          :bind ((lsp-ui-mode-map ([remap xref-find-definitions] .
                                   lsp-ui-peek-find-definitions)
                                  ([remap xref-find-references] .
                                   lsp-ui-peek-find-references))
                 (lsp-mode-map ("C-c s" . lsp-ui-sideline-mode)
                               ("C-c d" . lsp-ui-doc-mode)))
          :hook ((lsp-mode-hook . lsp-ui-mode))))

;; LSP python
(leaf lsp-pyright
  :ensure t
  :hook (python-mode-hook . (lambda ()
                              (require 'lsp-pyright)
                              (lsp-deferred))))

(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(blackout el-get hydra leaf-keywords leaf)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
