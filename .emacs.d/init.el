;; Basic UI Configuration ------------------------------------------------------

;; Hide welcome message
(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
;; (setq visible-bell t)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Load a package call "package" to handle package fuctions 
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; 1st solution for " IMPORTANT: please install Org from GNU ELPA as Org ELPA will close before Org 9.6"
;; (use-package org
;;    :pin gnu)

;; 2nd solution for " IMPORTANT: please install Org from GNU ELPA as Org ELPA will close before Org 9.6"
;; (use-package org
;;   :ensure org-plus-contrib)
  
;; https://github.com/jwiegley/use-package/issues/319#issuecomment-845214233
;; (assq-delete-all 'org package--builtins)
;; (assq-delete-all 'org package--builtin-versions)


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


;; ;; Custom keybings  ------------------------------------------------------------

;; ;; general.el provides a more convenient method for binding keys in
;; ;; emacs (for both evil and non-evil users). Like use-package, which
;; ;; provides a convenient, unified interface for managing packages,
;; ;; general.el is intended to provide a convenient, unified interface
;; ;; for key definitions.
;; ;; https://github.com/noctuid/general.el
;; (use-package general
;;   :config
;;   ;; general-create-definer create a function leader-keys in rune
;;   ;; namespace (like a folder for config specific stuffs) which store
;;   ;; key definition
;;   (general-create-definer rune/leader-keys
;;     ;; :keymaps '(normal insert visual emacs)
;;     :prefix "C-c"
;;     :global-prefix "C-c")
  
;;   ;; This will provide a list of item to choose when C-c is pressed
;;   (rune/leader-keys
;;     "t"  '(:ignore t :which-key "toggles")
;;     "tt" '(counsel-load-theme :which-key "choose theme")))


;; ;; evil package vim keybinding for emacs
;; (use-package evil
;;   :init
;;   ;; load to load evil-integration.el.
;;   (setq evil-want-integration t)
;;   ;; turn-off evil from loading default keybindings and use
;;   ;; evil-collection insted for keybindings
;;   (setq evil-want-keybinding nil)
;;   ;; C-u is by default bind to universal-argument but in evil mode bind
;;   ;; to scroll up. universal-argument is a way to change a fucntion's
;;   ;; behavior by providing a prefiex arguement. For more info
;;   ;; https://www.emacswiki.org/emacs/PrefixArgument
;;   (setq evil-want-C-u-scroll t)
;;   ;; disable default C-i binding in evil mode which is used to jump
;;   ;; forward
;;   (setq evil-want-C-i-jump nil)

;;   :config
;;   ;; Turn on evil mode globally
;;   (evil-mode 1)		
;;   ;; C-g or ESC will exit from insert mode to normal mode
;;   (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
;;   ;; C-h bind to back
;;   (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

;;   ;; Treat the visual line as a new line, otherwise evil treats the
;;   ;; visually wrapped line as a single line, so the j and k keys will
;;   ;; traverse that line to the next line
;;   (evil-global-set-key 'motion "j" 'evil-next-visual-line)
;;   (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

;;   ;; start a buffer in normal mode instead of insert mode
;;   (evil-set-initial-state 'messages-buffer-mode 'normal)
;;   (evil-set-initial-state 'dashboard-mode 'normal))


;; (use-package evil-collection
;;   :after evil
;;   :config
;;   (evil-collection-init))

;; ;; Hydra gives a panel with an action bound to certain keys without the need to press multiple key combinations
;; (use-package hydra)

;; (defhydra hydra-text-scale (:timeout 4)
;;   "scale text"
;;   ("j" text-scale-increase "in")
;;   ("k" text-scale-decrease "out")
;;   ("f" nil "finished" :exit t))

;; (rune/leader-keys
;;   "ts" '(hydra-text-scale/body :which-key "scale text"))
;; ;;  ----------------------------------------------------------------------------



;; Start -  Emacs From Scratch #4 - Projectile and Magit  ------------
;; https://www.youtube.com/watch?v=INTu30BHZGk

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

;; Manage git notif, issues, pull request, etc from emacs 
;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
;; (use-package forge)

;; End -  Emacs From Scratch #4 - Projectile and Magit  --------------







;; Run a command as sudo
(defun sudo-shell-command (command)
  (interactive "MShell command (root): ")
  (with-temp-buffer
    (cd "/sudo::/")
    (async-shell-command command)))

;; Open a file as sudo
(defun sudo-find-file (file-name)
  "Like find file, but opens the file as root."
  (interactive "FSudo Find File: ")
  (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
    (find-file tramp-file-name)))

;; Press Ctrl+c and Ctrl+s to run sudo-find-file function
(global-set-key (kbd "C-c C-s") 'sudo-find-file)

;; masm-mode is a major mode for editing MASM x86 and x64 assembly
;; code. It includes syntax highlighting, automatic comment
;; indentation and various build commands.
;; (use-package masm-mode)

;; A major mode for editing NASM x86 assembly programs. It includes
;; syntax highlighting, automatic indentation, and imenu integration.
;; Unlike Emacs' generic `asm-mode`, it understands NASM-specific
;; syntax.
(use-package nasm-mode)

;; Save all emacs backup files (files ending in ~) in ~/.emacs.d/backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
 )

;; I don't need this
;; This command run rofi with specified config file
;; (defun rofi ()
;;   (interactive)
;;   (shell-command
;;    "rofi -show drun -config /home/vts/git/dotfiles/.config/rofi/config.rasi"
;;    t))

;; Shorcut to run rofi fuction define just before
;; (global-set-key (kbd "C-c r") 'rofi)

;; Powershell mode
(use-package powershell)

;; markdown-mode is a major mode for editing Markdown-formatted text.
;; This mode provide syntaxe highlight and some shortcuts
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;; Highligh cursor pointing line
(hl-line-mode)


;; Font Configuration ----------------------------------------------------------
;; Adjust this font size for your system!
(defvar runemacs/default-font-size 100)

(set-face-attribute 'default nil :font "Fira Code Retina" :height runemacs/default-font-size)
;; ;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 100)
;; ;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 110 :weight 'regular)

;; Start -  Emacs From Scratch #5 - Org Mode Basics ------------------
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

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾" ;; Replace ... at the end of each headings with ▾
	;; Output the result string instead of showing synctaxe.
	;; e.g : *Bold* transforme into bold text.  
	org-hide-emphasis-markers t)

  ;; Start - Emacs From Scratch #6 - Organize Your Life with Org Mode --
  ;; Path to search for agenda agenda files
  (setq org-agenda-files
	'("~/.dotfiles/.emacs.d/task.org"
	  "~/.dotfiles/.emacs.d/Habits.org"
	  "~/.dotfiles/.emacs.d/Birthday.org"))

  ;; Track the evolution of something, this presents evolution in a form of process bar
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  ;; Adding custom states 
  (setq org-todo-keywords
	'((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
	  (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))


  (setq org-refile-targets
	'(("Archive.org" :maxlevel . 1)
	  ("task.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  ;; C-c C-q to select interactivly tags
  ;; OR
  ;; counsel-org-tag and press alt+enter to select multiple tags
  (setq org-tag-alist
	'((:startgroup)
					; Put mutually exclusive tags here
	  (:endgroup)
	  ("@errand" . ?E)
	  ("@home" . ?H)
	  ("@work" . ?W)
	  ("agenda" . ?a)
	  ("planning" . ?p)
	  ("publish" . ?P)
	  ("batch" . ?b)
	  ("note" . ?n)
	  ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
	;; Add a shortcut (letter d) in the org-agenda command collection
	'(("d" "Dashboard"
	   ((agenda "" ((org-deadline-warning-days 7)))

	    ;; Display only tasks with NEXT state in dashboard
	    (todo "NEXT"
		  ((org-agenda-overriding-header "Next Tasks")))
	    ;; Display only tasks with tag :agenda: and state ACTIVE
	    (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

	  ;; Add a shortcut (letter n) in the org-agenda command collection to view only tasks with NEXT state.
	  ("n" "Next Tasks"
	   ((todo "NEXT"
		  ((org-agenda-overriding-header "Next Tasks")))))

	  ;; Shortcut (letter W) to view only tasks with tag work and without tag email
	  ("W" "Work Tasks" tags-todo "+work-email")

	  ;; Add shortcut (letter e) in org-agenda to show tasks with property Effort less than 15 and greater than 0.
	  ;; C-c C-x p to set property Effort from default sets of properties
	  ;; OR
	  ;; C-c C-x e to set Effort
	  ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
	   ((org-agenda-overriding-header "Low Effort Tasks")
	    (org-agenda-max-todos 20)
	    (org-agenda-files org-agenda-files)))

	  ;; Shortcut (letter w) give an overview of following states in a buffer
	  ("w" "Workflow Status"
	   ((todo "WAIT"
		  ((org-agenda-overriding-header "Waiting on External")
		   (org-agenda-files org-agenda-files)))
	    (todo "REVIEW"
		  ((org-agenda-overriding-header "In Review")
		   (org-agenda-files org-agenda-files)))
	    (todo "PLAN"
		  ((org-agenda-overriding-header "In Planning")
		   (org-agenda-todo-list-sublevels nil)
		   (org-agenda-files org-agenda-files)))
	    (todo "BACKLOG"
		  ((org-agenda-overriding-header "Project Backlog")
		   (org-agenda-todo-list-sublevels nil)
		   (org-agenda-files org-agenda-files)))
	    (todo "READY"
		  ((org-agenda-overriding-header "Ready for Work")
		   (org-agenda-files org-agenda-files)))
	    (todo "ACTIVE"
		  ((org-agenda-overriding-header "Active Projects")
		   (org-agenda-files org-agenda-files)))
	    (todo "COMPLETED"
		  ((org-agenda-overriding-header "Completed Projects")
		   (org-agenda-files org-agenda-files)))
	    (todo "CANC"
		  ((org-agenda-overriding-header "Cancelled Projects")
		   (org-agenda-files org-agenda-files)))))))


  (setq org-capture-templates
	`(("t" "Tasks / Projects")
	  ("tt" "Task" entry (file+olp "~/Projects/Code/emacs-from-scratch/OrgFiles/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

	  ("j" "Journal Entries")
	  ("jj" "Journal" entry
           (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
	  ("jm" "Meeting" entry
           (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

	  ("w" "Workflows")
	  ("we" "Checking Email" entry (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

	  ("m" "Metrics Capture")
	  ("mw" "Weight" table-line (file+headline "~/Projects/Code/emacs-from-scratch/OrgFiles/Metrics.org" "Weight")
	   "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

  ;; Agenda view to show only today's tasks
  ;; (setq org-agenda-span 'day)

  ;; Add verbose to agenda view
  (setq org-agenda-start-with-log-mode t)
  ;; Show the closed time in agenda view
  (setq org-log-done 'time)
  ;; Show details in a foldable section
  (setq org-log-into-drawer t)
  ;; End - Emacs From Scratch #6 - Organize Your Life with Org Mode ----

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











;; Start -  Emacs Tips - How to Show Reminders for Org Mode Tasks  ---
(use-package org-alert
  :ensure t
  :custom (alert-default-style 'notifications)
  :config
  (setq org-alert-interval 300
	org-alert-notification-title "Org Alert Reminder")
  (org-alert-enable))



;; End - Emacs Tips - How to Show Reminders for Org Mode Tasks  ------













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

;; Major mode to edit YAML file
(use-package yaml-mode)
;; (require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-hook 'yaml-mode-hook
      '(lambda ()
        (define-key yaml-mode-map "\C-m" 'newline-and-indent)))


;; Start - Build a Second Brain in Emacs -----------------------------

;; ;; This section is inspired by this video
;; https://www.youtube.com/playlist?list=PLEoMzSkcN8oN3x3XaZQ-AXFKv52LZzjqD

;; Getting Started with Org Roam - Build a Second Brain in Emacs
;; https://www.youtube.com/watch?v=AyhPmypHDEw&list=PLEoMzSkcN8oN3x3XaZQ-AXFKv52LZzjqD

;; Org Roam is an extension to Org Mode which help to create
;; topic-focused Org files and link them together.  It's is inspied by
;; a program called Roam and a note-taking strategy called
;; Zettlekasten.

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/RoamNotes")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
  ;; "d" is the key to press to choose the template
  ;; "plain" is the type of text being inserted
  '(("d" "default" plain
     ;; "%?" is org mode syntax which indicate cursor where to land in a node file
     "%?"
     ;; Heading to insert in node files 
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
     ;; Expand the node files or show the entire content of the file without folding
     :unnarrowed t)

    ("l" "programming language" plain
     "* Characteristics\n\n- Family: %?\n- Inspired by: \n\n* Reference:\n\n"
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
     :unnarrowed t)))

  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
	 :map org-mode-map
	 ("C-M-i    .  completion-at-point"))
  :config
  ;; Reload the custom keybindings that defined above
  (org-roam-setup))
;; End - Build a Second Brain in Emacs -------------------------------


;; Capturing Notes Efficiently in Emacs with Org Roam ----------------
;; End - Capturing Notes Efficiently in Emacs with Org Roam ----------


;; Start - Emacs Mail ------------------------------------------------
;; This section is inspired by these videos
;; https://www.youtube.com/playlist?list=PLEoMzSkcN8oN3x3XaZQ-AXFKv52LZzjqD

;; Start - Streamline Your E-mail Management with mu4e - Emacs Mail --
;; https://www.youtube.com/watch?v=yZRyEhi4y44&list=PLEoMzSkcN8oM-kA19xOQc8s0gr0PpFGJQ
(use-package mu4e
  ;; using :ensure nil because we installed mu4e using the distro's
  ;; package manager to stay compatible with mbsync
  :ensure nil
  :defer 20 ; Wait until 20 seconds after startup
  ;; Path where the package manager is installed mu2e files
  ;; :load-path "/usr/share/emacs/site-lisp/mu4e/"
  ;; :defer 20 ; Wait until 20 seconds after startup
  :config

  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/Mail")

  ;;  If your Gmail is set up with a different lanugage you also need
  ;;  to translate the names of these folders. For Norwegian
  ;;  "[Gmail]/Corbeille" would be "[Gmail]/Papirkurv".
  (setq mu4e-drafts-folder "/[Gmail]/Brouillons")
  (setq mu4e-sent-folder   "/[Gmail]/Messages envoyés")
  (setq mu4e-refile-folder "/[Gmail]/Tous les messages")
  (setq mu4e-trash-folder  "/[Gmail]/Corbeille")

  (setq mu4e-maildir-shortcuts
      '(("/Inbox"             . ?i)
        ("/[Gmail]/Messages envoyés" . ?s)
        ("/[Gmail]/Corbeille"     . ?t)
        ("/[Gmail]/Brouillons"    . ?d)
        ("/[Gmail]/Tous les messages"  . ?a)))

  (setq mu4e-bookmarks
	'((:name "Unread messages" :query "flag:unread AND NOT flag:trashed" :key ?i)
	  (:name "Today's messages" :query "date:today..now" :key ?t)
	  (:name "The Boss" :query "from:stallman" :key ?s)
	  (:name "Last 7 days" :query "date:7d..now" :hide-unread t :key ?w)
	  (:name "Messages with images" :query "mime:image/*" :key ?p)))

  ;; Run mu4e in the background to sync mail periodically
  ;; (mu4e t)
  )
;; End -  Streamline Your E-mail Management with mu4e - Emacs Mail ---

;; End - Emacs Mail --------------------------------------------------
