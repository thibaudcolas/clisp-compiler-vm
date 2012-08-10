;; Manipulations sur les tables de hashage des étiquettes.

(defun get-hash (tab cle)
  (gethash cle tab)
  )

(defun set-hash (tab cle val)
  (setf (gethash cle tab) val)
  )

(defun inc-hash (tab)
  (set-hash tab 'nb (+ (get-hash tab 'nb) 1))
  )

(defun get-etiq (mv cle)
  (get-hash (get-prop mv :etiq) cle)
  )

(defun set-etiq (mv cle val)
  (set-hash (get-prop mv :etiq) cle val)
  )

(defun inc-etiq (mv)
  (inc-hash (get-prop mv :etiq))
  )

(defun get-etiqNR (mv cle)
  (get-hash (get-prop mv :etiqNR) cle)
  )

(defun set-etiqNR (mv cle val)
  (set-hash (get-prop mv :etiqNR) cle val)
  )

(defun inc-etiqNR (mv)
  (inc-hash (get-prop mv :etiqNR))
  )

(defun res-etiq (mv exp adr)
  (if (null exp) 
      ()
    (progn
      (set-mem mv (car exp) (list (car (get-mem mv (car exp))) adr))
      (res-etiq mv (cdr exp) adr)
      )
    )
  )