#!/bin/sh
# configure emacs for dev user
set -e
set -u 

mkdir $HOME/.emacs.d

cat > $HOME/.emacs.d/install-package.el <<EOF
(require 'package)
(package-initialize)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; Fix HTTP1/1.1 problems
(setq url-http-attempt-keepalives nil)

(package-refresh-contents)

(mapc 'package-install pkg-to-install)
EOF

emacs --batch --eval "(defconst pkg-to-install '(flycheck auto-complete haskell-mode ghc ghci-completion projectile flx-ido))" -l $HOME/.emacs.d/install-package.el

