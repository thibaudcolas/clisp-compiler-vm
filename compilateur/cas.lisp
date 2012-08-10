;; Gestion de tous les différents cas de compilation possibles / gérés.


;; Compilation de littéraux.

(require "compilateur/cas/litteraux.lisp")


;; Compilation d'opérations arithmétiques.

(require "compilateur/cas/operations.lisp")


;; Compilation d'opérateurs de comparaison.

(require "compilateur/cas/booleens.lisp")


;; Compilation de structures de condition.

(require "compilateur/cas/conditions.lisp")


;; Compilation de structures itératives.

(require "compilateur/cas/boucles.lisp")


;; Compilation de fonctions.

(require "compilateur/cas/fonctions.lisp")


;; Compilation des déclarations de variables.

(require "compilateur/cas/variables.lisp")


;; Compilation des labels

(require "compilateur/cas/labels.lisp")