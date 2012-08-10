;; Récupération des instructions en mémoire et exécution.

(defun get-mem-pc (&optional (mv 'mv))
  (get-mem mv (get-pc mv))
  )

(defun set-mem-pc (mv val)
  (set-mem mv (get-pc mv) val)
  )

(defun get-mem-lc (&optional (mv 'mv))
  (get-mem mv (get-lc mv))
  )

(defun set-mem-lc (mv val)
  (set-mem mv (get-lc mv) val)
  )

(defun is-inst (mv inst)
  (eql (car (get-mem-pc mv)) inst)
  )

(defun in-fun (mv)
  (is-inst mv 'FENTRY)
  )

(defun out-fun (mv)
  (is-inst mv 'FEXIT)
  )

(defun saut-fonction (mv nbfun)
  (setf nbfun (+ nbfun 1))
  (loop while (< 0 nbfun)
	do 
	(dec-pc mv)
	(cond
	 ((in-fun mv) (setf nbfun (+ nbfun 1)))
	 ((out-fun mv) (setf nbfun (- nbfun 1)))
	 )
	)
  )

(defun mv-op (mv op src dst)
  (let ((adr (get-dst mv dst))
	(res (apply op (list (get-src mv (get-dst mv dst)) (get-src mv src)))))
    (set-reg mv adr res)
    )
  )

(defun mv-jcond (mv dst cond)
  (if (apply cond (list mv)) 
      (mv-jmp mv dst))
  )