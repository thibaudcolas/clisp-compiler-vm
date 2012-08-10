# Compilateur et machine virtuelle LISP

Réalisé en M1 AIGLE à l'Université Montpellier 2 par Thibaud Colas.

Ce projet contient un compilateur LISP -> Assembleur et une machine virtuelle exécutant le code assembleur généré.

## Démarrage express

- `(load "go.lisp")` Charge tout le code.
- `(make-machine)` Créé la machine `'mv` de taille 10000.
- `(run-express machine code code-optionnel)` Charge et compile le code passé en paramètre et renvoie le contenu de R0.
- Exemple : `(run-express 'mv '(f 4) '(defun f (x) (+ 1 x)))`

## Arborescence du code source

Racine :

- `go.lisp` charge le code de la machine et du compilateur et lance des tests. 
- Les répertoires `/machine`, `/compilateur` et `/tests` contiennent respectivement le code de la machine, du compilateur et des tests.

Répertoire machine:

- `machine.lisp` contient les fonctions principales de la machine virtuelle.
- `instructions.lisp` contient les instructions gérées par la machine.
- `fonctions.lisp` et `/fonctions` contiennent les fonctions d'abstraction du fonctionnement de la machine, de gestion de ses composants mémoire / propriétés / étiquettes / pile / exécution.

Répertoire compilateur:

- `compilateur.lisp` contient la fonction principale du compilateur ("compilation").
- `cas.lisp` et `/cas` contiennent les différents cas de la compilation.

Répertoire test:

- `tests.lisp` et `/tests` contiennent les tests de base livrés avec la MV.
- `fonctions.lisp` contient les différentes fonctions de test.

## Capacités du compilateur

* Les opérations arithmétiques: `+, -, *, /`
* Les opérateurs de comparaison: `=, !=, <, >, <=, >=`
* Les structures de condition: `if` et `cond`
* Les opérateurs booléens: `and`, `or`
* La création de fonctions et lambda-expressions: `defun`, `lambda`
* La déclaration de variables: `setf`, `let`
* Les structures de contrôle: `while`, `until`, `progn`
* La récursivité, double récursivité, récursivité terminale

## Jeu d'instructions de la machine virtuelle

- Transfert registres <> mémoire
  - MOVE source cible
- Gestion de la pile
  - PUSH source
  - POP cible
- Opérations arithmétiques entre registres
  - ADD source cible
  - SUB source cible
  - MULT source cible
  - DIV source cible
- Opérations arithmétiques registres - valeurs
  - INC cible
  - DEC cible
- Sauts
  - JMP cible
  - JSR etiquette
- Sauts conditionnels
  - CMP un deux
  - JL cible
  - JEQ cible
  - JG cible
  - JLE cible
  - JGE cible
  - JNE cible
- Gestion de la machine
  - RTN
  - NOP
  - ERR

## Structure de la machine virtuelle

* nom : Nom de la machine.
* R0, R1, R2, R3 : Registres.
* BP : Base Pointer initialisé à 100, pile montante.
* SP : Stack Pointer, si pile vide SP = BP.
* FP : Frame Pointer
* DPP : Drapeau de comparaison "plus petit".
* DE : Drapeau de comparaison "égalité".
* DPG : Drapeau de comparaison "plus grand".
* taille : Taille allouée à la mémoire (pile + tas + code).
* memtab : Mémoire de la machine.
* PC : Program Counter, compteur ordinal, position dans le code.
* LC : Load Counter, position du chargement du code.
* etiq : Table de hashage pour les étiquettes.
* etiqNR : Table de hashage des étiquettes non résolues.

## Guide d'utilisation

Depuis le répertoire racine, `(load "go.lisp")` charge le code de la machine et celui du compilateur. `gotest.lisp` y ajoute une mv `'mvtest` et une batterie de tests.

Compilation:

> - `(compilation '(code en lisp))`  
> Retourner du code ASM au format de la machine virtuelle.

Machine virtuelle:

