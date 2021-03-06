(if (display-graphic-p) (menu-bar-mode 1) (menu-bar-mode -1))
(when (and (fboundp 'tool-bar-mode) tool-bar-mode) (tool-bar-mode -1))
(when (and (fboundp 'scroll-bar-mode) scroll-bar-mode) (scroll-bar-mode -1))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(ac-nrepl
                      ack-and-a-half
                      auto-complete
                      base16-theme
                      cider
                      clojure-mode
                      clojure-test-mode
                      coffee-mode
                      color-theme
                      evil
                      evil-leader
                      evil-nerd-commenter
                      evil-paredit
                      flx-ido
                      flycheck
                      ghc
                      gitconfig-mode
                      go-mode
                      haskell-mode
                      ido-ubiquitous
                      ido-vertical-mode
                      magit
                      markdown-mode
                      midje-mode
                      mo-git-blame
                      paredit
                      paredit-menu
                      powerline
                      projectile
                      rainbow-delimiters
                      ruby-electric
                      rust-mode
                      slime
                      smex
                      surround
                      undo-tree
                      yaml-mode
                      yasnippet))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(add-to-list 'load-path "~/.emacs.d/user/")
(require 'my-functions)

(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(load custom-file t)

(setq custom-safe-themes t)
(load-theme 'base16-chalk)
(my-powerline-theme)

(setq initial-scratch-message "")
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq ring-bell-function 'ignore)
(setq mac-option-modifier 'alt)
(setq mac-command-modifier 'meta)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq lazy-highlight-initial-delay 0)
(setq split-height-threshold 40)
(setq split-width-threshold 200)
(setq split-window-preferred-function 'split-window-sensibly-reverse)
(setq vc-follow-symlinks t)
(setq-default require-final-newline t)
(setq scroll-step 1)                                ; keyboard scroll one line at a time
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ; mouse scroll one line at a time
(setq mouse-wheel-progressive-speed nil)            ; don't accelerate scrolling
(setq scroll-margin 5)

(global-undo-tree-mode t)
(global-font-lock-mode t)
(global-auto-revert-mode t)
(global-hl-line-mode t)
(global-linum-mode t)
(global-visual-line-mode t)
(line-number-mode 1)
(column-number-mode 1)
(add-hook 'dired-mode (lambda ()
                        (message ">> reverting!")
                        (revert-buffer)))

(require 'osx-keys-mode)
(osx-keys-mode t)

(eval-after-load 'paren
  '(setq show-paren-delay 0))
(show-paren-mode t)

(set-face-attribute 'default nil :font "Inconsolata Bold-14")

(global-set-key (kbd "M-h") 'windmove-left)
(global-set-key (kbd "M-j") 'windmove-down)
(global-set-key (kbd "M-k") 'windmove-up)
(global-set-key (kbd "M-l") 'windmove-right)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "M--") 'text-scale-decrease)
(global-set-key (kbd "M-+") 'text-scale-increase)
(global-set-key (kbd "M-0") (lambda () (interactive) (text-scale-set 0)))

(global-surround-mode t)
(global-rainbow-delimiters-mode t)

;; Whitespace settings
(global-whitespace-mode t)
(eval-after-load 'whitespace
  '(progn
     (setq whitespace-line-column 110)
     (setq whitespace-style '(face empty tabs tab-mark))
     (add-hook 'prog-mode-hook
               (lambda () (set (make-local-variable 'whitespace-style)
                               '(face empty tabs tab-mark lines-tail))))
     (add-hook 'go-mode-hook
               (lambda () (set (make-local-variable 'whitespace-style)
                               '(face empty lines-tail))))))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq-default tab-width 2)
(setq-default evil-shift-width 2)

;; No tabs by default. Modes that really need tabs should enable indent-tabs-mode explicitly.
;; Makefile-mode already does that, for example.
;; If indent-tabs-mode is off, untabify before saving.
(setq-default indent-tabs-mode nil)
(add-hook 'write-file-hooks
          (lambda ()
            (if (not indent-tabs-mode)
                (untabify (point-min) (point-max)))
            nil))

;; Minibuffer keybindings
(define-key minibuffer-local-map (kbd "C-w") 'backward-kill-word)
(define-key minibuffer-local-map (kbd "C-a") 'beginning-of-visual-line)
(define-key minibuffer-local-map (kbd "C-e") 'end-of-visual-line)

(ido-mode t)
(ido-ubiquitous-mode t)
(ido-vertical-mode t)
(eval-after-load 'ido
  '(progn
     (setq ido-use-virtual-buffers t)
     (setq ido-use-faces nil)))
(add-hook 'ido-setup-hook
          (lambda ()
            (define-key ido-completion-map (kbd "C-w") 'backward-kill-word)
            (define-key ido-completion-map (kbd "C-a") 'beginning-of-visual-line)
            (define-key ido-completion-map (kbd "C-e") 'end-of-visual-line)))

;; Better ido-mode completion
(flx-ido-mode t)
(eval-after-load 'flx-ido
  '(setq flx-ido-use-faces nil))

(projectile-global-mode)

;; Include path information in duplicate buffer names (e.g. a/foo.txt b/foo.txt)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Create parent directories when saving a new file.
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                  (make-directory dir t))))))

;; Autocompletion
(add-hook 'prog-mode-hook 'auto-complete-mode)
(eval-after-load 'auto-complete
  '(progn
     (define-key ac-complete-mode-map "\C-n" 'ac-next)
     (define-key ac-complete-mode-map "\C-p" 'ac-previous)
     (setq ac-auto-start nil)
     (ac-set-trigger-key "TAB")
     (ac-linum-workaround)))

;; Automatic syntax checking
(add-hook 'prog-mode-hook 'flycheck-mode)
(eval-after-load 'flycheck
  '(progn
    (define-key flycheck-mode-map (kbd "M-n") 'flycheck-next-error)
    (define-key flycheck-mode-map (kbd "M-p") 'flycheck-previous-error)
    (setq flycheck-checkers (delq 'emacs-lisp-checkdoc flycheck-checkers))))

;; Snippets
(eval-after-load 'yasnippet
  '(progn
     (setq yas-snippet-dirs "~/.emacs.d/snippets") ; Only load my snippets
     (yas-reload-all)))
(add-hook 'prog-mode-hook 'yas-minor-mode)

;; Org mode

(eval-after-load 'org
  '(progn
     (setq org-hide-leading-stars t)
     (setq org-odd-levels-only t)
     (add-to-list 'org-agenda-files "~/org/notes.org")
     (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
     (setq org-mobile-inbox-for-pull "~/org/notes.org")
     (setq org-default-notes-file "~/org/refile.org")
     (setq org-mobile-files '("notes.org"))
     ; Disable org-mode keybinding that interferes with custom window switching.
     (define-key org-mode-map (kbd "M-h") nil)))

(defun evil-org-insert-heading-after-current ()
  (interactive)
  (evil-append-line nil)
  (org-insert-heading))

(add-hook 'org-mode-hook (lambda ()
  (define-key evil-normal-state-local-map (kbd "o") 'evil-org-insert-heading-after-current)
  (define-key evil-normal-state-local-map (kbd "C-t") 'org-todo)
  ;; (define-key evil-visual-state-local-map (kbd ">") 'org-shiftmetaright)
  ;; (define-key evil-visual-state-local-map (kbd "<") 'org-shiftmetaleft)
  ))

;; Evil

(evil-mode t)
(global-evil-leader-mode)

;; Note that there is a bug where Evil-leader isn't properly bound to the initial buffers Emacs opens
;; with. We work around this by killing them. See https://github.com/cofi/evil-leader/issues/10.
(kill-buffer "*Messages*")

(evil-leader/set-key
  "b" 'ido-switch-buffer
  "t" 'projectile-find-file
  "ve" 'view-emacs-config
  "vn" 'view-notes-org-mode
  "eb" 'eval-buffer
  "es" 'eval-last-sexp
  "ex" 'eval-expression
  "gs" 'magit-status
  "gl" 'magit-log)

(evil-leader/set-key-for-mode 'clojure-mode
  "eb" 'cider-load-current-buffer
  "es" 'cider-eval-last-sexp-to-repl
  "rs" 'cider-jack-in
  "rn" 'cider-repl-set-ns
  "rc" 'cider-find-and-clear-repl-buffer
  "rk" 'nrepl-close)

(eval-after-load 'evil
  '(progn
     (setq evil-default-cursor t)
     (setq evil-leader/leader ",")
     ;; Unbind these keys in evil so they can instead be used for code navigation.
     (define-key evil-normal-state-map (kbd "M-,") nil)
     (define-key evil-normal-state-map (kbd "M-.") nil)
     ;; Navigate by visual lines instead of absolute lines
     (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
     (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
     (define-key evil-insert-state-map (kbd "RET") 'comment-indent-new-line)
     (define-key evil-insert-state-map (kbd "C-e") 'end-of-visual-line)))

(evilnc-default-hotkeys)

;; Clojure
(add-hook 'clojure-mode-hook 'clojure-test-mode)
(eval-after-load 'clojure-mode
  '(define-key clojure-mode-map "\C-c\M-r" 'cider-switch-to-repl-buffer))

;; Clojure indentation rules
(eval-after-load 'clojure-mode
  '(define-clojure-indent
     (send-off 1)                                                    ; Core
     (GET 2) (POST 2) (PUT 2) (PATCH 2) (DELETE 2) (context 2)       ; Compojure
     (select 1) (insert 1) (update 1) (delete 1) (upsert 1) (join 1) ; Korma
     (clone-for 1)                                                   ; Enlive
     (up 1) (down 1) (alter 1) (table 1)                             ; Lobos
     ))

(add-hook 'clojure-mode-hook '(lambda () (setq indent-line-function 'lisp-indent-line-single-semicolon-fix)))

(setq cider-repl-pop-to-buffer-on-connect nil)
(setq cider-popup-stacktraces nil)

;; Autocompletion in cider
(require 'ac-nrepl)
(add-hook 'cider-mode-hook 'ac-nrepl-setup)
(add-hook 'cider-mode-hook 'auto-complete-mode)
(add-hook 'cider-interaction-mode-hook 'ac-nrepl-setup)
(add-hook 'cider-interaction-mode-hook 'auto-complete-mode)
(add-hook 'cider-interaction-mode-hook 'turn-on-eldoc-mode)
(eval-after-load 'auto-complete '(add-to-list 'ac-modes 'cider-mode))

;; Count hyphens, etc. as word characters in lisps
(add-hook 'clojure-mode-hook (lambda () (modify-syntax-entry ?- "w")))
(add-hook 'emacs-lisp-mode-hook (lambda () (modify-syntax-entry ?- "w")))
(add-hook 'scheme-mode-hook (lambda () (modify-syntax-entry ?- "w")))
(add-hook 'scheme-mode-hook (lambda () (modify-syntax-entry ?> "w")))

;; Treat underscores as word characters everywhere
(add-hook 'after-change-major-mode-hook (lambda () (modify-syntax-entry ?_ "w")))

;; Haskell
(eval-after-load 'haskell-mode
  '(progn
     (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
     (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
     (add-hook 'haskell-mode-hook 'ghc-init)
     (add-hook 'haskell-mode-hook
               (lambda ()
                 (setq haskell-program-name "cabal repl")
                 (setq haskell-indentation-left-offset 4)
                 (setq haskell-indentation-cycle-warn nil)
                 (setq haskell-indent-after-keywords (quote (("where" 2 0) ("of" 4) ("do" 4) ("mdo" 4)
                                                             ("rec" 4) ("in" 4 4) ("{" 4)
                                                             "if" "then" "else" "let")))
                 (setq haskell-indent-look-past-empty-line nil)))))

(eval-after-load 'inf-haskell
  '(define-key inferior-haskell-mode-map (kbd "TAB") 'dabbrev-expand))

;; Go
(add-hook 'before-save-hook 'gofmt-before-save)

;; Filetypes
(add-to-list 'auto-mode-alist '("\\.markdown$" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.md$" . gfm-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rkt$" . scheme-mode))

;; Nimrod
(load "~/.emacs.d/vendor/nimrod-mode.el")

;; Gmail
; Compose with C-x m
; Send with C-c C-c
; http://obfuscatedcode.wordpress.com/2007/04/26/configuring-emacs-for-gmails-smtp/
(require 'smtpmail)
(eval-after-load 'smtpmail
  '(setq user-mail-address "dmacdougall@gmail.com"
         send-mail-function 'smtpmail-send-it
         smtpmail-default-smtp-server "smtp.gmail.com"
         smtpmail-smtp-server "smtp.gmail.com"
         smtpmail-smtp-service 587
         smtpmail-debug-info t))
