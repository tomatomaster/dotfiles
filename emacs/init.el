;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;; Package管理
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;;load-path
(defmacro append-to-list (to lst)
  `(setq ,to (append, lst, to)))

(append-to-list load-path
			 '("~/.emacs.d/elpa"
			   "~/.emacs.d/elpa/auto-complete"
			   "~/dev/go/bin"))

;;exec-path
(add-to-list 'exec-path (expand-file-name "~/homebrew/bin"))

;;日本語の設定
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)

;; バックアップファイルの作成を行わない
(setq make-backup-files nil)

;; 終了時にオートセーブファイルを削除する
(setq delete-auto-save-files t)

;;Keyboard-translate
(keyboard-translate ?\C-h ?\C-?)

;; GNU global
(when (locate-library "gtags") (require 'gtags))
(global-set-key "\M-t" 'gtags-find-tag)     ;関数の定義元へ
(global-set-key "\M-r" 'gtags-find-rtag)    ;関数の参照先へ
(global-set-key "\M-s" 'gtags-find-symbol)  ;変数の定義元/参照先へ
;;(global-set-key "\M-f" 'gtags-find-file)    ;ファイルにジャンプ
(global-set-key "\C-t" 'gtags-pop-stack)   ;前のバッファに戻る
(add-hook 'c-mode-common-hook
          '(lambda ()
             (gtags-mode 1)
             (gtags-make-complete-list)))

;;auto-complete
(require 'auto-complete-config)
(require 'go-autocomplete)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "/Users/ono/emacs.d/elpa/auto-complete/dict")
(global-auto-complete-mode t)
(ac-set-trigger-key "C-.")
(setq ac-use-menu-map t)
(setq ac-use-fuzzy t)

;;一行コピー
(defun copy-whole-line (&optional arg)
  "Copy current line."
  (interactive "p")
  (or arg (setq arg 1))
  (if (and (> arg 0) (eobp) (save-excursion (forward-visible-line 0) (eobp)))
      (signal 'end-of-buffer nil))
  (if (and (< arg 0) (bobp) (save-excursion (end-of-visible-line) (bobp)))
      (signal 'beginning-of-buffer nil))
  (unless (eq last-command 'copy-region-as-kill)
    (kill-new "")
    (setq last-command 'copy-region-as-kill))
  (cond ((zerop arg)
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))))
        ((< arg 0)
         (save-excursion
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line (1+ arg))
                                       (unless (bobp) (backward-char))
                                       (point)))))
        (t
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line arg) (point))))))
  (message (substring (car kill-ring-yank-pointer) 0 -1)))
(global-set-key (kbd "M-k") 'copy-whole-line)

;;リージョンのカラーリング
(setq transient-mark-mode t)

;; C-c c で compile コマンドを呼び出す
(define-key mode-specific-map "c" 'compile)

;; C-c C-z で shell コマンドを呼び出す
(define-key mode-specific-map "t" 'shell-command)

;; Thanks to "http://www.namazu.org/~tsuchiya/elisp/#shell-command-with-completion"
(load-file "~/.emacs.d/shell-command.el")
(shell-command-completion-mode)

;;emacs24
(setq default-input-method "MacOSX")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (go-mode ##)))
 '(tab-width 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
