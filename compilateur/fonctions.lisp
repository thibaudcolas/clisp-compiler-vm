;; Fonctions de gestion du compilateur.

;; ********** Gestion de l'analyse par cas.

(defun is-cas (exp inst)
  (eql (car exp) inst)
  )