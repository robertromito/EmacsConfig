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
      (list 'magit 'ruby-end 'flycheck 'flymake-ruby 'evil 'web-mode 'jsx-mode 'seti-theme))
(dolist (package rmr-required-packages)
  (when (not (package-installed-p package))
    (package-refresh-contents)
    (package-install package)))

; eshell
(load "~/.emacs.d/eshell/eshell.el")

; themes
(load-theme 'seti t)

(require 'evil)
(evil-mode 1)
(show-paren-mode 1)

;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;(load-theme 'rromito t)
(setq ns-use-srgb-colorspace t)

; Stuff to set via config gui
(server-start)

(global-set-key [M-left] 'windmove-left)          ; move to left windnow
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to downer window
(global-set-key (kbd "<C-tab>") 'next-buffer)

; JSX stuff
(require 'flycheck)

(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
	ad-do-it)
    ad-do-it))
(require 'jsx-mode)

(flycheck-define-checker jsxhint-checker
  "A JSX syntax and style checker based on JSXHint."

  :command ("jsxhint" source)
  :error-patterns
  ((error line-start (1+ nonl) ": line " line ", col " column ", " (message) line-end))
  :modes (web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (equal web-mode-content-type "jsx")
              ;; enable flycheck
              (flycheck-select-checker 'jsxhint-checker)
              (flycheck-mode))))

(add-hook 'jsx-mode-hook
          (lambda () (auto-complete-mode 1)))

; git pcomplete stuff
(defconst rmr-git-commands
  '("add" "bisect" "branch" "checkout" "clone"
    "commit" "diff" "fetch" "grep"
    "init" "log" "merge" "mv" "pull" "push" "rebase"
    "reset" "rm" "show" "status" "tag" )
  "List of `git' commands")

(defvar rmr-git-ref-list-cmd "git for-each-ref refs/ --format='%(refname)'"
  "The `git' command to run to get a list of refs")

(defun rmr-git-get-refs (type)
  "Return a list of `git' refs filtered by TYPE"
  (with-temp-buffer
    (insert (shell-command-to-string rmr-git-ref-list-cmd))
    (goto-char (point-min))
    (let ((ref-list))
      (while (re-search-forward (concat "^refs/" type "/\\(.+\\)$") nil t)
        (add-to-list 'ref-list (match-string 1)))
      ref-list)))

(defun pcomplete/git ()
  "Completion for `git'"
  ;; Completion for the command argument.
  (pcomplete-here* rmr-git-commands)
  (cond
   ((pcomplete-match (regexp-opt '("add" "rm")) 1)
    (while (pcomplete-here (pcomplete-entries))))
   ;; provide branch completion for the command `checkout'.
   ((pcomplete-match "checkout" 1)
    (pcomplete-here* (rmr-git-get-refs "heads")))))  


;; Windows specific customizations
(when (eq system-type 'windows-nt)
  (setq-default comint-process-echoes 'on))

;; OSX specific customizations
(when (eq system-type 'darwin)
  (setenv "PATH" (concat "/usr/local/bin" ":" (getenv "PATH"))))
