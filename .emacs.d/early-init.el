;; Defer garbage collection further back in the startup process
;; (setq gc-cons-threshold most-positive-fixnum)
;;(setq gc-cons-threshold 134217728)   ; 128mb
(setq gc-cons-threshold most-positive-fixnum
      file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
      (lambda ()
        (setq gc-cons-threshold (* 2 1000 1000)
          file-name-handler-alist last-file-name-handler-alist)))

;; Do not resize the frame at this early stage.
(setq frame-inhibit-implied-resize t)

;; In noninteractive sessions, prioritize non-byte-compiled source files to
;; prevent the use of stale byte-code. Otherwise, it saves us a little IO time
;; to skip the mtime checks on every *.elc file.
(setq load-prefer-newer noninteractive)

;; Prevent unwanted runtime builds; packages are compiled ahead-of-time when
;; they are installed and site files are compiled when gccemacs is installed.
(setq comp-deferred-compilation nil
      native-comp-deferred-compilation nil)

;; Prevent the glimpse of un-styled Emacs by disabling these UI elements early.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq fancy-startup-text nil)
(setq fancy-about-text nil)
