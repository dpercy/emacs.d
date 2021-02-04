(progn ; gui appearance
  (dolist (f '(menu-bar-mode
	       tool-bar-mode
	       scroll-bar-mode
	       fringe-mode))
    (when (fboundp f)
      (funcall f 0)))
  (setq inhibit-startup-screen t)

  (add-hook 'package-menu-mode-hook 'hl-line-mode))
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
  (global-subword-mode 1)

  ;; TODO this is incompatible with hs-org/minor mode...
  (defun manually-indent (beg end &optional n)
    (interactive (if (use-region-p)
                     (list (region-beginning) (region-end))
                   (list (point) (point))))
    (let ((beg (save-excursion
                 (goto-char beg)
                 (forward-line 0)
                 (point)))
          (end (save-excursion
                 (goto-char end)
                 (forward-line 1)
                 (point))))
      (save-excursion
        (indent-rigidly beg end (* (or n 1) c-basic-offset)))
      (setq deactivate-mark nil)))
  (defun manually-dedent (beg end &optional n)
    (interactive (if (use-region-p)
                     (list (region-beginning) (region-end))
                   (list (point) (point))))
    (manually-indent beg end (- (or n 1))))
  (define-minor-mode manually-indent-mode
    "Try to be less aggressive about indentation: use tab/backtab."
    :lighter ""
    :group 'editing
    :keymap '(keymap (backtab . manually-dedent) (tab . manually-indent)))
  
  (setq backward-delete-char-untabify-method 'hungry)

  (add-hook 'prog-mode-hook 'show-paren-mode)

  (defun compile-project ()
    (interactive)
    (let ((root (car (project-roots (project-current)))))
      (setq compilation-directory root)
      ;; TODO detect whether compile-command is set?
      ;; so it can prompt only the first time.
      (recompile)))
  (global-set-key (kbd "<f5>") 'compile-project)

  ;; dwim
  (global-set-key [remap upcase-word] 'upcase-dwim)
  (global-set-key [remap downcase-word] 'downcase-dwim)
  (global-set-key [remap capitalize-word] 'capitalize-dwim)

  ;; TODO "back button" (as package?)
  )
;; general
(use-package cyberpunk-theme :demand
  :init
  (progn
    (load-theme 'cyberpunk)
    ;; 9.0pt corresponds to 12 pixels?
    (set-face-attribute 'default nil :height 90)
    (when (eq window-system 'mac)
      ;; Text appears smaller on my Mac; maybe the screen is denser.
      (set-face-attribute 'default nil :height 120))
    (set-face-attribute 'font-lock-comment-face nil :slant 'normal)
    ))
(use-package diminish) ; hide from modeline
(use-package helpful
  :bind (
	 ;; The built-in describe-function also covers macros,
	 ;; so it corresponds to helpful-callable.
	 ([remap describe-function] . helpful-callable)
	 ([remap describe-key]      . helpful-key)
	 ([remap describe-symbol]   . helpful-symbol)
	 ([remap describe-variable] . helpful-variable)
	 ))
(use-package hideshow-org
  :diminish hs-minor-mode
  :hook ((prog-mode . hs-org/minor-mode)))
(use-package magit)
(use-package diff-hl
  :init (progn
          (global-diff-hl-mode 1)
          (diff-hl-margin-mode 1)
          (add-hook 'dired-mode-hook 'diff-hl-dired-mode)

          (set-face-attribute 'diff-hl-insert nil :foreground "green" :background "darkgreen")
          (set-face-attribute 'diff-hl-delete nil :foreground "red" :background "darkred")
          (set-face-attribute 'diff-hl-change nil :foreground "yellow" :background "#444400")
          
          (set-face-attribute 'diff-refine-added nil
                              :foreground "#88ff88" :background "#001100")
          (set-face-attribute 'diff-refine-removed nil
                              :foreground "#ff8888" :background "#330000")
          ))
(use-package projectile
  ;; projectile seems to be faster than the built-in project.el.
  ;; TODO remap find-file to something that uses projectile OR find-file...
  :diminish
  :init (progn
            (projectile-mode 1)
            ;; There seems to be an undeclared dependency on string-trim?
            (require 'subr-x)))
(use-package selectrum
  ;; projectile needs some kind of fuzzy matching to work well;
  ;; selectrum is one of the choices.
  :init (selectrum-mode 1))
(use-package selectrum-prescient
  ;; selectrum-prescient seems to understand acronyms:
  ;; I can type "ds sort" to get "document_source_sort.h".
  :init (selectrum-prescient-mode 1))
(use-package undo-tree
  :diminish
  :init (global-undo-tree-mode))
(use-package dumb-jump
  :init (add-hook 'xref-backend-functions 'dumb-jump-xref-activate))
;; lisp
(use-package paredit
  :hook (emacs-lisp-mode . paredit-mode))
(progn ;; smaller modeline
  ;; TODO what do I really want here?
  ;; - dirty status
  ;; - buffer name
  ;; - line number / out of
  ;; - mode??? or do I even care?
  
  (diminish 'eldoc-mode)
  (diminish 'subword-mode)
  (setq mode-line-format (remove '(vc-mode vc-mode) mode-line-format)))

;; TODO something about nicer shortcuts? C-x C-c M-pinky C-pain

;; TODO C++
;;    - indentation
;;    - completion?
;;    - format on save
;;    - compile

;; TODO js
