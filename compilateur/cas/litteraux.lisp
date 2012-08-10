;; Compilation de littéraux.

(defun compilation-const (exp)
  `((MOVE (:DIESE ,exp) :R0))
  )

(defun compilation-varg (exp)
  `((MOVE (:* :@ ,exp) :R0))
  )

(defun compilation-litt (exp env fenv nomf)
  (let ((var (assoc exp env)))
    (cond
     ((not (null var))
      (if (eql (cadr var) 'loc) 
	  `((MOVE ,(cdr var) :R0))
	(if (numberp (cadr var)) 
	    (compilation-const (cdr var)))
	)
      )
     ((and (symbolp exp) (not (null exp))) (compilation-varg exp))
     (t (compilation-const exp))
     )
    )
  )