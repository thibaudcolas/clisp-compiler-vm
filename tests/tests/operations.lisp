(format t "~%Tests de calculs arithmétiques :~%")

(test-projet mv 108 '(+ 65 43) "ADD")
(test-projet mv -45 '(- 55 100) "SUB")
(test-projet mv 64 '(* 8 8) "MULT")
(test-projet mv 1 '(/ 8 8) "DIV")

(test-projet mv 1280 '(+ 650 430 200) "ADD BIS")
(test-projet mv -4500 '(- 5500 10000) "SUB BIS")
(test-projet mv 192 '(* 8 8 3) "MULT BIS")
(test-projet mv -1 '(/ -8 8) "DIV BIS")

(test-projet mv -26400 '(* (/ 70 (- 5699 5692)) (- 2 4) 33 40) "ADD SUB MULT DIV")