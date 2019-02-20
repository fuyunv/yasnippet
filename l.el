yas--template
key
  content
  name
  condition
  expand-env
  load-file
  save-file
  keybinding
  uuid
  menu-binding-pair
  group      ;; as dictated by the #group: directive or .yas-make-groups
  perm-group ;; as dictated by `yas-define-menu'
table

yas--table (:constructor yas--make-snippet-table (name)))
  "A table to store snippets for a particular mode.

Has the following fields:

`yas--table-name'

  A symbol name normally corresponding to a major mode, but can
  also be a pseudo major-mode to be used in
  `yas-activate-extra-mode', for example.

`yas--table-hash'

  A hash table (KEY . NAMEHASH), known as the \"keyhash\". KEY is
  a string or a vector, where the former is the snippet's trigger
  and the latter means it's a direct keybinding. NAMEHASH is yet
  another hash of (NAME . TEMPLATE) where NAME is the snippet's
  name and TEMPLATE is a `yas--template' object.

`yas--table-direct-keymap'

  A keymap for the snippets in this table that have direct
  keybindings. This is kept in sync with the keyhash, i.e., all
  the elements of the keyhash that are vectors appear here as
  bindings to `yas-maybe-expand-from-keymap'.

`yas--table-uuidhash'

  A hash table mapping snippets uuid's to the same `yas--template'
  objects. A snippet uuid defaults to the snippet's name."


yas--parse-template
Return a snippet-definition, i.e. a list

(KEY TEMPLATE NAME CONDITION GROUP VARS LOAD-FILE KEYBINDING UUID)


defun yas-define-snippets (mode snippets)
  "Define SNIPPETS for MODE.

SNIPPETS is a list of snippet definitions, each taking the
following form"

(KEY TEMPLATE NAME CONDITION GROUP EXPAND-ENV LOAD-FILE KEYBINDING UUID SAVE-FILE)


yas--template-get-file (template)


