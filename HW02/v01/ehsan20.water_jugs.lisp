; This code is commented by Ehsan Kourkchi
; to practice some lisp
; October 8 2015
;
; Based on the puzzle introduced here:
; http://www.math.tamu.edu/~dallen/hollywood/diehard/diehard.htm
;
; To load this program in lisp:
; lisp > (load "ehsan20.water_jugs.lisp")
;
; You need to have the file "search.lisp" in the same directory as this file. 
;
;  
; To run:
;   lisp > (start-over jug-A-capacity jug-B-capacity goal-gallon)
;   
; Example: lisp >  (start-over 7 3 5)
;; ;; first node on open = ((0 0) NIL 0)
;; ;; first node on open = (NIL (0 0) 1)
;; ;; first node on open = ((7 0) (0 0) 1)
;; ;; first node on open = ((7 3) (7 0) 2)
;; ;; first node on open = ((4 3) (7 0) 2)
;; ;; first node on open = ((4 0) (4 3) 3)
;; ;; first node on open = ((1 3) (4 0) 4)
;; ;; first node on open = ((1 0) (1 3) 5)
;; ;; first node on open = ((0 1) (1 0) 6)
;; ;; first node on open = ((7 1) (0 1) 7)
;; ;; first node on open = ((5 3) (7 1) 8)
;; ;; length of closed = 10
;; ;; length of open = 1
;; ;; solution path = ((0 0) (7 0) (4 3) (4 0) (1 3) (1 0) (0 1) (7 1) (5 3))
;; ;; NIL



