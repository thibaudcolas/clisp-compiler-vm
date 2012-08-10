(require "machine/fonctions.lisp")
(require "machine/instructions.lisp")

;; Fonctions structurelles de la machine virtuelle.

;; nom : Nom de la machine.
;; R0, R1, R2, R3 : Registres.
;; BP : Base Pointer initialisé à 100, pile montante.
;; SP : Stack Pointer, si pile vide SP = BP.
;; FP : Frame Pointer
;; DPP : Drapeau de comparaison "plus petit".
;; DE : Drapeau de comparaison "égalité".
;; DPG : Drapeau de comparaison "plus grand".
;; taille : Taille allouée à la mémoire (pile + tas + code).
;; memtab : Mémoire de la machine.
;; PC : Program Counter, compteur ordinal, position dans le code.
;; LC : Load Counter, position du chargement du code.
;; etiq : Table de hashage pour les étiquettes.
;; etiqNR : Table de hashage des étiquettes non résolues


;; ********** Création d'une machine virtuelle.

(defun make-machine (&optional (nom 'mv) (tmem 10000) (aff ()))
  (set-prop nom :nom nom)
  (set-prop nom :R0 0)
  (set-prop nom :R1 0)
  (set-prop nom :R2 0)
  (set-prop nom :R3 0)
  (set-prop nom :BP 100)
  (set-prop nom :SP 100)
  (set-prop nom :VP 1)
  (set-prop nom :FP 0)
  (set-prop nom :DPP 0)
  (set-prop nom :DE 0)
  (set-prop nom :DPG 0)
  (reset-memoire nom tmem)
  (if (not (null aff)) (print-machine nom))
  )
  
;; ********** Vidage mémoire d'une machine virtuelle.

(defun reset-memoire (&optional (nom 'mv) (tmem 10000))
  (let ((taille (max tmem 1000)))
    (set-taille nom taille)
    (set-prop nom :memtab (make-array taille))
    (set-pc nom (- taille 1))
    (set-lc nom (- taille 1))
    (set-prop nom :etiq (make-hash-table :size taille))
    (set-prop nom :etiqNR (make-hash-table :size taille))
    (set-etiqNR nom 'nb 0)
    )
  )


;; ********** Chargement de code dans la mémoire d'une machine virtuelle.

(defun load-machine (mv asm)
  (let ((exp asm)
	(inst (car asm))
	(etiqLoc (make-hash-table :size (get-taille mv)))
	(etiqLocNR (make-hash-table :size (get-taille mv))))
    (set-hash etiqLocNR 'nb 0)
    (loop while exp
	  do
	  (case (car inst)
	    ('@ (case-adr mv exp inst etiqLoc etiqLocNR))
	    ('VARG (case-varg mv exp inst))
	    ('JSR (case-saut mv exp inst))
	    ('FEntry (case-fonction mv exp inst))
	    (otherwise (case-other mv exp inst etiqLoc etiqLocNR))
	    )
	  do (setf exp (cdr exp))
	  do (setf inst (car exp))
	  )
    )
  )

  
;; ********** Lancement d'une machine virtuelle.
  
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


;; ********** Affichage de tous les paramètres d'une machine virtuelle.

(defun print-machine (&optional (nom 'mv))
  (format t "~%Machine virtuelle : ~%--- Nom : ~S ~%--- Taille : ~D" nom (get-taille nom))
  (format t "~%- Registres : ~%--- R0 : ~D ~%--- R1 : ~D ~%--- R2 : ~D ~%--- R3 : ~D" 
	  (get-reg nom :R0) (get-reg nom :R1) (get-reg nom :R2) (get-reg nom :R3))
  (format t "~%- Pointeurs : ~%--- BP : ~D ~%--- SP : ~D ~%--- VP : ~D ~%--- FP : ~D"
	  (get-prop nom :BP) (get-prop nom :SP) (get-prop nom :VP) (get-prop nom :FP))
  (format t "~%- Drapeaux : ~%--- DPP : ~D ~%--- DE : ~D ~%--- DPG : ~D"
	  (get-prop nom :DPP) (get-prop nom :DE) (get-prop nom :DPG))
  (format t "~%- Compteurs : ~%--- PC : ~D ~%--- LC : ~D ~%"
	  (get-pc nom) (get-lc nom))
  )
