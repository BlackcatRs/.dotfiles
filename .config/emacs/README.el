(setq inhibit-startup-message t) ; Hide welcome message
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar
(hl-line-mode)              ; Highlight cursor pointing line
(show-paren-mode)	       ; Highlight opening and closing paren

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		markdown-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; I have configured these three faces in the ~/.emacs.d/faces.el file
;; which is unique on my all PCs

;; ;; Font and font size of Emacs window
;; (set-face-attribute 'default nil :font "Fira Code" :height 120)
;; ;; This will affect the font and font size of source code block in Org mode
;; (set-face-attribute 'fixed-pitch nil :font "Fira Code" :height 120)
;; ;; This will affect font and font size of Heading and text in Org mode
;; (set-face-attribute 'variable-pitch nil :font "Iosevka Aile" :height 120 :weight 'normal)

(if (file-exists-p "~/.emacs.d/faces.el")
    (progn (load-file "~/.emacs.d/faces.el")
           (defun voc/set-font-faces ()
             (message "Setting faces!")
             ;; Font and font size of Emacs window
             (set-face-attribute 'default nil :font "Fira Code" :height voc/default-font-size)

             ;; This will affect the font and font size of source code block in Org mode
             (set-face-attribute 'fixed-pitch nil :font "Fira Code" :height voc/default-fixed-font-size)

             ;; This will affect font and font size of Heading and text in Org mode
             (set-face-attribute 'variable-pitch nil :font "Iosevka Aile" :height voc/default-variable-font-size :weight 'normal))


           (if (daemonp)
               (add-hook 'after-make-frame-functions
                         (lambda (frame)
                           ;; (setq doom-modeline-icon t)
                           (with-selected-frame frame
                             (voc/set-font-faces))))
             (voc/set-font-faces))
           ))

;; Load a package call "package" to handle package fuctions 
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Load Emacs Lisp packages, and activate them.
(package-initialize)

;; Automatically update the list of packages, only if there is no package list already
(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t) ; Ensure that the package is loaded

;; Bottom bar
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 20)))

;; Download doom themes
(use-package doom-themes)
(load-theme 'doom-one t)

;; Parentheses with colors
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; No need to manually install Swiper or Ivy, it will install as dependencies with Counsel
(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package ivy
  :diminish
  :bind (
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

;; Show a description near each function whenrunning counsel-M-x
(use-package ivy-rich
  :init
  (ivy-rich-mode))

;; Display keys that follows the prefix key
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

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

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  ;; Wrap a line when it exceeds the width defined by
  ;; visual-fill-column-width instead of truncating it by placing \n
  ;; at the end of the line.
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  ;; Call the org-mode-visual-fill to set parms of visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill)
  (markdown-mode . efs/org-mode-visual-fill))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-s") (lambda () (interactive) (org-mark-ring-push) (swiper)))

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
  ;; Apply general mode configuration
  :hook (markdown-mode . efs/all-mode-setup)
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
      ;; markdown-mode package does not define markdown-mode-map
      ;; (define-key markdown-mode-map (kbd "\C-c\C-o") 'toc-org-markdown-follow-thing-at-point)
      )
  (warn "toc-org not found"))

(defun efs/all-mode-setup ()
  (visual-line-mode 1))

;; Save all emacs backup files (files ending in ~) in ~/.emacs.d/backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
 )

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces (display options like font, size, etc) for heading levels
  (dolist (face '((org-level-1 . 1.1)
                  (org-level-2 . 1.0)
                  (org-level-3 . 0.95)
                  (org-level-4 . 0.90)
                  (org-level-5 . 1.0)
                  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :font "Fira Code" :weight 'Medium :height (cdr face)))

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
  (org-overview) ;; Show only headings
  ;; This prevent org-capture buffer from opening
  ;; (forward-page) ;; Goto the bottom of the page
  ) 

(use-package org
  :hook ((org-mode . efs/org-mode-setup)
         (org-mode . efs/all-mode-setup))
  :config
  (setq org-ellipsis " ▾" ;; Replace ... at the end of each headings with ▾
        ;; Output the result string instead of showing synctaxe.
        ;; e.g : *Bold* transforme into bold text.  
        org-hide-emphasis-markers t)
  (efs/org-font-setup)

  :bind (("C-c l" . org-store-link)))

;; Custom states 
(setq org-todo-keywords
      '((sequence "TODO(t@/!)" "ONGOING(o@/!)" "NEXT(n@/!)" "|" "DONE(d)")
	;; This states store a timestamp and note
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))

