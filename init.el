; My technique for configuring emacs has been borrowed from
; Mr. Avdi Grimm's Emacs Reboot blog series. 
; Read more here: http://devblog.avdi.org/2011/08/08/emacs-reboot-1-beginnings/


; Variables about the location of this file
(setq rmr-emacs-init-file load-file-name)
(setq rmr-emacs-config-dir
      (file-name-directory rmr-emacs-init-file))
(setq user-emacs-directory rmr-emacs-config-dir)

; Have emacs write customization system customizations into a different file
(setq custom-file (expand-file-name "emacs-customizations.el" rmr-emacs-config-dir))
(load custom-file)

; Have emacs put the ~ backup files into a single directory
(setq backup-directory-alist
      (list (cons "." (expand-file-name "backup" user-emacs-directory))))

; Initialize the package manager
(package-initialize)

; Required packages
(setq rmr-required-packages
      (list 'magit 'ruby-end 'rinari 'flymake-ruby 'evil 'csharp-mode 'omnisharp 'company))
(dolist (package rmr-required-packages)
  (when (not (package-installed-p package))
    (package-refresh-contents)
    (package-install package)))

; eshell
(load "~/.emacs.d/eshell/eshell.el")

(require 'evil)
(evil-mode 1)
(setq show-paren-mode 1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'rromito t)

; Stuff to set via config gui
(server-start)

(global-set-key [M-left] 'windmove-left)          ; move to left windnow
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to downer window
(global-set-key (kbd "<C-tab>") 'next-buffer)

; csharp stuff
(add-hook 'csharp-mode-hook 'omnisharp-mode)
(add-hook 'csharp-mode-hook 'company-mode)
(eval-after-load 'company '(add-to-list 'company-backends 'company-omnisharp))
(global-set-key (kbd "C-'") 'company-complete-common)
