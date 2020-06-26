; This code is commented by Ehsan Kourkchi
; to practice some lisp
; October 1 2015

; (load "myProg.lisp")

(setf mylist '(A (B D (E F (G (H (J L M) K) I))) C))


;; (setf mylist '((A 1)((B 1)  ( (F 2) ((G 3) ((H 5)  (K 6)) ))) (C 4)))

;; (setf mylist ' (((A B C) D) (E F) G H))


(setf *open* ())




(defun make-open (*tree*)

(setf tmp (cdr *tree*))
(cond
((atom tmp) (setf *open* (cons tmp *open*)))
((listp tmp ) (setf *open* (append tmp *open*)))
)


)


(defun process-op (tmp *tree* X)

(cond
((listp tmp) (setf *open* (append (cdr tmp) (cdr *open*))))

)

(setf tmpp (car *open*))
(setf *open* (cdr *open*))

(format t "O-??: ~S~%" *open*)
    (cond 
       ((listp tmpp) (depth-first tmpp X))
       ((atom tmpp) (equal tmpp X))
       (T (process-op tmpp *open* X))
    )

)



(defun process (*tree* X)
    (make-open *tree*)
    (format t "Open: ~S~%" *open*)
    (setf tmp (car *open*))
    (setf *open* (cdr *open*))
    (format t "O-PEN: ~S~%" *open*)
    (cond 
       ((listp tmp) (depth-first tmp X))
       ((atom-test tmp X) T)
       (T (process-op tmp *open* X))
    )
)


(defun atom-test (*tree* X)

   (atom *tree*) (atom X) (equal *tree* X)
    
)


(defun not-atom-test (*tree* X)

 (cond
   ((listp *tree*) (equal *tree* X))
   ( T NIL)
    )
)


(defun depth-first (*tree* X)
    (format t "Tree: ~S~%" *tree*)
    (cond 
       ((atom-test (car *tree*) X) T)
       ((not-atom-test (car *tree*) X)  T)
       ((equal *tree* NIL) NIL)
       (T (process *tree* X))
    
    
    
    )
    
    
    
    
    
    ) ; end function


    
  
(defun start (X)
   (setf *open* ())
   (setf *closed* ())
   (depth-first mylist X))
    

    
    
    
    
   