(setq rmr-emacs-init-file load-file-name)
(setq rmr-emacs-config-dir
      (file-name-directory rmr-emacs-init-file))

; Have emacs write customization system customizations into a different file
(setq custom-file (expand-file-name "emacs-customizations.el" rmr-emacs-config-dir))
(load custom-file)