(setq org-tag-alist
      '((:startgrouptag)
        ("Book" . ?r)
        (:grouptags)
        ("Programming")
        ("OS")
        ("Productivity")
        ("Privacy")
        ("Learning")
        ("Psychology")
        ("Security")
        ("Software")
        (:endgrouptag)

        (:startgrouptag)
        ("OS")
        (:grouptags)
        ("Linux")
        ("Windows")
        (:endgrouptag)

        ("@PERSO" . ?h)
        ("@WORK" . ?w)
        ("Appointment" . ?a)
        ("Birthday" . ?b)
        ;; ("Book" . ?r)
        ("Note" . ?n)
        ("Idea" . ?i)))

;; Change headings bullet points using org-bullets package
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(setq org-return-follows-link t ;; Press enter key on the task will open the task file
      org-agenda-tags-column 75   ;; Space between task heading and tags
      org-deadline-warning-days 5 ;; Dispaly tasks with deadline 5 days
      org-use-speed-commands t)   ;; Use single key to execute an action

(setq org-refile-targets
      '(("Archive.org" :maxlevel . 1)
        ("Tasks.org" :maxlevel . 1)))

;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)

(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)

;; Habit tracking package
(require 'org-habit)
;; Load org-habit by adding org-habit to org-modules
(add-to-list 'org-modules 'org-habit)
;; This is the lenth of org habit tracker in agenda view
(setq org-habit-graph-column 60)

;; Org Agenda
(load-file "~/.emacs.d/vars.el")

;; Capture tasks
(setq org-capture-templates
      '(("c" "Unscheduled Task" entry (file+headline voc/todo "Unscheduled Tasks")
         "* HOLD %?\nEntered on <%<%Y-%m-%d %H:%M>>\n" :empty-lines 1)

        ("s" "Scheduled Task" entry (file+headline voc/events "Scheduled Tasks")
         "* TODO %?\nSCHEDULED: %^T\n%U" :empty-lines 1)

        ("d" "Deadline" entry (file+headline voc/events "Recursive Tasks")
         "* TODO %? %(org-set-tags-command) \nDEADLINE: %^T" :empty-lines 1)

        ("l" "Unscheduled Task + Reference" entry (file+headline voc/todo "Unscheduled Tasks")
         "* %^{prompt|ONGOING|TODO|NEXT|WAITING|HOLD} %?\nEntered on <%<%Y-%m-%d %H:%M>>\n%a" :empty-lines 1)

        ("r" "Readings" entry (file+headline voc/todo "Books To Read")
         "* HOLD %^{Title} :Book: \nAuthor: %^{Author} \nYear: %^{Year} \nGenre: %^{Genre} \nReason to read: %? \nEntered on <%<%Y-%m-%d %H:%M>>" :empty-lines 1)

        ("b" "Birthday" entry (file+headline voc/birthdays "Family")
         "* %? :Birthday:\nSCHEDULED: <%<%Y-%m-%d ++1y>>\nBirth of date: <%<%Y-%m-%d>>" :empty-lines 1)

        ("n" "Note" entry (file+headline voc/todo "Notes")
         "* %? %^G\n %U" :empty-lines 1)

        ("j" "Journal" entry (file+olp+datetree voc/journal)
         "* [%<%H:%M>]\n %?" :empty-lines 1)
        ))

;; Dashboard
(set-face-attribute 'org-scheduled-today nil :foreground "#DFDFDF" :inherit 'org-scheduled-previously)
(set-face-attribute 'org-scheduled-previously nil :foreground "#9ca0a4")

(set-face-attribute 'org-agenda-structure nil :foreground "#a9a1e1" :weight 'ultra-bold)
(set-face-attribute 'org-agenda-date nil :foreground "#CE93D8" :weight 'light)

(set-face-attribute 'org-scheduled-previously nil :foreground "#F44336" :weight 'bold)

;; "org-agenda-files" contains a list of files from which Org Agenda
;; retrieves data, I have set this variable in ~/.emacs.d/vars.el
;; file.
;; (setq org-agenda-files
;;       '("~/Org/Tasks.org"
;;         "~/Org/Birthdays.org"))

