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
  ;; problems: if
  (setq use-package-always-ensure t)
  ;; TODO consider use-package-always-defer
  (setq use-package-compute-statistics t)
  ;; TODO try borg?
  ;; - submodules (more declarative, easier to contribute)
  ;; - simpler than straight.el?
  ;; - annoying terminology :(
  ;; - no dependency resolution...
  ;; TODO try straight.el?
  ;; - handles installation more declaratively?
  ;; - easier to edit / contribute to packages?
  ;; https://github.com/raxod502/straight.el
  (setq use-package-verbose t)
  )
(progn ; gui appearance
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  (setq inhibit-startup-screen t)
  ;; TODO color theme
  )
(progn ; ui behavior
  (defalias 'yes-or-no-p 'y-or-n-p)
  (save-place-mode 1)
  (setq help-window-select t)

  ;; When displaying a buffer (as in compile, help, git), I generally
  ;; want to use the 'same' window to avoid creating splits. The
  ;; exception is: if the buffer is already open in some window, I
  ;; want to 'reuse' it to avoid having the same buffer open twice.
  (setq display-buffer-base-action '((display-buffer-reuse-window
				      display-buffer-same-window
				      )))

  ;; Use paths to disambiguate buffer names.
  ;; (As opposed to the funky default angle-bracket notation.)
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-strip-common-suffix nil)

  ;; TODO better window navigation (windmove?)
  )
(progn ; editing behavior
  (setq-default fill-column 80)
  (setq-default indent-tabs-mode nil)
  ;; TODO less aggressive indentation? let me manually tab/untab?
  )
;; general
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
  :hook ((emacs-lisp-mode . hs-hide-all)
	 (emacs-lisp-mode . hs-org/minor-mode)))
(use-package magit
  :defer t)
(use-package paren
  :hook (prog-mode . show-paren-mode)
  )
(use-package git-gutter
  :hook prog-mode)
; TODO git file navigation
(use-package undo-tree
  :init (global-undo-tree-mode))
;; lisp
(use-package paredit
  :hook (emacs-lisp-mode . paredit-mode))
;; TODO C++
;;    - indentation
;;    - completion
;;    - format on save
;;    - compile

;; TODO js
