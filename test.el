(progn
  (defun clear-message-buffer ()
    "debug 的时候有用"
    (set-buffer "*Messages*")
    (read-only-mode 0)
    (erase-buffer)
    (read-only-mode t))
  (defun swiper-other-window (str file-path)
    "在双屏debug中非常有用
str 字符串, 可以是正则表达式
file-path 字符串, 可以是相对路径
window-configuration-change-hook
"
    (interactive)
    (let* (buffer window)
      (setq buffer (or (get-buffer (f-filename file-path))
                       (progn
                         ;; 如果文件没打开, 先打开文件
                         (find-file-other-window file-path)
                         (get-buffer (f-filename file-path)))))
      (setq window (or (get-buffer-window buffer)
                       (progn
                         ;; 如果 buffer window不存在
                         (if (equal (length (window-list)) 1)
                             ;; 如果只有一个 window
                             (split-window-right))
                         (other-window 1)
                         (switch-to-buffer buffer)
                         (get-buffer-window buffer))))
      ;; (get-window-with-predicate (lambda (w) (equal (get-buffer-window buffer) w)))
      (select-window window)
      (swiper str)))
  (defun yas--goto-field-end-or-expand-field ()
    "如果field可扩展, 那么扩展, 否则光标跳到field结尾"
    (interactive)
    ;; (goto-char (yas--field-start field)) ;field 从全局变量中获取
    ;; (goto-char (yas--field-end field)) ;field 从全局变量中获取
    ;; (goto-char (yas--field-end (overlay-get yas--active-field-overlay 'yas--field)))
    ;; (call-interactively 'yas-expand)
    (goto-char (yas--field-end (overlay-get yas--active-field-overlay 'yas--field)))
    (yas-expand (overlay-get yas--active-field-overlay 'yas--field))
    )
  (define-key yas-keymap (kbd "C-u") 'yas--goto-field-end-or-expand-field)
  (progn
    (setq yas-good-grace nil)
    (yas-load-directory "~/a0_emacs_lib/yas-test")
    (load-file "/home/william/a0_emacs_lib/forks/modes/yasnippet/yasnippet-debug.el")
    (yas-minor-mode 0)
    (yas-minor-mode t))
  )


(yas-expand-snippet "${1:test1}")
(clear-message-buffer)


(yas-expand-snippet "${1:test1} ---- $1")
(yas-expand-snippet "${1:test1} --$0-- $1")



;; 全局变量 字典 window-layouts 
;; test.el message yas.el 3个窗口


(swiper-other-window "defun yas--check-commit-snippet" "./yasnippet.el")
(swiper-other-window "d.*n yas--check-commit-snippet" "./yasnippet.el")

准备埋prin1

入参, 结果, 关键地方

