(format t "~%Tests des structures de contrôle :~%")

(test-projet-double mv 10 '(* a 2) '(setf a 5) "SETF")
(test-projet-double mv 20 '(* a 2) '(setf a (+ a 5)) "SETF BIS")

(test-projet mv 18 '(progn (setf a 9) (if (< a 10) (* 2 a) (* 3 a))) "PROGN")
(test-projet mv 33 '(progn (setf a 11) (if (< a 10) (* 2 a) (* 3 a))) "PROGN BIS")

(test-projet-double mv 30 '(test-let 10) '(defun test-let (x) (let ((a 20)) ( + a x))) "LET")
(test-projet-double mv 24 '(test-let-bis 3 4) '(defun test-let-bis (x y) (let (( a 1) (b 2)) (* x y a b))) "LET BIS")