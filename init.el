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
(progn ; no gui
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  (setq inhibit-startup-screen t)
  )
(progn ; ui behavior
  (defalias 'yes-or-no-p 'y-or-n-p)
  (save-place-mode 1)
  (setq help-window-select t)
  ;; TODO help/compile/magit in-place? no split/popup
  )
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
  :config (add-hook 'emacs-lisp-mode-hook 'hs-org/minor-mode))
(use-package paredit
  :config (add-hook 'emacs-lisp-mode-hook 'paredit-mode))
(use-package magit)

;; What various things do I want?
;; - UI tweaks (colors, toolbar, menu bar, initial buffer)
;; - better window movement?? C-x C-a C-aa C-aaah
;; - git diff in margin
;; - indentation:
;;   - spaces by default, all languages
;;   - manual (use tab/shifttab)

;; - finding files in git

;; - C++ IDE:
;;    - indentation
;;    - completion
;;    - format on save
;;    - compile
