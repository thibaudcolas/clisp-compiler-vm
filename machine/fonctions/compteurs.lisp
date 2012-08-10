;; Manipulation des compteurs PC et LC de la machine virtuelle.

(defun get-pc (&optional (mv 'mv))
  (get-prop mv :PC)
  )

(defun set-pc (mv val)
  (set-prop mv :PC val)
)

(defun inc-pc (mv)
  (inc-prop mv :PC)
  )

(defun dec-pc (mv)
  (dec-prop mv :PC)
  )

(defun get-lc (&optional (mv 'mv))
  (get-prop mv :LC)
  )

(defun set-lc (mv val)
  (set-prop mv :LC val)
)

(defun inc-lc (mv)
  (inc-prop mv :LC)
  )

(defun dec-lc (mv)
  (dec-prop mv :LC)
  )