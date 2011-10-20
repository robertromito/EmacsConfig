; Variables about the location of this file
(setq rmr-emacs-init-file load-file-name)
(setq rmr-emacs-config-dir
      (file-name-directory rmr-emacs-init-file))
(setq user-emacs-directory rmr-emacs-config-dir)

; Have emacs put the ~ backup files into a single directory
(setq backup-directory-alist
      (list (cons "." (expand-file-name "backup" user-emacs-directory))))

; Have emacs write customization system customizations into a different file
(setq custom-file (expand-file-name "emacs-customizations.el" rmr-emacs-config-dir))
(load custom-file)

(server-start)

(setq org-todo-keywords
      '((sequence "TODO(t!)" "ACTIVE(a!)" "|" "DONE(d!)" "CANCELLED(c!)")))

(global-set-key [M-left] 'windmove-left)          ; move to left windnow
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to downer window

