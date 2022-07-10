;; Keep custom-set-variables and friends out of my init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(add-to-list 'default-frame-alist '(font . "Iosevka-14.5"))

(require 'package)

(add-to-list 'exec-path "/usr/local/bin")

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(setq package-check-signature nil)

(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))
(setq custom-safe-themes t)

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(defun zerodouglas/comment-paragraph ()
  (interactive)
  (save-excursion
    (mark-paragraph)
    (comment-or-uncomment-region (region-beginning) (region-end))))

(global-set-key (kbd "C-c c") 'zerodouglas/comment-paragraph)

(require 'use-package)

(defun eglot-format-buffer-on-save ()
  (add-hook 'before-save-hook #'eglot-format-buffer -10 t))
(add-hook 'go-mode-hook #'eglot-format-buffer-on-save)

(global-set-key (kbd "<f2>") 'kmacro-start-macro)
(global-set-key (kbd "<f3>") 'kmacro-end-macro)
(global-set-key (kbd "<f4>") 'call-last-kbd-macro)

(use-package emacs
  :bind
  ("C-x C-b" . ibuffer))

(use-package which-key
  :init
  (which-key-mode))

(use-package scala-mode
  :commands (scala-mode)
  :interpreter
  ("scala" . scala-mode))

(use-package envrc
  :config
  :hook (prog-mode . envrc-global-mode))

(repeat-mode 1)

(setq-default
 fill-column 80
 mark-ring-max 6
 global-mark-ring-max 6
 left-margin-width 1
 sentence-end-double-space nil
 kill-whole-line t)

(require 'go-mode)

(use-package eglot
  :ensure t
  :hook ((haskell-mode go-mode) . eglot-ensure)
  :custom
  (eglot-autoshutdown t)
  (eglot-autoreconnect nil)
  (eglot-confirm-server-initiated-edits nil)
  (eldoc-idle-delay 1)
  (eldoc-echo-area-display-truncation-message nil)
  (eldoc-echo-area-use-multiline-p 2))

(use-package corfu
  :defer t
  :custom
  (corfu-auto-delay 0.2)
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-commit-predicate nil)
  (corfu-quit-at-boundary t)
  (corfu-quit-no-match t)
  (corfu-echo-documentation nil)
  :config
  (global-corfu-mode))

(use-package vertico
  :init
  (defvar last-file-name-handler-alist nil)
  (vertico-mode))

(use-package paredit
  :defer t
  :diminish
  :mode ("\\.el\\'" . emacs-lisp-mode)
  :hook ((scheme-mode emacs-lisp-mode) . enable-paredit-mode))

(use-package nix-mode
  :defer t
  :mode ("\\.nix\\'" . nix-mode))

(use-package orderless
  :init
  (setq completion-styles '(orderless)
    completion-category-defaults nil
    orderless-skip-highlighting t
    completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :config
  (setq consult-preview-key nil)
  (recentf-mode)
  :bind
  ("C-c r" . consult-recent-file)
  ("C-c f" . consult-ripgrep)
  ("C-c l" . consult-line)
  ("C-c i" . consult-imenu)
  ("C-c t" . gtags-find-tag)
  ("C-x b" . consult-buffer))

(load-theme `wilmersdorf t)

(defun zerodouglas/kill-current-buffer ()
  "Kill current buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(defun zerodouglas/dired-up-directory ()
  "Up directory - killing current buffer."
  (interactive)
  (let ((cb (current-buffer)))
    (progn (dired-up-directory)
       (kill-buffer cb))))

(defun zerodouglas/copy-dwim ()
  "Run the command `kill-ring-save' on the current region
or the current line if there is no active region."
  (interactive)
  (if (region-active-p)
      (kill-ring-save nil nil t)
    (kill-ring-save (point-at-bol) (point-at-eol))))

(put 'narrow-to-region 'disabled nil)

(global-set-key (kbd "C-x k") 'zerodouglas/kill-current-buffer)
(global-set-key (kbd "M-w") 'zerodouglas/copy-dwim)

(use-package dired
  :ensure nil
  :config
  (setq dired-recursive-copies t
	dired-recursive-deletes t
	dired-dwim-target t
	delete-by-moving-to-trash t)
  :bind* (:map dired-mode-map
	       ("-" . zerodouglas/dired-up-directory)))
