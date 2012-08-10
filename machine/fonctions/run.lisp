;; Gestion de l'exécution de la machine.

(defun inst-ok (mv)
  (consp (get-mem-pc mv))
  )

(defun not-halt (mv)
  (not (is-inst mv 'HALT))
  )

(defun mv-running (&optional (mv 'mv))
  (and (inst-ok mv)  (not-halt mv))
  )

(defun mv-overflow (mv)
  (>= (get-sp mv) (get-pc mv))
  )
