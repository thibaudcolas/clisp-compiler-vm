(format t "~%Tests des fonctions et lambda-expressions :~%")

(test-projet-double mv 5 '(f 6) '(defun f (x) (- x 1)) "FUN")
(test-projet-double mv 15 '(g 6) '(defun g (x) (* 3 (f x))) "FUN BIS")

(test-projet mv 22 '((lambda (x) (* 2 x)) 11) "LAMBDA")
(test-projet mv -2189 '((lambda (x) (- x (* 200 x))) 11) "LAMBDA BIS")