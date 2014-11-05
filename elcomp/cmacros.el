;;; cmacros.el --- Compiler macros. -*- lexical-binding:t -*-

;;; Commentary:

;; Some compiler macros used by this compiler.

;;; Code:

(require 'elcomp)

(defun elcomp--declare (&rest specs)
  "A compiler macro for `declare'.

This just ensures we preserve the declaration so the compiler can
see it."
  (cons 'declare specs))

(defun elcomp--condition-case (var bodyform &rest handlers)
  "A compiler macro for `condition-case'.

This pushes VAR as a let-binding into HANDLERS, when VAR is not
nil."
  ;; Use a special name so we (us humans hacking on this) don't get
  ;; confused later on.
  (append (list :elcomp-condition-case bodyform)
	  (if var
	      (mapcar (lambda (handler)
			(list (car handler)
			      `(let ((,var (:elcomp-fetch-condition)))
				 ,@(cdr handler))))
		      handlers)
	    handlers)))

;;; cmacros.el ends here
