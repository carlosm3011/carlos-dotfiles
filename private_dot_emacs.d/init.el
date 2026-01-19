(add-to-list 'load-path "~/.emacs.d/sensible-defaults")
(require 'sensible-defaults)

(sensible-defaults/increase-gc-threshold)
(sensible-defaults/show-matching-parens)
(sensible-defaults/bind-home-and-end-keys)

(setq default-frame-alist
      '((width . 100) ; Default width 100 chars
        (height . 50) ; Default height 50 lines
        (left . 10)   ; Default 10px from left
        (top . 20)    ; Default 20px from top
        (mouse-frame . t))) ; Show mouse-frame by default

(setq initial-frame-alist
      '((width . 120) ; Initial frame is wider
        (height . 60)
        (left . 50)   ; Position it differently
        (top . 50)))

(global-display-line-numbers-mode)

(add-to-list 'default-frame-alist '(font . "Monaco-14"))
(setq inhibit-startup-screen t)

(global-visual-line-mode t)
(setq-default fill-column 110)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tsdh-dark))
 '(package-selected-packages '(markdown-mode zig-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

