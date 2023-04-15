;; Method 1
(require 'org)
(org-babel-load-file "~/.dotfiles/.emacs.d/README.org")

;; Method 2
;(setq org-babel-load-languages '((emacs-lisp . t)))
;(setq org-confirm-babel-evaluate nil)
;(require 'org-install)
;(require 'org)

;(org-babel-load-file "~/.emacs.d/config.org")
