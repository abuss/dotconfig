;;; Personal configuration -*- lexical-binding: t -*-

;; Save the contents of this file under ~/.emacs.d/init.el
;; Do not forget to use Emacs' built-in help system:
;; Use C-h C-h to get an overview of all help commands.  All you
;; need to know about Emacs (what commands exist, what functions do,
;; what variables specify), the help system can provide.

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

;;; Tune the GC
;; The default settings are too conservative on modern machines making Emacs
;; spend too much time collecting garbage in alloc-heavy code.
(setq gc-cons-threshold (* 4 1024 1024))
(setq gc-cons-percentage 0.3)

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;; Set window size
(setq default-frame-alist '((width . 130) (height . 45)))

; Give some breathing room
(set-fringe-mode 5)

;; Disable the tool bar
(tool-bar-mode -1)

;; Disable the scroll bars
;; (scroll-bar-mode -1)

;; Disable splash screen
(setq inhibit-startup-screen t)

;;; Disable lock files
(setq create-lockfiles nil)
;;; Disable backup files
(setq make-backup-files nil)
;;; Move auto-save files to saner location
(let ((auto-save-dir (file-name-as-directory (expand-file-name "autosave" user-emacs-directory))))
  (setq auto-save-list-file-prefix (expand-file-name ".saves-" auto-save-dir))
  (setq auto-save-file-name-transforms (list (list ".*" (replace-quote auto-save-dir) t))))

;;; Fix scrolling
(setq mouse-wheel-progressive-speed nil)
(setq scroll-margin 3)
(setq scroll-conservatively 100000)
(setq scroll-preserve-screen-position 'always)

;; Enable line numbering in `prog-mode'
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Automatically pair parentheses
(electric-pair-mode t)

(setq window-resize-pixelwise t)
(setq frame-resize-pixelwise t)
(save-place-mode t)
(savehist-mode t)
(recentf-mode t)
(defalias 'yes-or-no #'y-or-n-p)

;;; Search highlight
(setq search-highlight t)
(setq query-replace-highlight t)

;; Load a custom theme
;(load-theme 'wombat t)
;; ************ Theme ******************************
;;; Set the theme
(use-package color-theme-sanityinc-tomorrow)
(defconst init-el-default-theme 'sanityinc-tomorrow-eighties)
(load-theme init-el-default-theme t)
;; (add-hook 'after-make-frame-functions #'init-el-enable-theme)
;; (deftheme init-el-overrides)
;; (cl-macrolet
;;     ((set-face
;;       (face &rest attributes)
;;       `'(,face ((((class color) (min-colors 89)) (,@attributes))))))
;;   (custom-theme-set-faces
;;    'init-el-overrides
;;    (set-face show-paren-match :foreground nil :background nil :underline "#66cccc")
;;    (set-face show-paren-mismatch :foreground nil :background nil :underline "#f2777a")
;;    (set-face rainbow-delimiters-depth-1-face :foreground "#e67c7c")
;;    (set-face rainbow-delimiters-depth-2-face :foreground "#cf9d9d")
;;    (set-face rainbow-delimiters-depth-3-face :foreground "#edb082")
;;    (set-face rainbow-delimiters-depth-4-face :foreground "#d4d484")
;;    (set-face rainbow-delimiters-depth-5-face :foreground "#a0cca0")
;;    (set-face rainbow-delimiters-depth-6-face :foreground "#b3cc8b")
;;    (set-face rainbow-delimiters-depth-7-face :foreground "#9f9fdf")
;;    (set-face rainbow-delimiters-depth-8-face :foreground "#88aabb")
;;    (set-face rainbow-delimiters-depth-9-face :foreground "#c08ad6")))

;; (defun init-el-enable-theme (_frame)
;;   "Enable theme."
;;   (enable-theme init-el-default-theme)
;;   ;; (enable-theme 'init-el-overrides)
;;   ;; (remove-hook 'after-make-frame-functions #'init-el-enable-theme))



;; Set default font face
(set-face-attribute 'default nil :font "FiraCode Nerd Font Mono" :height 128)
;; (use-package fira-code-mode
  ;; :custom (fira-code-mode-disabled-ligatures '("[]" "x"))  ; ligatures you don't want
  ;; :hook prog-mode)

;; (defvar abuss/default-font-size 120)
;; (defvar abuss/default-variable-font-size 120)

;; Font configuration
(set-face-attribute 'default nil :height 120)
;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :height 120)
;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :height 120 :weight 'regular)


;; Tabbar
(use-package centaur-tabs
  :demand
  :config
  ;; (setq centaur-tabs-style "bar")
  ;; (setq centaur-tabs-height 32)
  ;; (setq centaur-tabs-set-icons t)
  ;; (setq centaur-tabs-set-bar 'over)
  ;; (setq centaur-tabs-set-modified-marker t)
  ;; (centaur-tabs-headline-match)
  (centaur-tabs-mode t)
  :bind
  ("M-s-<left>" . centaur-tabs-backward)
  ("M-s-<right>" . centaur-tabs-forward)
  )


;;; ==============
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package which-key
  :config
  (which-key-mode))


;; ******************************************
;; lsp - lenguage server protocol
(defun abuss/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . abuss/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l')
  :bind(:map lsp-mode-map
	      ("C-c d" . lsp-describe-thing-at-point)
	      ("C-c a" . lsp-execute-code-action))
  :bind-keymap ("C-c l" . lsp-command-map)
  :config
  (lsp-enable-which-key-integration t)
  (lsp-inlay-hints-mode t)
  )

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  ;;:custom
  ;;(lsp-ui-doc-position 'bottom)
  )


(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)


;; markdown-mode
(use-package markdown-mode
   :mode ("\\.md\\'" . markdown-mode)
)

;;;; LaTeX
;;(use-package tex-site
;;  :ensure auctex)
;;(add-to-list 'auto-mode-alist '("\\.tex$" . latex-mode))

;; spellcheck in LaTex mode
;;(add-hook `latex-mode-hook `flyspell-mode)
;;(add-hook `tex-mode-hook `flyspell-mode)
;;(add-hook `bibtex-mode-hook `flyspell-mode)

;; GO language support
(use-package go-mode
     :mode ("\\.go$'" . go-mode)
)

;; Lua language support
(use-package lua-mode
     :mode ("\\.lua$'" . lua-mode)
)

;; ;; Rust language support
;; (use-package rust-mode
;;      :mode ("\\.rs$'" . rust-mode)
;; )







(use-package company
  :ensure t
  :hook ((emacs-lisp-mode . (lambda ()
			      (setq-local company-backends '(company-elisp))))
	 (emacs-lisp-mode . company-mode))
  :config
 ; (company-keymap-unbind-quick-access comapny-active-map)
  (company-tng-configure-default)
  (setq company-idle-delay 0.1
	company-minimum-prefix-length 1))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


;; (use-package flycheck
;;   :ensure t)

;; ;; Enabled inline static analysis
;; (add-hook 'prog-mode-hook #'flymake-mode)

;; (use-package undo-tree
;;   :ensure t
;;   :config
;; ;  (evil-set-undo-system 'undo-tree)
;;   (global-undo-tree-mode))

; Completion framework
(use-package vertico
  :config
  (vertico-mode t))

(use-package neotree
  :ensure t)
(global-set-key (kbd "C-\\") 'neotree-toggle)


;;; Git client
(use-package magit
  :ensure t)

;; Bind the `magit-status' command to a convenient key.
(global-set-key (kbd "C-c g") #'magit-status)

;;; Indication of local VCS changes
(use-package diff-hl
  :ensure t)
;; (unless (package-installed-p 'diff-hl)
;;   (package-install 'diff-hl))
;; (straight-use-package 'diff-hl)

;; Enable `diff-hl' support by default in programming buffers
(add-hook 'prog-mode-hook #'diff-hl-mode)

;; Update the highlighting without saving
(diff-hl-flydiff-mode t)

;;; JSON Support
;; (unless (package-installed-p 'json-mode)
;;   (package-install 'json-mode))

;;; Rust Support
(use-package rustic
  :ensure t
  :bind (("<f6>" . rustic-format-buffer))
  :config
  (require 'lsp-rust)
  ;;(setq lsp-rust-analyzer-completion-add-call-parenthesis nil)
  )
;; (setq rustic-lsp-client 'eglot)

;; ;;; YAML Support
;; (use-package yaml-mode
;;   :ensure t)

;; ;;; LaTeX support
;; (unless (package-installed-p 'auctex)
;;   (package-install 'auctex))
;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)
;; (setq-default TeX-master nil)

;; ;; Enable LaTeX math support
;; (add-hook 'LaTeX-mode-map #'LaTeX-math-mode)

;; ;; Enable reference mangment
;; (add-hook 'LaTeX-mode-map #'reftex-mode)

;; ;;; Markdown support
;; (unless (package-installed-p 'markdown-mode)
;;   (package-install 'markdown-mode))

;;; In-Emacs Terminal Emulation
;; (unless (package-installed-p 'eat)
;;   (package-install 'eat))

;; Close the terminal buffer when the shell terminates.
;; (setq eat-kill-buffer-on-exit t)

;; ;; Enable mouse-support.
;; (setq eat-enable-mouse t)

;; Enable CUA key bindings
(cua-mode t)

;;; Vim Emulation
;(use-package evil
;  :ensure t)
;; (unless (package-installed-p 'evil)
;;   (package-install 'evil))

;; Enable Vim emulation in programming buffers
;(add-hook 'prog-mode-hook #'evil-local-mode)

;; Miscellaneous options
;; (setq-default major-mode
;;               (lambda () ; guess major mode from file name
;;                 (unless buffer-file-name
;;                   (let ((buffer-file-name (buffer-name)))
;;                     (set-auto-mode)))))
;; (setq confirm-kill-emacs #'yes-or-no-p)

;; ******************************************
;; Misc

;;; ----------------------------------------
;;; Key bindings
;;; ----------------------------------------
;; toggle tool-bar
(global-set-key (kbd "<f9> t") 'tool-bar-mode)
;; toggle menu-bar
(global-set-key (kbd "<f9> m") 'menu-bar-mode)
;; To be able to move quickly between windows in the frame
(global-set-key [(control tab)]  'other-window)

(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-f") 'isearch-forward)
(global-set-key [f3] 'isearch-repeat-forward)
(global-set-key [(shift f3)] 'isearch-repeat-backward)
;; (global-set-key [(control /)] 'comment-or-uncomment-current-line-or-region)
;(global-set-key [(control /)] 'comment-or-uncomment-region)
;; (global-set-key [f7] 'compile)
;; (global-set-key [f4] 'next-error)
;; (global-set-key [S-f4] 'previous-error)

(use-package yasnippet
  :config
  (yas-global-mode 1))

;(use-package yasnippet-snippets)

;; ----------------------
;; (use-package treemacs
;;   :ensure t)
;;   ;; :defer t
  ;; :init
  ;; (with-eval-after-load 'winum
  ;;   (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  ;; :config
  ;; (progn
  ;;   (setq treemacs-collapse-dirs                 (if (treemacs--find-python3) 3 0)
  ;;         treemacs-deferred-git-apply-delay      0.5
  ;;         treemacs-display-in-side-window        t
  ;;         treemacs-eldoc-display                 t
  ;;         treemacs-file-event-delay              5000
  ;;         treemacs-file-follow-delay             0.2
  ;;         treemacs-follow-after-init             t
  ;;         treemacs-git-command-pipe              ""
  ;;         treemacs-goto-tag-strategy             'refetch-index
  ;;         treemacs-indentation                   2
  ;;         treemacs-indentation-string            " "
  ;;         treemacs-is-never-other-window         nil
  ;;         treemacs-max-git-entries               5000
  ;;         treemacs-missing-project-action        'ask
  ;;         treemacs-no-png-images                 nil
  ;;         treemacs-no-delete-other-windows       t
  ;;         treemacs-project-follow-cleanup        nil
  ;;         treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
  ;;         treemacs-recenter-distance             0.1
  ;;         treemacs-recenter-after-file-follow    nil
  ;;         treemacs-recenter-after-tag-follow     nil
  ;;         treemacs-recenter-after-project-jump   'always
  ;;         treemacs-recenter-after-project-expand 'on-distance
  ;;         treemacs-show-cursor                   nil
  ;;         treemacs-show-hidden-files             t
  ;;         treemacs-silent-filewatch              nil
  ;;         treemacs-silent-refresh                nil
  ;;         treemacs-sorting                       'alphabetic-desc
  ;;         treemacs-space-between-root-nodes      t
  ;;         treemacs-tag-follow-cleanup            t
  ;;         treemacs-tag-follow-delay              1.5
  ;;         treemacs-width                         35)

  ;;   ;; The default width and height of the icons is 22 pixels. If you are
  ;;   ;; using a Hi-DPI display, uncomment this to double the icon size.
  ;;   ;;(treemacs-resize-icons 44)

  ;;   (treemacs-follow-mode t)
  ;;   (treemacs-filewatch-mode t)
  ;;   (treemacs-fringe-indicator-mode t)
  ;;   (pcase (cons (not (null (executable-find "git")))
  ;;                (not (null (treemacs--find-python3))))
  ;;     (`(t . t)
  ;;      (treemacs-git-mode 'deferred))
  ;;     (`(t . _)
  ;;      (treemacs-git-mode 'simple))))
  ;; :bind
  ;; (:map global-map
  ;;       ("M-0"       . treemacs-select-window)
  ;;       ("C-x t 1"   . treemacs-delete-other-windows)
  ;;       ("C-\\   "   . treemacs)
  ;;       ("C-x t B"   . treemacs-bookmark)
  ;;       ("C-x t C-t" . treemacs-find-file)
  ;;       ("C-x t M-t" . treemacs-fin-dttag)
  ;;       ;; ("<left>" . treemacs-togglenode)
  ;;       ;; ("<right>" . treemacs-toggle-node)
  ;;       )
  ;; )

;; (use-package treemacs-magit
;;   :after treemacs magit
;;   :ensure t)

;; (use-package lsp-treemacs
;;   :after lsp)

;; recentf stuff
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 15)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; Expand-region
(use-package expand-region
  :ensure expand-region
  :bind ("C-=" . er/expand-region))

;; Save position in files
(require 'saveplace)
(setq-default save-place t)

;; Highlight FIXME, TODO and BUG keywords
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t))))
	  )

;; Comment/uncomment a regior or line
(defun comment-or-uncomment-current-line-or-region ()
  "Comments or uncomments current current line or whole lines in region."
  (interactive)
  (save-excursion
    (let (min max)
      (if (and transient-mark-mode mark-active)
          (setq min (region-beginning) max (region-end))
        (setq min (point) max (point)))
      (comment-or-uncomment-region
       (progn (goto-char min) (line-beginning-position))
       (progn (goto-char max) (line-end-position))))))

;;(global-set-key (kbd "C-\/") 'comment-or-uncomment-region)
(global-set-key [(control /)] 'comment-or-uncomment-current-line-or-region)

;; Drag-stuff
;(use-package drag-stuff
;  :config (drag-stuff-global-mode t)
;)
;(drag-stuff-define-keys)

;; eshell-toogle
(use-package eshell-toggle
  :ensure t)
(global-set-key (kbd "C-j") 'eshell-toggle)




;; Store automatic customisation options elsewhere
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