; Loading the search algorithms, i.e. "breadth-first" and "depth-first"
(load "ehsan20.search.lisp")

   
; the list of all possible moves
; for each move, we define a function below
(setf  *moves* '(empty-A empty-B fill-A fill-B A-to-B B-to-A))
(setf *queue* ())
(setf *state-list* ())


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STATE  Definition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Each state is a 2-tuple
;  (A  B)
;  A: the amount of water in jug A
;  B: the amount of water in jug B


; Constants
;; capacity of the jug A 
(defparameter *CA* 7)

;; capacity of the jug B
(defparameter *CB* 3)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; retuns how much water is in jug A
(defun in-A (state)
 (car state)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; retuns how much water is in jug A
(defun in-B (state)
 (car (cdr state))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;   ACTIONS - MOVES     ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Makes the jug A empty
; If there is no water in the jug, it returns nil
(defun empty-A (state)
  
  (setf aa (in-A state))
  
  (if (/= aa 0)
    (progn
      (setf bb (in-B state))
      (list '0 bb)
    )
    nil
  )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Makes the jug B empty
; If there is no water in the jug, it returns nil
(defun empty-B (state)
  
  (setf bb (in-B state))
  
  (if (/= bb 0)
    (progn
      (setf aa (in-A state))
      (list aa '0)
    )
    nil
  )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Makes the jug A full
; If the jug is already full, it returns nil
(defun fill-A (state)
  
  (if (>= (in-A state) *CA*)
    nil
    (progn
      (setf bb (in-B state))
      (list *CA* bb)
    )
  
  )
  
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Makes the jug B full
; If the jug is already full, it returns nil
(defun fill-B (state)
  
  (if (>= (in-B state) *CB*)
    nil
    (progn
      (setf aa (in-A state))
      (list aa *CB*)
    )
  
  )
  
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Moves water from A to B, as much as possible
; If there is no water in jug A, it returns nil
(defun A-to-B (state)
  
  
  (setf aa (in-A state))
  (setf bb (in-B state))
  
  (if (eq aa 0)
   
   nil
   
   (progn
     (setf space-B (- *CB* bb))
     (setf move (min aa space-B))
     (setf bb (+ bb move))
     (setf aa (- aa move))
     (list aa bb)
   ) ; end-progn
  
  ) ; end-if
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Moves water from B to A, as much as possible
; If there is no water in jug B, it returns nil
(defun B-to-A (state)
   
  (setf aa (in-A state))
  (setf bb (in-B state))
  
  (if (eq bb 0)
  nil
   (progn
    (setf space-A (- *CA* aa))
    (setf move (min bb space-A))
    (setf aa (+ aa move))
    (setf bb (- bb move))
    (list aa bb)
   ) ; end-progn
  ) ; end-if
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;    END-OF-MOVES       ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function name: recursive-queue
; Input: global variable: *queue*
; 1) Removes the first element of the *queue*
; 2) Finds its valid children states
; 3) Adds thesde children at the of the queue
; 4) recursively continue this process until the queue is empty
; 
; Each member in the *queue* is a tuple of a valid state and 
; its level in the searc htree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun recursive-queue ()

   (if (equal *queue* nil)
   
      nil    ; base-case
    
      (progn ; else
        
        (setf st (car *queue*))
        (setf *queue* (cdr *queue*))
        (setf level (car (cdr st)))
        (setf state (car st))
        (allmoves-make-node-state *moves*  state  level)
      
        (recursive-queue  )
      
      ) ; end progn/else

   ) ; end-if

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; recursively finds all the valid children states of the "state" using all the moves in the list "move"
; level: is hte lvel of the state in the search tree

(defun allmoves-make-node-state (move state level)
   
   (if (or (equal move nil)(equal state nil))
   
        nil
   
       (progn
          
          ; "make-node-state" tests if the "state" can be transformed to a new state
          (setf child (make-node-state (car move) state level))
          
          (if (not (equal child nil)) ; if we find a valid child, we add it to the end of the queue
              (setf *queue* (append *queue* (list (list child (+ 1 level))) ))
          )
          
          (allmoves-make-node-state (cdr move) state level) ; recursively test all the moves fot the "state" to find the valid children

      ) ; end-progn
   )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; "make-node-state" tests if the "state" can be transformed to a new state 
; We always keep track of the level of a state in the search tree
; All the already discovered states are stored in the global list *state-list*
; If the new state is already in this list, it would be ignored and nil would be returned

(defun make-node-state (move state level)
   
   (setf new-state (funcall move state))
   
   
   (if (not (ismember new-state *state-list*))
       
       ; then - the state is newly discovered
       (progn
         (add-node-tree new-state state (+ 1 level)) ; add the state in the tree
         (setf new-state new-state) ; return the state
       ) ; end-progn
       
       ; else
       nil ; already in the *state-list* list
   ) ; end-if

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; this makes a node out of a new child, its parent and its level
(defun add-node-tree (child parent level)
   
   (if (and (not (ismember child *state-list*))(not (equal child nil)))
     
     (progn
     
      (setf new-node (cons child (cons parent (list level))))
      (setf *tree* (cons new-node *tree*))
      (setf *state-list* (cons child *state-list*))
     
     )
    
   ) ; end-if

   
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check the membership of the "lst" list to a bigger "super-list"
; This piece is simply copied from the lecture note 
(defun ismember(lst super-list)

  (cond
  
    ((null super-list) nil)
    ((equal (car super-list) lst) T)
    (T (ismember lst (cdr super-list)))
  
  )


)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Since our desire is to find at lest one gallon filled with goal-gallon ammount of water
; we need to define a new merit function.
   
(defun my-final-goal (state goal-volume)

 (setf aa (in-A state))
 (setf bb (in-B state))
 
 (if (setf out (or (eq aa goal-volume)(eq bb goal-volume)) )
    out
 )

)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun start-over (jug-A-capacity jug-B-capacity goal-gallon)
 
 (setf *tree* ())
 (setf *state-list* ())
 
 (setf *CA* jug-A-capacity)
 (setf *CB* jug-B-capacity)
 
 (setf *start* '(0 0))
 (setf *state-list* (cons *start* *state-list*))
 (setf start-node (cons *start* (cons nil (list '0))))
 (setf *tree* (cons start-node ()))
 
 
 
 (setf *queue* (list (list *start* 0)))
 (recursive-queue)  ; generating the tree of states. This fills the search *tree*
 
 
 (setf *goal* goal-gallon) ; Goal is to have at least one jug filled with goal-gallon
 
 
 (breadth-first 'my-final-goal) ; The function "my-final-goal" is used ... 


)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






























