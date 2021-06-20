;; Disable the startup page
(setq inhibit-startup-message t)

;; Clean up some of the visual mess
(scroll-bar-mode -1)    ; Disable visible scrollbar
(tool-bar-mode -1)      ; Disable the toolbar
(tooltip-mode -1)       ; Disable tooltips
(menu-bar-mode -1)      ; Disable the menu bar

;; Set the size of the left-side fringe
(set-fringe-mode 10)

;; Change the font
; (set-face-attribute 'default nil :font "Fira Code Retina" :height 14)

;; Set a theme, for now
(load-theme 'wombat t)

;; Take care of the backup files, they can be a mess
(setq backup-directory-alist `(("." . "~/.saves"))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; Let's set up use-package
(require 'package)

(setq package-archives `(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Escape actually escapes
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Line numbers
(column-number-mode) ; Adds column number to the modeline
(global-display-line-numbers-mode t)

;; Disable line-numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		vterm-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Setup Ivy
(use-package swiper
  :ensure t)

(use-package ivy
  :diminish
  :ensure t
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :init
  (counsel-mode 1))

(use-package all-the-icons)

;; Use doom-modeline
(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1))

;; Use doom-themes
(use-package doom-themes
  :init
  (load-theme 'doom-one t))

;; Matching colored delimmiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Prompt for available keys
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; Nicer help
(use-package helpful
  :ensure t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command]  . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key]      . helpful-key))

;; Keybindings via general.el
(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t" '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

; (use-package evil
;  :init
;  (setq evil-want-integration t
;	evil-want-keybinding nil
;	evil-want-C-u-scroll t
;	evil-want-C-i-jump nil)
;  :config
;  (evil-mode 1)
;  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
;  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
;  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
;  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

;  (evil-set-initial-state 'message-buffer-mode 'normal)
;  (evil-set-initial-state 'dashboard-mode 'normal))

;(use-package evil-collection
;  :after evil
;  :config
;  (evil-collection-init))
