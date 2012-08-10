;; Fonctions d'affichage du contenu de la mémoire.

(defun aff-zone (mv ind fin)
  (if (and (<= ind fin) (< ind (get-taille mv)) (>= ind 0))
      (progn (aff-case mv ind)
	     (aff-zone mv (+ ind 1) fin))
    )
  )

(defun aff-case (mv ind)
  (if (= (mod ind 5) 0) (format t "~%~D " ind))
  (format t ".~S" (get-mem mv ind))
  )

(defun aff-globals (&optional (mv 'mv))
  (aff-zone mv 0 100)
  )

(defun aff-all (&optional (mv 'mv))
  (aff-zone mv 0 (get-taille mv))
  )