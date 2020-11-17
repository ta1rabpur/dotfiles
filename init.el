;;; package --- Summary
;;; Commentary:
;;; Code:
										;define the function to add load-path    those are quoted from Otake Tomoya, Emacs, web+db press plus
(defun add-to-load-path (&rest paths)
  (let (path)
	(dolist (path paths paths)
	  (let ((default-directory
			  (expand-file-name (concat user-emacs-directory path))))
		(add-to-list 'load-path default-directory)
		(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
			(normal-top-level-add-subdirs-to-load-path))))))
;;add dirs and its subdirs as var to load-path
(add-to-load-path "elisp" "conf" "public_repos")

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
;(add-to-list 'after-init-hook ' clipmon-mode-start)
(package-initialize)

(eval-when-compile
  (add-to-list 'load-path default-directory)
  (require 'use-package))
;(require 'diminish)
(require 'bind-key)
;;language
;(load-library "anthy")
;(setq default-input-method "japanese-anthy")
										;(anthy-kana-map-mode)
(require 'mozc)
(set-locale-environment nil)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;(set-fontset-font (frame-parameter nil 'font )
;				  'Japanese jisx0208
;				  font-spec :family)

(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(define-key global-map [zenkaku-hankaku] 'toggle-input-method)

;;line number
(global-linum-mode t)
(setq linum-format "%d ")

;;column number
(column-number-mode t)
(line-number-mode 0)

;;scroll
(setq scroll-step 1)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5)))
(setq mouse-wheel-progressive-speed nil)

;;color theme()
;(load-theme 'monokai t)
;;set color
;(set-face-background 'region "maroon3")

;;doom-theme
(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :custom-face
  (doom-modeline-bar ((t (:background "#6272a4"))))
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-neotree-config)
  (doom-themes-org-config))

;;doom-modeline
(use-package doom-modeline
  :custom
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon nil)
  (doom-modeline-minor-modes nil)
  :hook
  (after-init . doom-modeline-mode)
  :config
  (line-number-mode 0)
  (column-number-mode 0)
  (doom-modeline-def-modeline 'main
  '(bar workspace-number window-number evil-state god-state ryo-modal xah-fly-keys matches buffer-info remote-host buffer-position parrot selection-info)
  '(misc-info persp-name lsp github debug minor-modes input-method major-mode process vcs checker)))

;;menubar
(menu-bar-mode 0)

;;toolbar
(tool-bar-mode 0)

;;scrollbar
(scroll-bar-mode 0)

;;show full-path on title
(setq frame-title-format "%f")

;;current directory
(let ((ls (member 'mode-line-buffer-identification
				  mode-line-format)))
  (setcdr ls
		  (cons '(:eval (concat "("
								(abbreviate-file-name default-directory)
								")"))
				(cdr ls))))


;;show current time
(display-time)

;;auto-revert
(global-auto-revert-mode t)

;;;key bind
;;to revert-buffer
(defun revert-buffer-no-confirm (&optional force-reverting)
  "Interactive call to revert-buffer.  Ignoring the suto-save file and not requesting for confirmation.  When the current buffer is modified, the command refuses to revert it, unless you specify the optional argument: force-reverting to true.  "
  (interactive "P")
  ;;(message "force-reverting value is %s" force-reverting)
  (if ( or force-reverting (not (buffer-modified-p)))
	  (revert-buffer :ignore-auto :noconfirm)
	(error "The buffer has been modified")))
(global-set-key (kbd "<f5>") 'revert-buffer-no-confirm)

;;to change the window
(global-set-key (kbd "C-t") 'other-window)

;;hilight current window
(require 'hiwin)
(hiwin-activate)
(set-face-background 'hiwin-face "gray30")

;;tab size
(setq-default tab-width 4)

;;silent
(defun next-line(arg)
  (interactive "p")
 (condition-case nil
	  (line-move arg)
	(end-of-buffer)))
(setq ring-bell-function 'ignore)
  
;;alpha
(if window-system
    (progn
      (set-frame-parameter nil 'alpha 95)))

;;auto bracket complete
(require 'smartparens)
(smartparens-global-mode t)
(setq-default sp-highlight-pair-overlay nil)

;;paren hilight
;(show-paren-mode 1)

;;rainbow-delimiters
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

;;auto complete
(require 'auto-complete-config)
(ac-config-default)
(ac-set-trigger-key "TAB")
(global-auto-complete-mode t)


;;undo-tree
(require 'undo-tree)
(global-undo-tree-mode t)
(global-set-key (kbd "M-/") 'undo-tree-redo)

;;docker.el
;(use-package docker
;  :ensure t
;  :bind ("C-c d" . docker))


;;CUA OS copypasta even in ncurses mode
;(case system-type
;	  ('gnu/linux (progn
;					(setq x-select-enable-clipboard t)
;					(defun xsel-cut-function (text &optional push)
;					  (with-temp-buffer
;						(insert text)
;						(call-process-region (point-min) (point-max) "xsel" nil 0 nil "--clipboard" "--input" )))
;					(defun xsel-paste-function()
;
;					  (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
;						(unless (string = (car kill-ring) xsel-output)
;						  xsel-output )))
;					(setq interprogram-cut-function 'xsel-cut-function)
;					(setq interprogram-paste-function 'xsel-paste-function))))

;; no value
(defun isWSL()
  "run emacs on windows subsystem linux ?"
  (if (string = "" (shell-command-to-string "unname -r |grep Microsoft"))
	  nil
	t))

(defun clipboard-copy()
  (interactive)
  (when (region-active-p)
	(if (isWSL)
		(shell-command-on-region (region-beginning) (region-end) "clip.exe" nil nil)
	    (shell-command-on-region (region-beginning) (region-end) "xsel --clipboard --input" nil nil)
		)
	)
 )

;(cond (window-system
;	   (setq x-select-enable-clipboard nil)
;	   ))
;(setq select-active-regions nil)
;(setq mouse-drag-copy-region t)
;(setq x-select-enable-primary t)
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
;(setq mouse-drag-copy-region t)
;;    ))
;;added for clip
(global-set-key (kbd "<mouse-2>") 'clipboard-yank)
(delete-selection-mode)


;;org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-log-done t)
(use-package org
 :ensure t
 :mode (("\\.txt$" . org-mode))
 :bind (("C-c c" . org-capture)
		("C-c l" . org-store-link)
		("C-c a" . org-agenda)
		("C-c b" . org-iswitchb)
		)
 :init
 (setq my-org-directory "~/Documents/org/")
 (setq my-org-agenda-directory "~/Documents/org/agenda/")
 (setq org-agenda-files (list my-org-directory my-org-agenda-directory))
 :config
 (setq org-hide-leadings-stars t)
 (setq org-return-follows-link t)
 (setq org-directory my-org-directory)
 (setq org-default-notes-file "captured.org")
; (setq org-default-notes-file my-org-default-notes-file)
 (setq org-capture-templates
      '(("a"
	 "MEMO"
	 entry
	 (file+headline nil "MEMO"
	 "* %U%?%n%n%a%n%F%n"
	 :empty-lines 1)
	 )
		))
)

(require 'ox-latex)
(require 'ox-bibtex)

(setq org-latex-pdf-process
	  '("platex %f"
		"platex %f"
		"platex %b"
		"platex %f"
		"platex %f"
		"dvipdfmx %b.dvi"))

(setq org-latex-with-hyperref nil)

;(require 'helm-c-yasnippet)
;(setq helm-yas-space-match-any-greedy t)
;(global-set-key (kbd "C-c y") 'helm-yas-complete)
;(push '("emacs.+/snippets/" . Snippet-mode) auto-mode-alist)
;(yas-global-mode 1)


;;yasnippet
(add-to-list 'load-path
			  "~/.emacs.d/plugins/yasnippet")
;(require 'yasnippet)
;(setq yas-snippet-dirs
;	  '("~/.emacs.d/mysnippets"
;		"~/.emacs.d/yasnippets"
;		))
;(define-key yas-minor-mode-map (kbd "C-x i i")'yas-insert-snippet)
;(define-key yas-minor-mode-map (kbd "C-x i n")'yas-new-snippet)
;(define-key yas-minor-mode-map (kbd "C-x i v")'yas-visit-snippet-file)
(use-package yasnippet
  :bind
  (:map yas-minor-mode-map
		("C-x i n" . yas-new-snippet)
		("C-x i v" . yas-visit-snippet-file)
		("C-M-i"   . yas-insert-snippet))
  (:map yas-keymap
		("<tab>" . nil))
  :config
(yas-global-mode 1))


(use-package lsp-mode
  :commands lsp
  :custom (;(lsp-enable-snippet t)
;		   (lsp-enable-indetation nil)
;		   (lsp-prefer-flymake nil)
;		   (lsp-document-sync-method 'incremental)
		   (lsp-inhibit-message t)
		  (lsp-message-project-root-warning t)
		  (create-lockfiles nil))
  :init (unbind-key "C-l")
  :bind (("C-l C-l" . lsp)
		 ("C-l h" . lsp-describe-session)
		 ("C-l t" . lsp-goto-type-definition)
		 ("C-l r" . lsp-rename)
		 ("C-l <f5>". lsp-restart-workspace)
		 ("C-l l" . lsp-lens-mode))
  :hook (prog-major-mode . lsp-prog-major-mode-enable))

(use-package lsp-ui
  :commands lsp-ui-mode
  :after lsp-mode
  :custom (lsp-ui-doc-enable t)
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-position 'top)
  (lsp-ui-doc-max-width 60)
  (lsp-ui-doc-max-height 20)
  (lsp-ui-doc-use-childframe t)
  (lsp-ui-doc-use-webkit nil)

  (lsp-ui-flycheck-enable t)

  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-show-symbol t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions t)

  (lsp-ui-imenu-enable nil)
  (lsp-ui-imenu-kind-position 'top)

  (lsp-ui-peek-enable t)
  (lsp-ui-peek-always-show t)
  (lsp-ui-peek-peek-height 30)
  (lsp-ui-peek-list-width 30)
  (lsp-ui-peek-fontify 'always)
  :hook (lsp-mode . lsp-ui-mode)
  :bind (("C-l s" . lsp-ui-sideline-mode)
	   ("C-l C-d" . lsp-ui-peek-find-definitions)
	   ("C-l C-r" . lsp-ui-peek-find-references)))


(use-package company
  :custom
  (company-transformers '(company-sort-by-backend-importance))
  (company-idle-delay 0)
  (company-echo-delay 0)
  (company-minimum-prefix-length 2)
  (company-selection-wrap-around t)
  (completion-ignore t)
  :bind
  (("C-M-c" . company-complete))
  (:map company-active-map
		("C-n" . company-select-next)
		("C-p" . company-select-previous)
		("C-s" . company-filter-candidates)
		("C-i" . company-complete-selection)
		([tab] . company-complete-selection))
  (:map company-search-map
		("C-n" . company-select-next)
		("C-p" . company-select-previous))
  :init
  (global-company-mode t)
  :config
  (defun my-sort-uppercase (candidates)
	(let (case-fold-search
		  (re "\\'[[:upper]]*\\'"))
	  (sort candidates
			(lambda (s1 s2)
			  (and (string-match-p re s2)
				   (not (string-match-p re s1)))))))

  (push 'my-sort-uppercase company-transformers)

  (defvar company-mode/enable-yas t)
  (defun company-mode/backend-with-yas (backend)
	(if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
		backend
	  (append (if (consp backend) backend (list backend))
			  '(:with company-yasnippet))))
  (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends)))

(use-package company-lsp
  :commands company-lsp
  :custom
  (company-lsp-cache-candidates nil)
  (company-lsp-async t)
  (company-lsp-enable-recompletion t)
  (company-lsp-enable-snippet t)
  :after
  (:all lsp-mode lsp-ui company yasnippet)
  ; :defines company-backends
  ; :functions company-backend-with-yas
  :init
  (push 'company-lsp company-backends))

;;helm
(require 'helm)
(require 'helm-config)
(helm-mode 1)


;;ccls
(use-package ccls
  :custom
  (ccls-executable "/mnt/c/Users/taichi/ccls/Release/ccls")
 (ccls-sem-highlight-method 'font-lock)
 (ccls-use-default-rainbow-sem-highlight)
   :hook
  ((c-mode c++-mode objc-mode cuda-mode) . (lambda () (require 'ccls) (lsp))))


;;autoinsert
(require 'autoinsert)
(setq suto-insert-directry "~/.emacs.d/insert/")

(require 'cl)
(defvar my:autoinsert-template-replace-alist
  '(("%file%" .
	 (lambda()
	 (file-name-nondirectory (buffer-file-name))))
("%author%" . (lambda()(identity user-full-name)))
("%email%"  . (lambda()(identity user-mail-address)))
("%filewithoutext%" . (lambda()(file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
))

(defun my:template()
  (time-stamp)
  (mapc #'(lambda(c)
			(progn
			  (goto-char (point-min))
			  (replace-string (car c) (funcall (cdr c)) nil)))
		my:autoinsert-templabe-replace-alist)
  (go-to-char (point-max))
  (message "done."))

(setq auto-insert-alist
	  (append '(
				(ruby-mode . "ruby-templare.rb")
				("\\.html" . "html-insert.html")
				("\\.gp"   . ["gpfile-template.gp" my:template] )
				("\\.sh"   . "sh-template.sh")
				("\\.rb"   . "ruby-template.rb")
				) auto-insert-alist))


;;yatex
(require 'yatex)
(add-to-list 'auto-mode-alist '("\\.tex\\'" . yatex-mode))
(setq tex-command "platex")
(setq bibtex-command "pbibtex")
;;reftex-mode
(add-hook 'yatex-mode-hook
		  #'(lambda ()
			  (reftex-mode 1)
			  (define-key reftex-mode-map
				(concat YaTeX-prefix ">") 'YaTeX-comment-region)
 			  (define-key reftex-mode-map
				(concat YaTeX-prefix "<") 'YaTeX-uncomment-region)))
(setq dvi2-command "xdvi")

;;gnuplot
(require 'gnuplot)
(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t)
(setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) auto-mode-alist))
(setenv "DISPLAY" ":0.0")


;;flycheck
(use-package flycheck
			 :config
			 (global-flycheck-mode t)
			 )

;;elscreen
;(require 'elscreen)
;(setq elscreen-prefix-key (kbd "C-z"))
(when (require 'elscreen nil t)
  (elscreen-start))

;;neotree
(use-package neotree
  :custom
  (neo-theme 'nerd2)
  :bind
  ("<f8>" . neotree-toggle))

										;which-key
;(use-package which-key
;  :diminish which-key-mode
;  :hook (after-init . which-key-mode))

;;hide-mode-line
(use-package hide-mode-line
  :hook
  ((neotree-mode) . hide-mode-line-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ccls-executable "/mnt/c/Users/taichi/ccls/Release/ccls")
 '(ccls-sem-highlight-method (quote font-lock))
 '(ccls-use-default-rainbow-sem-highlight nil t)
 '(company-echo-delay 0 t)
 '(company-idle-delay 0)
 '(company-lsp-async t)
 '(company-lsp-cache-candidates nil)
 '(company-lsp-enable-recompletion t)
 '(company-lsp-enable-snippet t)
 '(company-minimum-prefix-length 2)
 '(company-selection-wrap-around t)
 '(company-transformers (quote (company-sort-by-backend-importance)))
 '(completion-ignore t t)
 '(create-lockfiles nil)
 '(lsp-inhibit-message t t)
 '(lsp-message-project-root-warning t t)
 '(lsp-ui-doc-enable t t)
 '(lsp-ui-doc-header t t)
 '(lsp-ui-doc-include-signature t t)
 '(lsp-ui-doc-max-height 20 t)
 '(lsp-ui-doc-max-width 60 t)
 '(lsp-ui-doc-position (quote top) t)
 '(lsp-ui-doc-use-childframe t t)
 '(lsp-ui-doc-use-webkit nil t)
 '(lsp-ui-flycheck-enable t t)
 '(lsp-ui-imenu-enable nil t)
 '(lsp-ui-imenu-kind-position (quote top) t)
 '(lsp-ui-peek-always-show t t)
 '(lsp-ui-peek-enable t t)
 '(lsp-ui-peek-fontify (quote always) t)
 '(lsp-ui-peek-list-width 30 t)
 '(lsp-ui-peek-peek-height 30 t)
 '(lsp-ui-sideline-enable t t)
 '(lsp-ui-sideline-ignore-duplicate t t)
 '(lsp-ui-sideline-show-code-actions t t)
 '(lsp-ui-sideline-show-diagnostics t t)
 '(lsp-ui-sideline-show-hover t t)
 '(lsp-ui-sideline-show-symbol t t)
 '(neo-theme (quote nerd2) t)
 '(package-selected-packages
   (quote
	(docker yasnippet-snippets org-plus-contrib ccls company-lsp lsp-ui lsp-mode helm-c-yasnippet flycheck undo-tree auto-complete neotree elscreen hiwin smartparens monokai-theme package-utils clipmon))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)

(provide 'init)
;;; init.el ends here
