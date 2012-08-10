;; Fonctions pour manipuler la pile.

(defun get-sp (&optional (mv 'mv))
  (get-prop mv :SP)
  )

(defun set-sp (mv val)
  (set-prop mv :SP val)
)

(defun inc-sp (mv)
  (inc-prop mv :SP)
  )

(defun dec-sp (mv)
  (dec-prop mv :SP)
  )

(defun get-fp (&optional (mv 'mv))
  (get-prop mv :FP)
  )

(defun set-fp (mv val)
  (set-prop mv :FP val)
)