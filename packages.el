;;; packages.el --- fennel layer packages file for Spacemacs.
;;
;; Copyright (c) 2019 Wilson Mitchell and contributors
;;
;; Author: Wilson Mitchell <github@wilsonmitchell.me>
;; URL: https://github.com/mitchellw/fennel-layer
;; Version: 0.1.0
;; Keywords: languages, tools
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst fennel-packages
  '(fennel-mode

    ;; GNU Global with ivy completion; deprecated in favor or global-tags.el
    counsel-gtags

    ;; Show function arglist or variable docstring in echo area
    ;; eldoc

    evil-cleverparens
    ggtags
    helm-gtags
    )
  "The list of Lisp packages required by the fennel layer.")

(defun fennel/post-init-counsel-gtags ()
  (spacemacs/counsel-gtags-define-keys-for-mode 'fennel-mode))

;; (defun fennel/post-init-eldoc ()
;;   (add-hook #'fennel-mode-hook #'eldoc-mode)
;;   (add-hook #'fennel-repl-mode-hook #'eldoc-mode)
;;   (add-hook #'fennel-interaction-mode-hook #'eldoc-mode))

(defun fennel/pre-init-evil-cleverparens ()
  (spacemacs|use-package-add-hook evil-cleverparens
    :pre-init
    (add-to-list 'evil-lisp-safe-structural-editing-modes 'fennel-mode)))

(defun fennel/post-init-ggtags ()
  (add-hook 'fennel-mode-local-vars-hook #'spacemacs/ggtags-mode-enable))

(defun fennel/post-init-counsel-gtags ()
  (spacemacs/counsel-gtags-define-keys-for-mode 'fennel-mode))

(defun fennel/post-init-helm-gtags ()
  (spacemacs/helm-gtags-define-keys-for-mode 'fennel-mode))

;; work around slime bug: https://gitlab.com/technomancy/fennel-mode/issues/3
(defun fennel-mode-disable-slime ()
  (slime-mode -1))

(defun fennel/init-fennel-mode ()
  (use-package fennel-mode
    :defer t
    :init
    (progn
      (when (configuration-layer/package-usedp 'slime)
        (add-hook 'fennel-mode-hook 'fennel-mode-disable-slime))
      (spacemacs/register-repl 'fennel-mode 'fennel-repl "fennel"))
    :config
    (progn
      ;; key bindings
      (dolist (prefix '(("me" . "eval")
                        ("mg" . "goto")
                        ("mh" . "help")))
        (spacemacs/declare-prefix-for-mode
          'fennel-mode (car prefix) (cdr prefix)))
      (spacemacs/set-leader-keys-for-major-mode 'fennel-mode
        "'" 'fennel-repl
        "r" 'fennel-reload

        ;; eval
        ;"ea" 'lisp-show-arglist
        ;"eb" 'eval-buffer
        "ee" 'lisp-eval-defun
        "eL" 'fennel-view-compilation
        "en" 'lisp-eval-form-and-next
        "ep" 'lisp-eval-paragraph
        "er" 'lisp-eval-region

        ;; goto - gg and gG are taken care of by spacemacs

        ;; help
        ;"hf" 'lisp-show-function-documentation
        ;"hv" 'lisp-show-variable-documentation
        "hd" 'lisp-describe-sym))))
