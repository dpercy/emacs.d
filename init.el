(progn ; gui appearance
  (load-theme 'manoj-dark)
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  (setq inhibit-startup-screen t)
  ;; TODO trim mode line more?
  )
(progn ; reduce filesystem clutter
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  )
(progn ; custom.el
  (setq custom-file "~/.emacs.d/custom.el")
  (ignore-errors (load custom-file))
  )
(progn ; package.el, use-package
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (package-initialize)
  (unless package-archive-contents
    ;; Download the list of package names from each site.
    (package-refresh-contents))
  (unless (package-installed-p 'use-package)
    (package-install 'use-package))
  (require 'use-package)

  ;; always-ensure makes the first startup slow, and may make the first startup
  ;; fail if some package changed. But leaving always-ensure false also has
  ;; problems: I don't want to overwrite global keybindings with ones that don't work.
  (setq use-package-always-ensure t)
  (setq use-package-always-defer t)
  (setq use-package-compute-statistics t)
  ;; TODO try straight.el?
  ;; - handles installation more declaratively?
  ;; - easier to edit / contribute to packages?
  ;; https://github.com/raxod502/straight.el
  (setq use-package-verbose t)
  )
(progn ; ui behavior

  ;; persistence
  (save-place-mode 1)
  (savehist-mode 1)

  ;; minibuffer
  (defalias 'yes-or-no-p 'y-or-n-p)
  (setq enable-recursive-minibuffers t)
  (minibuffer-depth-indicate-mode 1)

  ;; window management
  (setq help-window-select t)
  ;; When displaying a buffer (as in compile, help, git), I generally
  ;; want to use the 'same' window to avoid creating splits. The
  ;; exception is: if the buffer is already open in some window, I
  ;; want to 'reuse' it to avoid having the same buffer open twice.
  (setq display-buffer-base-action '((display-buffer-reuse-window
				      display-buffer-same-window
				      )))
  (global-set-key (kbd "M-`") 'other-window)

  ;; Use paths to disambiguate buffer names.
  ;; (As opposed to the funky default angle-bracket notation.)
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-strip-common-suffix nil)

  (global-auto-revert-mode 1)
  )
(progn ; editing behavior
  (setq-default fill-column 80)
  (setq-default indent-tabs-mode nil)
  ;; TODO less aggressive indentation? let me manually tab/untab?
  ;; https://dougie.io/emacs/indentation/#using-tabs-or-spaces-in-different-files
  (setq backward-delete-char-untabify-method 'hungry)

  (add-hook 'prog-mode-hook 'show-paren-mode)

  (global-set-key (kbd "<f5>") 'recompile)
  )
;; general
(use-package diminish) ; hide from modeline
(use-package helpful
  :bind (
	 ;; The built-in describe-function also covers macros,
	 ;; so it corresponds to helpful-callable.
	 ;; TODO would be nice if these remappings were provided as
	 ;; a global minor mode ("global-helpful-mode"?)
	 ([remap describe-function] . helpful-callable)
	 ([remap describe-key]      . helpful-key)
	 ([remap describe-symbol]   . helpful-symbol)
	 ([remap describe-variable] . helpful-variable)
	 ;; TODO C-h m ?
	 ))
(use-package hideshow-org
  :diminish hs-minor-mode
  :hook ((prog-mode . hs-org/minor-mode)))
(use-package magit)
(use-package git-gutter
  :diminish
  :config (global-git-gutter-mode))
; TODO git file navigation
(use-package undo-tree
  :diminish
  :init (global-undo-tree-mode))
(use-package dumb-jump
  :init (add-hook 'xref-backend-functions 'dumb-jump-xref-activate))
;; lisp
(use-package paredit
  :hook (emacs-lisp-mode . paredit-mode))
(diminish 'eldoc-mode)
;; TODO C++
;;    - indentation
;;    - completion?
;;    - format on save
;;    - compile

;; TODO js
