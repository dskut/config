;; Load CEDET
(load-file "/usr/share/emacs/site-lisp/cedet/common/cedet.el")
(global-ede-mode t)

(semantic-load-enable-gaudy-code-helpers)
(semantic-load-enable-secondary-exuberent-ctags-support)
(require 'semantic-ia)

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
	      (c-offsets-alist . ((inline-open . 0)  ; custom indentation rules
				  (brace-list-open . 0)
				  (statement-case-open . +)))))

(defun my-c++-mode-hook ()
  (c-set-style "my-style")        ; use my-style defined above
  (auto-fill-mode)         
  (c-toggle-auto-hungry-state 1))

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
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(setq ecb-auto-activate t)