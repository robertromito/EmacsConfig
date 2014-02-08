;;; eshell.el --- Eshell customizations

(defun pwd-replace-home (pwd)
  (interactive)
  (let* ((home (expand-file-name (getenv "HOME")))
         (home-len (length home)))
    (if (and
         (>= (length pwd) home-len)
         (equal home (substring pwd 0 home-len)))
        (concat "~" (substring pwd home-len))
      pwd)))

(defun pwd-shorten-dirs (pwd)
  (let ((p-lst (split-string pwd "/")))
    (if (> (length p-lst) 3)
        (concat
         (mapconcat (lambda (elm) (if (zerop (length elm)) ""
                                    (substring elm 0 1)))
                    (butlast p-lst 3)
                    "/")
         "/"
         (mapconcat (lambda (elm) elm)
                    (last p-lst 3)
                    "/"))
      (mapconcat (lambda (elm) elm)
                 p-lst
                 "/"))))

(defun cur-dir-git-branch-string (pwd)
  (interactive)
  (if (and (eshell-search-path "git")
	   (locate-dominating-file pwd ".git"))
      (let* ((git-cmd "git branch")
	     (grep-cmd "grep '\\*'")
	     (sed-cmd "sed -e 's/^\\* //'")
	     (git-output (shell-command-to-string (concat git-cmd " | " grep-cmd " | " sed-cmd))))
	(concat "["
		(if (> (length git-output) 0)
		    (substring git-output 0 -1)
		  "(no branch)")
		"] ") ) ""))

(defun rmr-eshell-prompt-fn ()
  (concat
   (propertize (cur-dir-git-branch-string (eshell/pwd)) 'face '(:foreground "green"))
   (pwd-shorten-dirs (pwd-replace-home (eshell/pwd)))
   " $ "))

(setq eshell-prompt-regexp "^[^#$]*[#$] ")
(setq eshell-prompt-function 'rmr-eshell-prompt-fn)
(setq eshell-highlight-prompt nil)

(provide 'eshell-settings)

