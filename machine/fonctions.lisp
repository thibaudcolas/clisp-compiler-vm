;; Fonctions de gestion de la machine virtuelle.

;; ********** Gestion des attributs de la machine.

(defun get-prop (mv prop)
  (get mv prop)
  )

(defun set-prop (mv prop val)
  (setf (get mv prop) val)
  )

(defun inc-prop (mv prop)
  (set-prop mv prop (+ (get-prop mv prop) 1))
  )

(defun dec-prop (mv prop)
  (set-prop mv prop (- (get-prop mv prop) 1))
  )

(defun set-tab (tab cle val)
  (setf (aref tab cle) val)
  )


;; ********** Gestion de la mémoire.

(defun get-taille (&optional (mv 'mv))
  (get-prop mv :taille)
  )

(defun set-taille (mv tmem)
  (set-prop mv :taille tmem)
  )

(defun get-mem (mv adr)
  (aref (get mv :memtab) adr)
  )

(defun set-mem (mv adr val)
  (set-tab (get mv :memtab) adr val)
  )


;; ********** Gestion des registres.

(defun get-reg (mv reg)
  (get-prop mv reg)
  )

(defun set-reg (mv reg val)
  (set-prop mv reg val)
  )

;; ********** Gestion des tables de hashage des étiquettes.
(require "machine/fonctions/etiquettes.lisp")

;; ********** Gestion des compteurs ordinaux PC et LC.
(require "machine/fonctions/compteurs.lisp")

;; ********** Gestion de la pile.
(require "machine/fonctions/pile.lisp")

;; ********** Gestion des instructions en mémoire.
(require "machine/fonctions/instructions.lisp")

;; ********** Gestion du chargement du code en mémoire.
(require "machine/fonctions/chargement.lisp")

;; ********** Gestion des drapeaux de comparaison.
(require "machine/fonctions/drapeaux.lisp")

;; ********** Gestion de l'adressage.
(require "machine/fonctions/adressage.lisp")

;; ********** Etat de la machine : contenus mémoire et pile.
(require "machine/fonctions/affichage.lisp")

;; ********** Etat de la machine : lancée ou éteinte.

(require "machine/fonctions/run.lisp")