;;; init.el --- initialize my emacs -*- lexical-binding: t; -*-
;;; Commentary:
;;; Nya-n
;;; Code:

(setq byte-compile-warnings '(not cl-functions obsolete))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))
(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))
  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom
  (
   (user-full-name . "Naca Nyan")
   (user-mail-address . "naca.nyan@gmail.com")
   (user-login-name . "naca-nyan")
   (create-lockfiles . nil)
   (debug-on-error . t)
   (init-file-debug . t)
   (frame-resize-pixelwise . t)
   ;; (enable-recursive-minibuffers . t)
   (history-length . 1000)
   (history-delete-duplicates . t)
   (scroll-preserve-screen-position . t)
   (scroll-conservatively . 100)
   (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
   (ring-bell-function . 'ignore)
   (text-quoting-style . 'straight)
   (truncate-lines . t)
   ;; (use-dialog-box . nil)
   ;; (use-file-dialog . nil)
   (menu-bar-mode . nil)
   (tool-bar-mode . nil)
   (scroll-bar-mode . nil)
   (inhibit-startup-screen . t)
   (custom-enabled-themes . '(misterioso))
   (indent-tabs-mode . nil)
   (c-basic-offset . 2))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  (keyboard-translate ?\C-h ?\C-?))
(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "minor-mode" "tools" "languages" "convenience" "emacs>=24.3"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)
(leaf company
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode)
(leaf company-c-headers
  :doc "Company mode backend for C/C++ header files"
  :req "emacs-24.1" "company-0.8"
  :tag "company" "development" "emacs>=24.1"
  :added "2020-03-25"
  :emacs>= 24.1
  :ensure t
  :after company
  :defvar company-backends
  :config
  (add-to-list 'company-backends 'company-c-headers))
(leaf hs-minor-mode
  :hook
  (prog-mode-hook . (lambda () (hs-minor-mode 1)))
  :bind (("<C-tab>" . hs-toggle-hiding)))
(leaf backup-settings
  :custom ((make-backup-files . nil)))

(leaf cc-customs
  :preface (defun my-c-mode-hook ()
             (c-set-offset 'innamespace 0)
             (c-set-offset 'substatement-open 0))
  :hook
  (c-mode-common-hook . my-c-mode-hook)
  (c++-mode-common-hook . my-c-mode-hook)
  :custom ((default-tab-width . 2)
           (indent-tabs-mode . nil)))

(set-face-font 'default "Consolas-11")
(set-coding-system-priority 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-unix)

;; Local Variables:
;; byte-compile-warnings: (not cl-functions obsolete)
;; End:

(provide 'init)
;;; init.el ends here
