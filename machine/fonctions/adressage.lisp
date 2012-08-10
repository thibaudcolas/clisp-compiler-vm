;; Fonctions de résolution des adresses.


;; Exemples d'adressage dans l'ordre :
;; (), 598, :R3, (:DIESE 5), (6 :R1), (:@ :etiqfin), (:* 2 :R2)

(defun is-prop (e) 
  (member e (list :R0 :R1 :R2 :R3 :SP :VP :FP :DPP :DE :DPG :PC :LC))
  )

(defun is-const (e)
  (eql (car e) :DIESE)
  )

(defun is-index (e)
  (numberp (car e))
  )

(defun get-index (mv e)
  (get-mem mv (+ (car e) (get-src mv (cadr e))))
  )

(defun is-etiq (e) 
  (eql (car e) :@)
  )

(defun is-indir (e) 
  (eql (car e) :*)
  )

(defun get-indir-src (mv e)
  (get-mem mv (if (null (cddr e)) 
		  (get-src mv (cadr e)) 
		(get-src mv (cdr e)))
	   )
  )

(defun get-indir-dst (mv e)
  (if (null (cddr e))
      (get-src mv (cadr e))
    (if (is-index (cdr e))
	(+ (cadr e) (get-src mv (caddr e)))
      (if (is-etiq (cdr e)) 
	  (get-src mv (cdr e))
	)
      )
    )
  )

(defun is-loc (e)
  (eql (car e) 'LOC)
  )

(defun get-newFP (mv e)
  (let ((newFP (get-fp mv)))
    (loop while (> (get-mem mv (+ 3 newFP)) (caddr e))
	  do (setf newFP (get-mem mv (+ 2 newFP)))
	  )
    newFP
    )
  )

(defun get-loc-src (mv e)
  (if (eql (caddr e) ()) (setf (caddr e) 0))
  (let ((newFP (get-newFP mv e)))
    (if (< (cadr e) 0)
	(get-mem mv (- newFP (get-mem mv newFP) 1 (cadr e)))
      (get-mem mv ( + 4 newFP (cadr e)))
      )
    )
  )

(defun get-loc-dst (mv e)
  (let ((newFP (get-newFP mv e)))
    (if (< (cadr e) 0)
	(- newFP (get-mem mv newFP) 1 (cadr e))  
      (+  4 newFP  (cadr e))
      )
    )
  )


;; Renvoie les contenus pour src / les adresses pour dst.
 
(defun get-src (mv exp)
  (if (atom exp)
      (cond
       ((null exp) 0)
       ((numberp exp) (get-mem mv exp))
       ((is-prop exp) (get-prop mv exp))
       )
    (if (consp exp)
	(cond
	 ((is-const exp) (cadr exp))
	 ((is-index exp) (get-index mv exp))
	 ((is-etiq exp) (get-etiq mv (cadr exp))) 
	 ((is-indir exp) (get-indir-src mv exp))
	 ((is-loc exp) (get-loc-src mv exp))
	 )
      )
    )
  )

(defun get-dst (mv exp)
  (if (atom exp)
      (cond
       ((null exp) 0)
       ((numberp exp) exp)
       ((is-prop exp) exp)
       )
    (if (consp exp)
	(cond
	 ((is-index exp) exp)
	 ((is-etiq exp) (get-etiq mv (cadr exp)))
	 ((is-const exp) (cadr exp))
	 ((is-indir exp) (get-indir-dst mv exp))
	 ((is-loc exp) (get-loc-dst mv exp))
	 )
      )
    )
  )