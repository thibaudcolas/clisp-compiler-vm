;; Fonctions de mise à jour des drapeaux de la machine virtuelle.

(defun set-drapeaux (mv dpp de dpg)
  (set-prop mv :DPP dpp)
  (set-prop mv :DE de)
  (set-prop mv :DPG dpg)
  )

(defun is-egal (mv)
  (eql (get-prop mv :DE) 1)
  )

(defun is-not-egal (mv)
  (not (is-egal mv))
  )

(defun is-pluspetit (mv)
  (eql (get-prop mv :DPP) 1)
  )

(defun is-not-pluspetit (mv)
  (not (is-pluspetit mv))
  )

(defun is-plusgrand (mv)
  (eql (get-prop mv :DPG) 1)
  )

(defun is-not-plusgrand (mv)
  (not (is-plusgrand mv))
  )