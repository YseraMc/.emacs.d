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
;; (global-linum-mode t)

;; カーソル行を強調表示
(global-hl-line-mode t)

;;括弧
(setq show-paren-delay 0)
(show-paren-mode t)

;;音消す
(setq ring-bell-function 'ignore)

;; マウス操作
(xterm-mouse-mode t)
(mouse-wheel-mode t)
(global-set-key [mouse-4] '(lambda () (interactive) (scroll-down 3)))
(global-set-key [mouse-5] '(lambda () (interactive) (scroll-up   3)))



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
