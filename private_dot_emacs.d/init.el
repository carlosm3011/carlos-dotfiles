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

