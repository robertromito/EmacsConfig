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
