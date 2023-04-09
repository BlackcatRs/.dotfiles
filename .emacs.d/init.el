(setq inhibit-startup-message t) ; Hide welcome message
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Load a package call "package" to handle package fuctions 
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; Automatically update the list of packages, only if there is no package list already
(when (not package-archive-contents)
    (package-refresh-contents))

;; Intall use-package if not exists, fuction ends with p return bolean
;; like package-installed-p
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t) 	; Ensure that the package is loaded

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; Highlight cursor pointing line
(hl-line-mode)

;; Display key pressed
;; (use-package command-log-mode)


;; flexible, simple tools for minibuffer completion in Emacs
;; Ivy vs counsel vs Swiper:
;; Ivy, a generic completion mechanism for Emacs.
;; Counsel, a collection of Ivy-enhanced versions of common Emacs commands.
;; Swiper, an Ivy-enhanced alternative to Isearch.

;; No need to manually install swiper or ivy, it will install as dependencies with counsel
(use-package counsel
  :diminish
  :bind (("C-s" . swiper)
	 ("C-x C-f" . counsel-find-file)
	 ("M-x" . counsel-M-x)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-n" . ivy-next-line)
         ("C-p" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))


;; Key mapping directly inside swiper config
;; (use-package swiper
;;   :ensure try
;;   :config
;;   (progn
;;     (ivy-mode 1)
;;     (setq ivy-use-virtual-buffers t)
;;     (global-set-key "\C-s" 'swiper)
;;     (global-set-key (kbd "C-c C-r") 'ivy-resume)
;;     (global-set-key (kbd "<f6>") 'ivy-resume)
;;     (global-set-key (kbd "M-x") 'counsel-M-x)
;;     (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;;     (global-set-key (kbd "<f1> f") 'counsel-describe-function)
;;     (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;;     (global-set-key (kbd "<f1> l") 'counsel-load-library)
;;     (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;;     (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;;     (global-set-key (kbd "C-c g") 'counsel-git)
;;     (global-set-key (kbd "C-c j") 'counsel-git-grep)
;;     (global-set-key (kbd "C-c k") 'counsel-ag)
;;     (global-set-key (kbd "C-x l") 'counsel-locate)
;;     (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;;     (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
;;     ))

;; Bottom bar
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 20)))

;; Download doom themes
(use-package doom-themes)
(load-theme 'doom-one t)


;; Show parentheese
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Display keys that follows the prefix key
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

;; Show a description of each function that displayed by running
;; counsel-M-x
(use-package ivy-rich
  :init
  (ivy-rich-mode))

;; Beautify help text, ex C-h 
(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Projectile provide features operating on project level.
(use-package projectile
  :diminish projectile-mode
  ;; Load projectile mode globally
  :config (projectile-mode)
  ;; ivy is the completion system to be used by Projectile
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/git")
    (setq projectile-project-search-path '("~/git")))
  (setq projectile-switch-project-action #'projectile-dired))

;; cousel-projectile provide more action when pressing Alt-o in
;; mini-buffer when using projectile-switch-project
(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  ;; Stop creating a new window when doing diff
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Open a file as sudo
(defun sudo-find-file (file-name)
  "Like find file, but opens the file as root."
  (interactive "FSudo Find File: ")
  (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
    (find-file tramp-file-name)))

;; Press Ctrl+c and Ctrl+s to run sudo-find-file function
(global-set-key (kbd "C-c C-s") 'sudo-find-file)

;; Assembly language highlighting
(use-package nasm-mode)

;; Powershell mode
(use-package powershell)

;; Mardown language highlighting
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package yaml-mode)
;; (require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-hook 'yaml-mode-hook
      '(lambda ()
        (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(use-package toc-org)
(if (require 'toc-org nil t)
    (progn
      (add-hook 'org-mode-hook 'toc-org-mode)

      ;; enable in markdown, too
      (add-hook 'markdown-mode-hook 'toc-org-mode)
      (define-key markdown-mode-map (kbd "\C-c\C-o") 'toc-org-markdown-follow-thing-at-point))
  (warn "toc-org not found"))

;; Save all emacs backup files (files ending in ~) in ~/.emacs.d/backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
 )

;; Adjust this font size for your system!
(defvar runemacs/default-font-size 100)

(set-face-attribute 'default nil :font "Fira Code Retina" :height runemacs/default-font-size)
;; ;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 100)
;; ;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 110 :weight 'regular)

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces (display options like font, size, etc) for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

;; Activate some option in Org mode
(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (org-overview) ;; Show only headings
  (forward-page)) ;; Goto the bottom of the page


;; 1st solution for " IMPORTANT: please install Org from GNU ELPA as Org ELPA will close before Org 9.6"
;; (use-package org
;;    :pin gnu)

;; 2nd solution for " IMPORTANT: please install Org from GNU ELPA as Org ELPA will close before Org 9.6"
;; (use-package org
;;   :ensure org-plus-contrib)
  
;; https://github.com/jwiegley/use-package/issues/319#issuecomment-845214233
;; (assq-delete-all 'org package--builtins)
;; (assq-delete-all 'org package--builtin-versions)


(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾" ;; Replace ... at the end of each headings with ▾
	;; Output the result string instead of showing synctaxe.
	;; e.g : *Bold* transforme into bold text.  
	org-hide-emphasis-markers t)

  (efs/org-font-setup))

;; Change headings bullet points using org-bullets package
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  ;; Wrap a line when it exceeds the width defined by
  ;; visual-fill-column-width instead of truncating it by placing \n
  ;; at the end of the line.
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  ;; Call the org-mode-visual-fill to set parms of visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))
;; End -  Emacs From Scratch #5 - Org Mode Basics --------------------

;; Press enter key on the task in agenda will open the task file
(setq org-return-follows-link t
      org-agenda-tags-column 75
      ;; Display all tasks with deadline 30 days
      org-deadline-warning-days 30
      ;; Use single key to execute an action
      org-use-speed-commands t)

(setq org-agenda-files (list
                        "~/lab/emacs/test_files/TODO.org"
                        "~/lab/emacs/test_files/Events.org"
                        "~/lab/emacs/test_files/Repeaters.org"))

;; Custom states 
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	;; This states store a timestamp and note
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))

;; Capture tasks
(setq org-capture-templates
      '(("t" "Add task (Reference a file)" entry (file "~/lab/emacs/test_files/TODO.org")
         "* TODO %?\n  %i\n  %a")
        ("w" "Add task" entry (file "~/lab/emacs/test_files/TODO.org")
         "* TODO %?\n  %i\n  ")))

;; Dashboard
(setq org-agenda-custom-commands
      '((" " "Agenda"
         ((agenda ""
                  ((org-agenda-span 'day)))
          (todo "TODO"
                ((org-agenda-overriding-header "Unscheduled tasks")
                 (org-agenda-files '("~/lab/emacs/test_files/TODO.org"))
                 (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))
                 ))
          (todo "TODO"
                ((org-agenda-overriding-header "Unscheduled project tasks")                                                   
                 (org-agenda-files '("~/lab/emacs/test_files/Events.org"))
                 (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))))))))

;; global keyboard shortcuts
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c a") #'org-agenda)

;; Start - Checking and Correcting Spelling --------------------------

;; This section describes the commands to check the spelling of a single
;; word or of a portion of a buffer. These commands only work if a
;; spelling checker program, one of Hunspell, Aspell, Ispell or Enchant,
;; is installed. These programs are not part of Emacs, but can be
;; installed. So install aspell, aspell-fr aspell-en.

;; Tell Emacs to use Aspell instead of the default spell checker. Use
;; command 'which aspell' from the shell to get the path to Aspell's
;; executable.
(setq ispell-program-name "/usr/bin/aspell")

;; Set default language to spell 
(setq ispell-local-dictionary "english")

;; Quickly switch language by pressing F10 key.
;; Adapted from DiogoRamos' snippet on https://www.emacswiki.org/emacs/FlySpell#h5o-5
(let ((langs '("francais" "english")))
  (defvar lang-ring (make-ring (length langs))
    "List of Ispell dictionaries you can switch to using ‘cycle-ispell-languages’.")
  (dolist (elem langs) (ring-insert lang-ring elem)))

(defun cycle-ispell-languages ()
  "Switch to the next Ispell dictionary in ‘lang-ring’."
  (interactive)
  (let ((lang (ring-ref lang-ring -1)))
    (ring-insert lang-ring lang)
    (ispell-change-dictionary lang)))

(global-set-key [f10] #'cycle-ispell-languages) ; replaces ‘menu-bar-open’.

;; Activate flyspell-mode for markdown-mode or other modes (e.g
;; text-modes)
(dolist (hook '(markdown-mode-hook org-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

;; Stop flyspell-mode for change-log-mode and log-edit-mode.
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))

;; Check the buffer and light up errors with "langtool" we use the
;; langtool-check function each time we save the buffer using
;; after-save-hook.
(use-package langtool)
(add-hook 'markdown-mode-hook	  
          (lambda () 
             (add-hook 'after-save-hook 'langtool-check nil 'make-it-local)))
;; End - Checking and Correcting Spelling ----------------------------

;; Function to clear the Emacs shell buffer, we can also use
;; comint-clear-buffer which is bound to C-c M-o in Emacs v25+
;; voc = vts own config
(defun voc/clear-term ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

;; Map voc/clear-term to C-c l key
(defun voc/shell-hook ()
  (local-set-key "\C-cl" 'voc/clear-term))

;; Use this shortcut only in shell mode
(add-hook 'shell-mode-hook 'voc/shell-hook)
