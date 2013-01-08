;; Load CEDET
(load-file "/usr/share/emacs/site-lisp/cedet/common/cedet.el")
(global-ede-mode t)

(semantic-load-enable-gaudy-code-helpers)
(semantic-load-enable-secondary-exuberent-ctags-support)
(require 'semantic-ia)  ; names completion and display of tags
;(require 'semantic-gcc) ; auto locate system include files

(defun my-cedet-hook ()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-c=" 'semantic-decoration-include-visit)
  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-cq" 'semantic-ia-show-doc)
  (local-set-key "\C-cs" 'semantic-ia-show-summary)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key "\C-c+" 'semantic-tag-folding-show-block)
  (local-set-key "\C-c-" 'semantic-tag-folding-fold-block)
  (local-set-key "\C-c\C-c+" 'semantic-tag-folding-show-all)
  (local-set-key "\C-c\C-c-" 'semantic-tag-folding-fold-all))
(add-hook 'c-mode-common-hook 'my-cedet-hook)

(global-semantic-tag-folding-mode 1)

;; turn off function header line
(global-semantic-stickyfunc-mode)

(require 'eassist) ;; don't know what the hell is this

(defun dskut/c-mode-cedet-hook ()
  (local-set-key "\C-ct" 'eassist-switch-h-cpp)
  (local-set-key "\C-xt" 'eassist-switch-h-cpp)
  (local-set-key "\C-ce" 'eassist-list-methods)
  (local-set-key "\C-c\C-r" 'semantic-symref)
  )
(add-hook 'c-mode-common-hook 'dskut/c-mode-cedet-hook)

(ede-enable-generic-projects)

;; treat .h-files as cpp (not c) headers
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;; identify standard cpp headers

(require 'cl)

(defun file-in-directory-list-p (file dirlist)
  "Returns true if the file specified is contained within one of
the directories in the list. The directories must also exist."
  (let ((dirs (mapcar 'expand-file-name dirlist))
        (filedir (expand-file-name (file-name-directory file))))
    (and
     (file-directory-p filedir)
     (member-if (lambda (x) ; Check directory prefix matches
                  (string-match (substring x 0 (min(length filedir) (length x))) filedir))
                dirs))))

(defun buffer-standard-include-p ()
  "Returns true if the current buffer is contained within one of
the directories in the INCLUDE environment variable."
  (and (getenv "INCLUDE")
       (file-in-directory-list-p buffer-file-name (split-string (getenv "INCLUDE") path-separator))))

(add-to-list 'magic-fallback-mode-alist '(buffer-standard-include-p . c++-mode))

;; style I want to use in c++ mode
(c-add-style "my-style" 
	     '("stroustrup"
	      (indent-tabs-mode . nil)        ; use spaces rather than tabs
	      (c-basic-offset . 4)            ; indent by four spaces
	      (c-offsets-alist . 
             (
              (inline-open . 0)  ; custom indentation rules
		  	  (brace-list-open . 0)
          	  (statement-case-open . +)
             ))
          ))

(defun my-c++-mode-hook ()
  (c-set-style "my-style")        ; use my-style defined above
  (auto-fill-mode)         
  (c-toggle-hungry-state 1)
  )

(add-hook 'c++-mode-hook 'my-c++-mode-hook) 

;; add emacs code browser
(add-to-list 'load-path "/usr/share/emacs/site-lisp/ecb")
(require 'ecb)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40"))

(setq ecb-auto-activate t)

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "gray20" :foreground "ghost white" 
		:inverse-video nil :box nil :strike-through nil :overline nil :underline nil
		:slant normal :weight normal :height 100 :width normal :foundry "unknown"
		:family "DejaVu Sans Mono"))))
 '(diff-added ((t (:inherit diff-changed :foreground "green"))))
 '(diff-removed ((t (:inherit diff-changed :foreground "red"))))
 '(ecb-default-highlight-face ((((class color) (background dark)) (:inherit hl-line))))
 '(font-lock-warning-face ((t (:foreground "goldenrod" :weight bold))))
 '(hl-line ((t (:background "gray35"))))
 '(match ((t (:foreground "yellow" :weight bold))))
 '(mmm-default-submode-face ((t (:background "gray25"))))
 '(semantic-tag-boundary-face ((((class color) (background dark)) (:overline "#777"))))
 '(trailing-whitespace ((t (:background "red"))))
 '(which-func ((((class color) (min-colors 88) (background dark)) (:foreground "#88f"))))
 '(wl-highlight-folder-many-face ((((class color) (background dark)) (:foreground "#f44"))))
 '(wl-highlight-folder-unread-face ((((class color) (background dark)) (:foreground "yellow")))))

;; haskell mode FIXME!
;; (load-file "/usr/share/emacs/site-lisp/haskell-mode/haskell-mode.el")

;; my keybindings
(global-set-key [(control f7)] 'compile)

;; Emacs will not automatically add new lines
(setq next-line-add-newlines nil)

;; Scroll down with the cursor,move down the buffer one
;; line at a time, instead of in larger amounts.
(setq scroll-step 1)

;; show lines
(global-linum-mode 1)

;; jump to line
(global-set-key "\C-l" `goto-line)

;; auto indentation on RET
(define-key global-map (kbd "RET") 'newline-and-indent)

;; my projects

(ede-cpp-root-project "arcadia-trunk" 
    :file "/home/dskut/ya/arc/trunk/arcadia/CMakeLists.txt")

(ede-cpp-root-project "arcadia-geofocus4" 
    :file "/home/dskut/ya/arc/branch-geofocus4/arcadia/CMakeLists.txt")

(ede-cpp-root-project "arcadia-geofocus5" 
    :file "/home/dskut/ya/arc/branch-geofocus5/arcadia/CMakeLists.txt")