(defvar voc-org-custom-daily-agenda
  `((agenda "" ((org-agenda-span 1)
                (org-deadline-warning-days 0)
                ;; Show all past scheduled items that are not yet finished or with TODO state
                                        ;(org-scheduled-past-days 0)
                ;; Set the the value of "org-agenda-date" face to "org-agenda-date" face
                (org-agenda-day-face-function (lambda (date) 'org-agenda-date))
                (org-agenda-entry-types '(:scheduled
                                          :deadline))
                ;; (org-agenda-format-date "%A %-e %B %Y")
                (org-agenda-time-grid nil)
                (org-agenda-overriding-header "Today's Agenda")))

    (tags-todo "*" ((org-agenda-skip-function '(org-agenda-skip-if nil '(timestamp)))
                    (org-agenda-block-separator ?_)
                    (org-agenda-skip-function
                     `(org-agenda-skip-entry-if
                       'notregexp ,(format "\\[#%s\\]" (char-to-string org-priority-highest))))
                    (org-agenda-overriding-header "Important Unscheduled Tasks")))

    (todo "ONGOING|NEXT" ((org-agenda-start-on-weekday nil)
                          (org-agenda-block-separator ?_)
                          (org-agenda-overriding-header "Ongoing Tasks")))

    (agenda "" ((org-agenda-start-on-weekday nil)
                (org-agenda-compact-blocks nil)
                (org-agenda-start-day "+1d")
                (org-agenda-span 3)
                (org-deadline-warning-days 0)
                (org-agenda-block-separator ?_)
                ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                (org-agenda-entry-types '(:scheduled
                                          :deadline))
                ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "WAITING" "HOLD" "CANCELLED")))
                (org-agenda-overriding-header "Upcoming Tasks (+3d)")))

    (tags-todo "-Book/TODO|HOLD|WAITING"
               ((org-agenda-overriding-header "Unscheduled Tasks")
                (org-agenda-block-separator ?_)
                (org-agenda-start-on-weekday nil)

                (org-agenda-skip-function '(org-agenda-skip-if nil '(scheduled
                                                                     regexp ,(format "\\[#%s\\]" (char-to-string org-priority-highest))
                                                                     deadline)))))

    (agenda "" ((org-agenda-time-grid nil)
                (org-agenda-start-on-weekday nil)
                (org-agenda-start-day "+4d")
                (org-agenda-span 14)
                (org-agenda-show-all-dates nil)
                (org-deadline-warning-days 0)
                (org-agenda-block-separator ?_)
                (org-agenda-entry-types '(:deadline))
                (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "WAITING" "HOLD" "CANCELLED")))
                (org-agenda-overriding-header "Upcoming Deadlines (+14d)")))

    (tags-todo "Book/HOLD" ((org-agenda-block-separator ?_)
                            (org-agenda-overriding-header "Books To Read")))))

(setq org-agenda-custom-commands
      `(("a" "Daily agenda and top priority tasks"
         ,voc-org-custom-daily-agenda)
        ("P" "Plain text daily agenda and top priorities"
         ,voc-org-custom-daily-agenda
         ((org-agenda-with-colors nil)
          (org-agenda-prefix-format "%t %s")
          (org-agenda-current-time-string ,(car (last org-agenda-time-grid)))
          (org-agenda-fontify-priorities nil)
          (org-agenda-remove-tags t))
         ("agenda.txt"))))


;; Global keyboard shortcuts
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c a") #'org-agenda)

(use-package org-wild-notifier
  :ensure t
  :custom 
  (alert-default-style 'notifications)
  (org-wild-notifier-alert-time '(1 10 30))
  (org-wild-notifier-keyword-whitelist '("TODO"))
  (org-wild-notifier-notification-title "Org Agenda")
  :config
  (org-wild-notifier-mode 1))

(use-package ox-hugo
  :ensure t   ;Auto-install the package from Melpa
  :pin melpa  ;`package-archives' should already have ("melpa" . "https://melpa.org/packages/")
  :after ox)

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

(if (file-exists-p "~/.emacs.d/vars.el")
    (progn 
      (use-package org-roam
        :ensure t
        :custom
        (org-roam-directory voc/RoamNotes)
        (org-roam-completion-everywhere t)
        (org-roam-dailies-capture-templates
         '(("d" "default" entry "* Résumé \n%? \n* A améliorer \n\n* Terminé \n"
            :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
        (org-roam-capture-templates
         '(
           ("d" "Default" plain
            "%?"
            :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
            :unnarrowed t)

           ("l" "Programming language" plain
            "* Characteristics\n\n- Family: %?\n- Inspired by: \n\n* Reference:\n\n"
            :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
            :unnarrowed t)

           ("b" "Book Notes" plain
            "\n* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nYear: %^{Year}\n\n* Summary\n\n%?"
            :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
            :unnarrowed t)

           ("p" "Project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates - Deadlines|Events|Release|Dailies\n\n"
            :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
            :unnarrowed t)
           ))

        :bind (("C-c n l" . org-roam-buffer-toggle)
               ("C-c n f" . org-roam-node-find)
               ("C-c n i" . org-roam-node-insert)
               ("C-c n c" . org-roam-capture)
               :map org-mode-map
               ("C-M-i    .  completion-at-point")
               :map org-roam-dailies-map
               ("Y" . org-roam-dailies-capture-yesterday)
               ("T" . org-roam-dailies-capture-tomorrow))
        :config
        ;; Reload the custom keybindings that defined above
        (org-roam-setup)

        :bind-keymap
        ("C-c n d" . org-roam-dailies-map)

        :config
        (require 'org-roam-dailies) ;; Ensure the keymap is available
        (org-roam-db-autosync-mode)
        (setq org-roam-dailies-directory "Journal/"))))
