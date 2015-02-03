(add-to-list 'exec-path "~/.cabal/bin")
(menu-bar-mode 0)

;; package installation
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))

(package-initialize)

;; projectile
;; https://github.com/bbatsov/projectile
(require 'projectile)
(projectile-global-mode)
(setq projectile-indexing-method 'native)
(setq projectile-enable-caching t)

;; flx
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)

;; disable ido faces to see flx highlights.
(setq ido-use-faces nil)

;; use space for indentation, 2 spaces wide
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; activate smerge when opening conflict files
(defun sm-try-smerge ()
     (save-excursion
       (goto-char (point-min))
       (when (re-search-forward "^<<<<<<< " nil t)
   	   (smerge-mode 1))))

(add-hook 'find-file-hook 'sm-try-smerge t)



;; haskell coding
(require 'auto-complete)
(require 'haskell-mode)
(require 'haskell-cabal)

(autoload 'ghc-init "ghc" nil t)

(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

(eval-after-load "haskell-mode"
  '(progn
     (setq haskell-stylish-on-save t)
     (setq haskell-process-args-cabal-repl '("--ghc-option=-ferror-spans"
					     "--with-ghc=ghci-ng"))     
     
     (define-key haskell-mode-map (kbd "C-,") 'haskell-move-nested-left)
     (define-key haskell-mode-map (kbd "C-.") 'haskell-move-nested-right)
     (define-key haskell-mode-map (kbd "C-c v c") 'haskell-cabal-visit-file)
     (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile)
     (define-key haskell-mode-map (kbd "C-x C-d") nil)
     (setq haskell-font-lock-symbols t)

     ;; Do this to get a variable in scope
     (auto-complete-mode)

     ;; from http://pastebin.com/tJyyEBAS
     (ac-define-source ghc-mod
       '((depends ghc)
         (candidates . (ghc-select-completion-symbol))
         (symbol . "s")
         (cache)))
     
     (defun my-ac-haskell-mode ()
       (setq ac-sources '(ac-source-words-in-same-mode-buffers
                          ac-source-dictionary
                          ac-source-ghc-mod)))
     (add-hook 'haskell-mode-hook 'my-ac-haskell-mode)
     
  
     (defun my-haskell-ac-init ()
       (when (member (file-name-extension buffer-file-name) '("hs" "lhs"))
         (auto-complete-mode t)
         (setq ac-sources '(ac-source-words-in-same-mode-buffers
                            ac-source-dictionary
                            ac-source-ghc-mod))))
     (add-hook 'find-file-hook 'my-haskell-ac-init)))

(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(eval-after-load "which-func"
  '(add-to-list 'which-func-modes 'haskell-mode))

(eval-after-load "haskell-cabal"
    '(define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-compile))