(cl-defstruct (yas--snippet (:constructor yas--make-snippet (expand-env)))
  "A snippet.

..."
  expand-env
  (fields '())
  (exit nil)
  (id (yas--snippet-next-id) :read-only t)
  (control-overlay nil)
  active-field
  ;; stacked expansion: the `previous-active-field' slot saves the
  ;; active field where the child expansion took place
  previous-active-field
  force-exit)

(cl-defstruct (yas--field (:constructor yas--make-field (number start end parent-field)))
  "A field.

NUMBER is the field number.
START and END are mostly buffer markers, but see \"apropos markers-to-points\".
PARENT-FIELD is a `yas--field' this field is nested under, or nil.
MIRRORS is a list of `yas--mirror's
TRANSFORM is a lisp form.
MODIFIED-P is a boolean set to true once user inputs text.
NEXT is another `yas--field' or `yas--mirror' or `yas--exit'.
"
  number
  start end
  parent-field
  (mirrors '())
  (transform nil)
  (modified-p nil)
  next)


(cl-defstruct (yas--mirror (:constructor yas--make-mirror (start end transform)))
  "A mirror.

START and END are mostly buffer markers, but see \"apropos markers-to-points\".
TRANSFORM is a lisp form.
PARENT-FIELD is a `yas--field' this mirror is nested under, or nil.
NEXT is another `yas--field' or `yas--mirror' or `yas--exit'
DEPTH is a count of how many nested mirrors can affect this mirror"
  start end
  (transform nil)
  parent-field
  next
  depth)


dolist (field (yas--snippet-fields snippet))

(defun yas--snippet-map-markers (fun snippet)
  "Apply FUN to all marker (sub)fields in SNIPPET.
Update each field with the result of calling FUN."
  (dolist (field (yas--snippet-fields snippet))
    (setf (yas--field-start field) (funcall fun (yas--field-start field)))
    (setf (yas--field-end field)   (funcall fun (yas--field-end field)))
    (dolist (mirror (yas--field-mirrors field))
      (setf (yas--mirror-start mirror) (funcall fun (yas--mirror-start mirror)))
      (setf (yas--mirror-end mirror)   (funcall fun (yas--mirror-end mirror)))))
  (let ((snippet-exit (yas--snippet-exit snippet)))
    (when snippet-exit
      (setf (yas--exit-marker snippet-exit)
            (funcall fun (yas--exit-marker snippet-exit))))))




;; 这么看来 overlay 几乎和子模式一样强大
(defun yas--make-control-overlay (snippet start end)
  "Create the control overlay that surrounds the snippet and
holds the keymap."
  (let ((overlay (make-overlay start
                               end
                               nil
                               nil
                               t)))
    (overlay-put overlay 'keymap yas-keymap)
    (overlay-put overlay 'priority 100)
    (overlay-put overlay 'yas--snippet snippet)
    overlay))


之前我那个hack, 似乎可以用下面这个
yas-skip-and-clear-or-delete-char (&optional field)
  "Clears unmodified field if at field start, skips to next tab.

Otherwise deletes a character normally by calling `delete-char'."


yas--skip-and-clear (field &optional from)
  "Deletes the region of FIELD and sets it's modified state to t.
If given, FROM indicates position to start at instead of FIELD's beginning."
  ;; Just before skipping-and-clearing the field, mark its children
  ;; fields as modified, too. If the children have mirrors-in-fields
  ;; this prevents them from updating erroneously (we're skipping and
  ;; deleting!).
  ;;
yas--auto-fill 有可能造成换行

(swiper-other-window "yas--auto-fill" "~/emacs_libs/modes/yasnippet.el")
(swiper-other-window "defun yas-expand-snippet" "~/emacs_libs/modes/yasnippet.el")
(swiper-other-window "post hook" "~/emacs_libs/modes/yasnippet/yasnippet.el")
(swiper-other-window "defun yas--markers-to-points" "~/emacs_libs/modes/yasnippet/yasnippet.el")


(yas-expand-snippet "${1:test1}")


;; 不应该换行, 打了edebug, 不在于yas--auto-fill
;; 找到原因, 换行是因为模版字符串里面有 \n
(progn
  (yas-minor-mode 0)
  (yas-minor-mode t))

(add-hook 'dkf-hook (lambda (sd) )
          )


(add-hook 'name-hook 'function)


yas pre hook 关闭 my-normal-mode


;; fix: 嵌套结束, 外层 mark 报错
buffer-undo-list

(add-hook 'name-hook 'function)

(yas-expand-snippet "${1:test1}")

(move-marker (make-marker) 111)


(push `(apply yas--snippet-revive ,yas-snippet-beg ,yas-snippet-end ,snippet) buffer-undo-list)
;; ====>
yas--snippet-revive
;; ====>
yas--points-to-markers
;; ====>
yas--snippet-map-markers
;; ====> 用在 yas--points-to-markers 内部, 这是个有效的debug方法
yas--snippet-map-markers2
(defun yas--snippet-map-markers2 (fun snippet)
  "Apply FUN to all marker (sub)fields in SNIPPET.
Update each field with the result of calling FUN."
  (dolist (field (yas--snippet-fields snippet))
    ;; 嵌套, 里层退出后, 外层snippet在这里报错
    (setf (yas--field-start field) (funcall fun (yas--field-start field)))
    (setf (yas--field-end field)   (funcall fun (yas--field-end field)))
    (dolist (mirror (yas--field-mirrors field))
      (setf (yas--mirror-start mirror) (funcall fun (yas--mirror-start mirror)))
      (setf (yas--mirror-end mirror)   (funcall fun (yas--mirror-end mirror)))))
  (let ((snippet-exit (yas--snippet-exit snippet)))
    (when snippet-exit
      (setf (yas--exit-marker snippet-exit)
            (funcall fun (yas--exit-marker snippet-exit))))))

;; 上面的问题解决, 但是 C-z 时候的active-field和光标都还不太如意 

zobbie 警告:
(yas-expand-snippet "${1:test1}") $3 C-k lam 


;; 重命名key和name, 用于helm, 检查emacs-mode的yas key

重写mapcar的yas,
add-hook 需要换行,


'func ==> lambda

接受默认的东西:
C-i 接受并跳到下一个
C-u 接受并扩展
不接受的东西:
C-d 删除并跳到下一个 C-l
C-k 替换


(yas--table-all-keys (car (yas--get-snippet-tables)))

(defun yas--table-all-names (table)
  (ht-map
             (lambda (key value)
               (let (name)
                 (setq name
                       (car             ;ht-keys 返回列表
                        (ht-keys value)))))
             (yas--table-hash table)))

(yas--table-all-names (car (yas--get-snippet-tables)))


(member "ff" (list "ff3" "d" "b" "e" "ff" "ff2" "b"))
(-contains? (list "ff3" "d" "b" "e" "ff" "ff2" "b") "ff")


(-contains? (yas--table-all-keys (car (yas--get-snippet-tables))) "mp")

(yas-load-directory "~/a0_emacs_lib/yas-for-emacs")
(yas-)

(add-hook 'bala-hook (lambda (n) (mapcar (lambda (n) )
                                         'list))
          )


(add-hook 'yas-before-expand-snippet-hook (lambda () (my-normal-off))
          )


yas-tools
访问各种东西的api

上一个field, 下一个field

yas-next-field
                             yas-prev-field
