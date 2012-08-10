;; Tests de fonctions classiques.

(format t "~%Tests de fonctions classiques :~%")

(test-projet-fun mv 362880 '(fact 9) '(defun fact (n) (if (<= n 1) 1 (* n (fact (- n 1))))) "Factorielle")
(test-projet-fun mv 39916800 '(fact 11) '(defun fact-rt (n &optional (acc 1)) (if (<= n 1) acc (fact-rt (- n 1) (* acc n)))) "Factorielle récursive terminale")

(test-projet-fun mv 55 '(fibo 10) '(defun fibo (n) (if (< n 2) n (+ (fibo (- n 1)) (fibo (- n 2))))) "Fibonacci")

(test-projet-fun mv 144 '(fibo-rt 12) '(defun fibo-rt (n) (labels ((calc-fib (n a b) (if (= n 0) a (calc-fib (- n 1) b (+ a b))))) (calc-fib n 0 1))) "Fibonacci récursive terminale")