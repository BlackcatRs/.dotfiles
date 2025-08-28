;; Method 1
(require 'org)
(org-babel-load-file "~/.dotfiles/.config/emacs/README.org")

;; Method 2
;(setq org-babel-load-languages '((emacs-lisp . t)))
;(setq org-confirm-babel-evaluate nil)
;(require 'org-install)
;(require 'org)

;(org-babel-load-file "~/.emacs.d/config.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(counsel-projectile dockerfile-mode doom-modeline doom-themes helpful
			hideshowvis ivy-rich langtool magit
			markdown-mode nasm-mode org-bullets org-mime
			org-roam org-roam-ui org-wild-notifier ox-hugo
			powershell rainbow-delimiters rainbow-mode
			toc-org visual-fill-column web-mode which-key
			yaml-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
