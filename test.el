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
    (load-file "~/emacs_libs/modes/yasnippet/yasnippet-debug.el")
    (yas-minor-mode 0)
    (yas-minor-mode t))
  )

edebug-on-quit
edebug-on-error
(yas-expand-snippet "${1:test1}") 
;; 下面这个C-u 然后全部 C-i 无报错跑通, 但是有警告 Killing zombie snippet!
(yas-expand-snippet "${1:test1} 2:${2:test1}")
(yas-expand-snippet "${1}")
(clear-message-buffer)

;; 最后不是他的锅
  yas--find-next-field(1 nil [cl-struct-yas--field 3 #<marker at 2065 in test.el> #<marker at 2071 in test.el> nil nil nil t nil])
  yas-next-field()
  yas-next-field-or-maybe-expand()
  call-interactively(yas-next-field-or-maybe-expand nil nil)
  command-execute(yas-next-field-or-maybe-expand)

(memq 3 (list 1 2 3 4 5))

http://www.jianshu.com/p/f509c9a9cac0
https://www.gnu.org/software/emacs/manual/html_node/elisp/Error-Debugging.html#Error-Debugging
https://www.gnu.org/software/emacs/manual/html_node/elisp/Debugger-Commands.html#Debugger-Commands
https://www.gnu.org/software/emacs/manual/html_node/elisp/Edebug-Execution-Modes.html#Edebug-Execution-Modes
https://www.gnu.org/software/emacs/manual/html_node/elisp/Edebug.html
M-x toggle-debug-on-error RET
debug-on-error
(setq debug-on-signal t)
error yas-next-field
error yas-active-snippets


(yas-expand-snippet "${1:test1} ---- $1")
(yas-expand-snippet "${1:test1} --$0-- $1")

;; i spc

;; 全局变量 字典 window-layouts 
;; test.el message yas.el 3个窗口


最后是它的锅
(swiper-other-window "defun yas-active-snippets" "./yasnippet.el")
(swiper-other-window "defun yas-next-field" "./yasnippet.el")
(swiper-other-window "defun yas--find-next-field" "./yasnippet.el")
(swiper-other-window "d.*n yas--check-commit-snippet" "./yasnippet.el")
(swiper-other-window "d.*n yas-expand-snippet" "./yasnippet.el")

准备埋prin1

入参, 结果, 关键地方

(defun aborn/debug-demo ()
  "debug demo function"
  (interactive)
  (let ((a "a")
        (b "value b")
        (c 1))
    (debug)
    (message "middle")
    (setq c (+ 1 c))
    (xyz "a")
    (message "ggg")
    ))

(aborn/debug-demo)

取最大和最小的范围
(yas-active-snippets 'all)
(setq control-overlay (yas--snippet-control-overlay snippet))
(overlay-start control-overlay)

(reduce
 (lambda (n1 n2) (list (min (car n1) (car n2))
                       (max (nth 1 n1) (nth 1 n2))))
 '(
   (2 5)
   (3 4)
   (1 2)
   (4 6)
   )
 :initial-value '(2 3)
 )

(fuck)

(defun fuck ()
  (reduce
   (lambda (n1 n2) (cons (min (car n1) (car n2))
                         (max (cdr n1) (cdr n2))))
   (mapcar
    (lambda (n)
      (cons
       (overlay-start (yas--snippet-control-overlay n))
       (overlay-end (yas--snippet-control-overlay n))
       ))
    (yas-active-snippets 'all))
   :initial-value (cons (point) (+ 1 (point)))
   ))
