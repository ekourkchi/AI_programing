; This code is written by Ehsan Kourkchi
; To do the Assignment 2 ---  ICS361
; October 8 2015
;
; Based on the puzzle introduced here:
; http://www.mathsisfun.com/puzzles/farmer-crosses-river.html
;
; To load this program in lisp:
; lisp > (load "ehsan20.farmer_goat.lisp")
;
; You need to have the file "search.lisp" in the same directory as this file. 
;
;  
; To run:
;   lisp> (start-over)
;; ;; first node on open = ((1 1 1 1) NIL 0)
;; ;; first node on open = (NIL (1 1 1 1) 1)
;; ;; first node on open = ((0 1 0 1) (1 1 1 1) 1)
;; ;; first node on open = ((1 1 0 1) (0 1 0 1) 2)
;; ;; first node on open = ((0 0 0 1) (1 1 0 1) 3)
;; ;; first node on open = ((1 0 1 1) (0 0 0 1) 4)
;; ;; first node on open = ((0 0 1 0) (1 0 1 1) 5)
;; ;; first node on open = ((1 0 1 0) (0 0 1 0) 6)
;; ;; first node on open = ((0 0 0 0) (1 0 1 0) 7)
;; ;; length of closed = 8
;; ;; length of open = 1
;; ;; solution path = ((1 1 1 1) (0 1 0 1) (1 1 0 1) (0 0 0 1) (1 0 1 1) (0 0 1 0) (1 0 1 0) (0 0 0 0))
;; ;; NIL
;; ;; 





; Loading the search algorithms, i.e. "breadth-first" and "depth-first"
(load "ehsan20.search.lisp")

   
(setf *queue* ())
(setf *state-list* ())

; the list of all possible moves
; for each move, we define a function below
(setf  *moves* '(Wolf-Crosses Goat-Crosses Cabbage-Crosses Only-Farmer-Crosses))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STATE  Definition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Each state is a 4-tuple (i.e. a list of 4 elements as following)
; (F/B Wolf Goat Cabbage)
; 
; 1) F/B --> Position of the farmer and the boat, 0 for the west and 1 for the east
;    Since the farmer and the boat are moving together, we assume both to be the same 
; 2) Wolf --> position of the Wolf, 0 for the west and 1 for the east
; 3) Goat --> position of the Goat, 0 for the west and 1 for the east
; 4) Cabbage --> position of the Cabbage, 0 for the west and 1 for the east
;
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Given the "state", it returns the position of the farmer, (0 or 1)
(defun farmer (state)
 (car state)
)

; Given the "state", it returns the position of the wolf, (0 or 1)
(defun wolf (state)
 (car (cdr state))
)

; Given the "state", it returns the position of the goat, (0 or 1)
(defun goat (state)
 (car (cdr (cdr state)))
)

; Given the "state", it returns the position of the cabbage, (0 or 1)
(defun cabbage (state)
 (car (cdr (cdr (cdr state))))
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;   ACTIONS - MOVES     ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun Only-Farmer-Crosses (state)
   
  (setf f (farmer state))
  (setf w (wolf state))
  (setf g (goat state))
  (setf c (cabbage state))
  
  (setf f (mod (+ 1 f) 2)) ; the postion of the farmer flips
  (good-state? f w g c)    ; if the resulting state is good, it is returned, otherwise nil would be returned

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun Wolf-Crosses (state)
   
  (setf f (farmer state))
  (setf w (wolf state))
  (setf g (goat state))
  (setf c (cabbage state))
  
  (if (/= f w)
     nil
     (progn
        (setf w (mod (+ 1 w) 2))
        (setf f w)
        (good-state? f w g c)
     )
  )

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun Goat-Crosses (state)
   
  (setf f (farmer state))
  (setf w (wolf state))
  (setf g (goat state))
  (setf c (cabbage state))
  
  (if (/= f g)
     nil
     (progn
        (setf g (mod (+ 1 g) 2))
        (setf f g)
        (good-state? f w g c)
     )
  )

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun Cabbage-Crosses (state)
   
  (setf f (farmer state))
  (setf w (wolf state))
  (setf g (goat state))
  (setf c (cabbage state))
  
  (if (/= f c)
     nil
     (progn
        (setf c (mod (+ 1 c) 2))
        (setf f c)
        (good-state? f w g c)
     )
  )

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;    END-OF-MOVES       ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Testing if a state is valid.
; 1) goat and cabbage can not be on one side while the farmer is on the other side
; 2) wolf and goat    can not be on one side while the farmer is on the other side
(defun good-state? (f w g c)

  ; if it's not a valid state
  ; wolf and goat are on one side and farmer is not there
  ; OR
  ; cabbage and goat are on one side and farmer is not there
  (if (or (and (= w g)(/= f w))(and (= g c)(/= f g)))
     
     nil ; then return nil
     (list f w g c) ; else, return the new valid state
  )


)
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


;; ********************
;; T E S T
;
(defun start-over ()

 (setf *tree* ())
 (setf *state-list* ())
 
 (setf *start* '(1 1 1 1))   ; setting the start state
 (setf *goal* '(0 0 0 0))  ; setting the goal state
 
 (setf *state-list* (cons *start* *state-list*))
 (setf start-node (cons *start* (cons nil (list '0))))
 (setf *tree* (cons start-node ()))
 
 (setf *queue* (list (list *start* 0)))
 (recursive-queue)  ; generating the tree of states. This fills the search *tree*
 
 
 (breadth-first 'equal) ; looking for the solution


)
;; ********************






























