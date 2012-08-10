(format t "~%Tests de structures de condition :~%")

(test-projet mv 1 '(if (> 1 0) 1 0) "IF")
(test-projet mv 0 '(if (= 1 0) 1 0) "IF BIS")

(test-projet mv 200 '(cond ((= 2 3) 5) ((> 1 100) 9) ((< 1 2) 200)) "COND")
(test-projet mv 9 '(cond ((= 2 3) 5) ((< 1 100) 9) ((< 1 2) 200)) "COND BIS")

(test-projet mv 1 '(if (and (< 0 2) (>= 3 3)) 1 0) "AND")
(test-projet mv 0 '(if (and (< 3 2) (>= 3 3)) 1 0) "AND BIS")

(test-projet mv 1 '(if (or (< 0 2) (>= 3 3)) 1 0) "OR")
(test-projet mv 1 '(if (or (< 3 2) (>= 3 3)) 1 0) "OR BIS")