> - `(make-machine nom taille affmachine)`  
> Créé une machine, paramètres optionnels (nom par défaut : 'mv).
> 
> - `(print-machine nom)`  
> Affiche les valeurs principales de l'infrastructure de la machine.
> 
> - `(aff-zone nom deb fin)`  
> Affiche le contenu de la mémoire entre deb et fin.
> 
> - `(load-machine nom code)`  
> Charge le code ASM dans la machine à l'adresse du LC.
> 
> - `(run-machine nom)`  
> Lance la machine au PC et renvoie le contenu de R0.

## Fonctions principales

### Fonction principale du compilateur

        (defun compilation (exp &optional (env ()) (fenv ())  (nomf ()) )
          (let ((arg (if (atom exp) () (cdr exp))))
            (cond
             ((atom exp) (compilation-litt exp env fenv nomf))
             ((member (car exp) '(+ - * /)) (compilation-op exp env fenv nomf))
             ((member (car exp) '(< > = <= >= )) (compilation-comp exp env fenv nomf))
             ((is-cas exp 'and) (compilation-and arg (gensym "finAnd") env fenv nomf))
             ((is-cas exp 'or) (compilation-or arg (gensym "finOr") env fenv nomf))
             ((is-cas exp 'if) (compilation-if arg env fenv nomf))
             ((is-cas exp 'cond) (compilation-cond arg (gensym "fincond") env fenv nomf))
             ((is-cas exp 'progn) (compilation-progn arg env fenv nomf))
             ((is-cas exp 'loop) (compilation-boucle arg env fenv nomf))
             ((is-cas exp 'setf) (compilation-setf arg env fenv nomf))
             ((is-cas exp 'defun) (compilation-defun arg env fenv nomf))
             ((is-cas exp 'let ) (compilation-let arg env fenv nomf))
             ((is-cas exp 'labels) (compilation-labels arg env fenv nomf))
             ((and (consp (car exp)) (eql (caar exp) 'lambda)) (compilation-lambda exp env fenv nomf))
             (`(function ,(car exp)) (compilation-appel exp env fenv nomf))
            )
            )
          )

### Fonction principale de la machine virtuelle

        (defun run-machine (&optional (nom 'mv) (aff ()))
          (set-mem-lc nom '(HALT))
          (let ((nbfun 0))
          (loop while (mv-running nom)
            do
            (if (in-fun nom) 
                (saut-fonction nom nbfun)
              (exec-inst nom (get-mem-pc nom) aff)
              )
            )
          )
          (if (mv-overflow nom) 
              (error "Débordement de pile")
            (get-reg nom :R0))
          )

        (defun exec-inst (mv exp &optional (aff ()))
          (let ((inst (car exp))
            (param (cadr exp))
            (param-bis (caddr exp)))
            (if (null exp)
            (mv-nop mv)
              (case inst
            ('MOVE (mv-move mv param param-bis))
            ('ADD (mv-add mv param param-bis))
            ('SUB (mv-sub mv param param-bis))
            ('MULT (mv-mult mv param param-bis))
            ('DIV (mv-div mv param param-bis))
            ('PUSH (mv-push mv param))
            ('POP (mv-pop mv param))
            ('INCR (mv-inc mv param))
            ('DECR (mv-dec mv param))
            ('JMP  (mv-jmp mv param))
            ('CMP  (mv-cmp mv param param-bis))
            ('JEQ (mv-jeq mv param))
            ('JL (mv-jl mv param))
            ('JLE (mv-jle mv param))
            ('JG (mv-jg mv param))
            ('JGE (mv-jge mv param))
            ('JNE (mv-jne  mv param))
            ('JSR (mv-jsr mv param))
            ('RTN (mv-rtn mv))
            ('FENTRY (mv-nop mv))
            ('FEXIT (mv-nop mv))
            ('ERR (mv-err mv))
            (otherwise (mv-err mv exp))
            )
              )
            (if (not (null aff)) (format t "~S~%" (get-mem-pc mv)))
            (dec-pc mv)
            )
          )

### Benchmark de l'exécution du code généré

> F  : (DEFUN FACT (N) (IF (<= N 1) 1 (* N (FACT (- N 1)))))  
> Real time: 0.028569 sec.  
> Run time: 0.024159 sec.  
> Space: 58672 Bytes  
> OK : "Factorielle" : (FACT 9) = 362880  

> F  : (DEFUN FACT-RT (N &OPTIONAL (ACC 1)) (IF (<= N 1) ACC (FACT-RT (- N 1) (* ACC N))))  
> Real time: 0.029055 sec.  
> Run time: 0.029024 sec.  
> Space: 72284 Bytes  
> OK : "Factorielle récursive terminale" : (FACT 11) = 39916800  

> F  : (DEFUN FIBO (N) (IF (< N 2) N (+ (FIBO (- N 1)) (FIBO (- N 2)))))  
> Real time: 0.45251 sec.  
> Run time: 0.443046 sec.  
> Space: 1081392 Bytes  
> GC: 2, GC time: 0.021165 sec.  
> OK : "Fibonacci" : (FIBO 10) = 55  

> F  : (DEFUN FIBO-RT (N) (LABELS ((CALC-FIB (N A B) (IF (= N 0) A (CALC-FIB (- N 1) B (+ A B))))) (CALC-FIB N 0 1)))  
> Real time: 0.040858 sec.  
> Run time: 0.039991 sec.  
> Space: 96176 Bytes  
> OK : "Fibonacci récursive terminale" : (FIBO-RT 12) = 144  
