(format t "~%Tests d'opérateurs booléens :~%")

(test-projet-cond mv T '(= 2 2) "= ")
(test-projet-cond mv T '(> 2 1) "> ")
(test-projet-cond mv T '(< 2 3) "< ")
(test-projet-cond mv T '(>= 2 2) ">=")
(test-projet-cond mv T '(>= 3 2) ">=")
(test-projet-cond mv T '(<= 2 2) "<=")
(test-projet-cond mv T '(<= 2 3) "<=")