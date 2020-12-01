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
  )
(progn ; reduce filesystem clutter
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  )
(save-place-mode 1) ; remember position in file
(use-package helpful
  :config
  (progn
    ;; :config runs after 'helpful loads, so if helpful
    ;; doesn't load (maybe it failed to install) then
    ;; we still have the default help bindings.
    
    ;; The built-in describe-function also covers macros,
    ;; so it corresponds to helpful-callable.
    ;; TODO would be nice if these remappings were provided as
    ;; a global minor mode ("global-helpful-mode"?)
    (global-set-key [remap describe-function] 'helpful-callable)
    (global-set-key [remap describe-key]      'helpful-key)
    (global-set-key [remap describe-symbol]   'helpful-symbol)
    (global-set-key [remap describe-variable] 'helpful-variable)
    ;; TODO C-h m ?
    )
  )

;; What various things do I want?
;; - UI tweaks (colors, toolbar, menu bar, initial buffer)
;; - better window movement?? C-x C-a C-aa C-aaah
;; - git diff in margin
;; - indentation:
;;   - spaces by default, all languages
;;   - manual (use tab/shifttab)

;; - remember some stuff across restarts?
;;   - position in file

;; - elisp:
;;    - fold blocks (hideshow?)
;;    - paredit

;; - C++ IDE:
;;    - indentation
;;    - completion
;;    - format on save
;;    - compile



;; TODO things I might want to try:
;; - 'helpful' - nicer 'help' pages, especially for coding elisp
