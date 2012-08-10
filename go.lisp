(require "machine/machine.lisp")
(format t "~%***** Composant machine virtuelle chargé.~%~%")

(require "compilateur/compilateur.lisp")
(format t "~%***** Composant compilateur chargé.~%~%")

(defun run-express (mv code &optional (code-bis ()))
  (if (not (null code-bis)) (load-machine mv (compilation code-bis)))
  (load-machine mv (compilation code))
  (run-machine mv)
  )