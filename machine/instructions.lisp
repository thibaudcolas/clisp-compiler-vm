;; Instructions utilisables par la machine virtuelle.
;;
;; MOVE source cible
;;
;; PUSH source
;; POP cible
;;
;; ADD source cible
;; SUB source cible
;; MULT source cible
;; DIV source cible
;;
;; INC cible
;; DEC cible
;;
;; JMP cible
;; JSR etiquette
;;
;; CMP un deux
;; JL cible
;; JEQ cible
;; JG cible
;; JLE cible
;; JGE cible
;; JNE cible
;;
;; RTN
;; NOP
;; ERR


;; ********** Instructions de transfert registres <-> mémoire.

(defun mv-move (mv src dst)
  (let ((adr (get-dst mv dst))
	(res (get-src mv src)))
    (if (numberp adr)
	(set-mem mv adr res)
      (set-prop mv adr res)
      )
    )
  )


;; ********** Instructions de gestion de la pile.

(defun mv-push (mv src)
  (inc-sp mv)
  (mv-move mv src '(:* :SP))
  )

(defun mv-pop (mv dst)
  (mv-move mv '(:* :SP) dst)
  (dec-sp mv)
  )

;; ********** Instructions arithmétiques entre registres.

(defun mv-add (mv src dst)
  (mv-op mv '+ src dst)
  )

(defun mv-sub (mv src dst)
  (mv-op mv '- src dst)
  )

(defun mv-mult (mv src dst)
  (mv-op mv '* src dst)
  )

(defun mv-div (mv src dst)
  (mv-op mv '/ src dst)
  )


;; ********** Instructions arithmétiques registre <-> valeur.

(defun mv-inc (mv dst)
  (mv-add mv '(:DIESE 1) dst)
  )

(defun mv-dec (mv dst)
  (mv-sub mv '(:DIESE 1) dst)
  )

;; ********** Instructions de saut.

(defun mv-jmp (mv dst)
  (if (numberp dst)  
      (set-pc mv dst)
    (mv-move mv dest :PC)
    )
  )

(defun mv-jsr (mv etq)
  (mv-push mv :PC)
  (mv-jmp mv etq)
  ) 


;; ********** Instructions de saut conditionnel.

(defun mv-cmp (mv recto verso)
  (let ((r (get-src mv recto))
	(v (get-src mv verso)))
    (if (and (numberp r) (numberp v))
	(cond
	 ((eql r v) (set-drapeaux mv 0 1 0))
	 ((< r v) (set-drapeaux mv 1 0 0))
	 ((> r v) (set-drapeaux mv 0 0 1))
	 )
      (if (eql r v) 
	  (set-drapeaux mv 0 1 0)
	(set-drapeaux mv 0 0 0)
	)
      )
    )
  )

(defun mv-jl (mv dst)
  (mv-jcond mv dst 'is-pluspetit)
  )

(defun mv-jeq (mv dst)
  (mv-jcond mv dst 'is-egal)
  )
      
(defun mv-jg (mv dst)
  (mv-jcond mv dst 'is-plusgrand)
  )

(defun mv-jle (mv dst)
  (mv-jcond mv dst 'is-not-plusgrand)
  )


(defun mv-jge (mv dst)
  (mv-jcond mv dst 'is-not-pluspetit)
  )

(defun mv-jne (mv dst)
  (mv-jcond mv dst 'is-not-egal)
  )


;; ********** Instructions de gestion de la machine.

(defun mv-rtn (mv)
  (mv-move mv '( 1 :FP) :SP)
  (mv-move mv '( 4 :FP) :PC)
  (mv-move mv '( 2 :FP)  :FP)
  )

(defun mv-nop (mv)
  )

(defun mv-err (mv exp)
  (format t "Erreur : ~S~%" exp)
  )