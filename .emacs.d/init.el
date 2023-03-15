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
                         ("org" . "https://orgmode.org/elpa/")
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

;; Display key pressed
;; (use-package command-log-mode)


;; flexible, simple tools for minibuffer completion in Emacs
;; Ivy, a generic completion mechanism for Emacs.
;; Counsel, a collection of Ivy-enhanced versions of common Emacs commands.
;; Swiper, an Ivy-enhanced alternative to Isearch.

;; No need to install manually because installed with counsel
;(use-package counsel
;:ensure t
;)

;(use-package swiper
;:ensure t
;)

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


;; Org Mode Configuration ------------------------------------------------------
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


;; Checking and Correcting Spelling --------------------------------------------

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


(setq org-startup-align-all-tables t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "cf922a7a5c514fad79c483048257c5d8f242b21987af0db813d3f0b138dfaf53" "76ed126dd3c3b653601ec8447f28d8e71a59be07d010cd96c55794c3008df4d7" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "da186cce19b5aed3f6a2316845583dbee76aea9255ea0da857d1c058ff003546" "835868dcd17131ba8b9619d14c67c127aa18b90a82438c8613586331129dda63" default))
 '(markdown-command "/usr/bin/pandoc" t)
 '(package-selected-packages
<<<<<<< HEAD
   '(evil-collection langtool visual-fill-column flycheck-yamllint markdown-mode powershell general nasm-mode masm-mode helpful ivy-rich which-key rainbow-delimiters doom-themes doom-modeline counsel use-package)))
=======
   '(php-mode langtool visual-fill-column flycheck-yamllint markdown-mode powershell general nasm-mode masm-mode helpful ivy-rich which-key rainbow-delimiters doom-themes doom-modeline counsel use-package)))



>>>>>>> 79f1702 (tmux - enable status bar)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

