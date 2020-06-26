; This code is commented by Ehsan Kourkchi
; to practice some lisp
; October 9 2015
;
; Based on the puzzle introduced here:
; http://www.tilepuzzles.com/default.asp?p=12
;
; To load this program in lisp:
; lisp >  (load "ehsan20.8puzzle.lisp")
; 
;
; You need to have the file "search.lisp" in the same directory as this file. 
;
;  
; To run:
;   lisp > (start-over start goal)
; Example:
; lsip > (start-over '((2 8 3)(1 6 4)(7 0 5)) '((1 2 3)(8 0 4)(7 6 5)))
;; ;; first node on open = (((2 8 3) (1 6 4) (7 0 5)) NIL 0)
;; ;; first node on open = (NIL ((2 8 3) (1 6 4) (7 0 5)) 1)
;; ;; first node on open = (((2 8 3) (1 0 4) (7 6 5)) ((2 8 3) (1 6 4) (7 0 5)) 1)
;; ;; first node on open = (((2 0 3) (1 8 4) (7 6 5)) ((2 8 3) (1 0 4) (7 6 5)) 2)
;; ;; first node on open = (((0 2 3) (1 8 4) (7 6 5)) ((2 0 3) (1 8 4) (7 6 5)) 3)
;; ;; first node on open = (((1 2 3) (0 8 4) (7 6 5)) ((0 2 3) (1 8 4) (7 6 5)) 4)
;; ;; first node on open = (((1 2 3) (7 8 4) (0 6 5)) ((1 2 3) (0 8 4) (7 6 5)) 5)
;; ;; first node on open = (((1 2 3) (8 0 4) (7 6 5)) ((1 2 3) (0 8 4) (7 6 5)) 5)
;; ;; length of closed = 7
;; ;; length of open = 5
;; ;; solution path = 
;; ;; (((2 8 3) (1 6 4) (7 0 5)) ((2 8 3) (1 0 4) (7 6 5)) ((2 0 3) (1 8 4) (7 6 5)) ((0 2 3) (1 8 4) (7 6 5)) ((1 2 3) (0 8 4) (7 6 5))
;; ;;  ((1 2 3) (8 0 4) (7 6 5)))
;; ;; NIL

    
    
(load "ehsan20.search.lisp")
(setf *N-row* 3)
(setf *N-col* 3)
(setf *queue* ())
(setf *state-list* ())
(setf  *moves* '(move-up move-down move-right move-left))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STATE  Definition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Each state is a list of 3 sub-list, each of which has 3 members
; This big state list, covers the entire matrix of the puzzle
; row by row
; the blank tile is represented by a '0'
; ((1 2 3) (4 5 6) (7 8 0))
;  1 2 3
;  4 5 6
;  7 8 0
;
; Like ordianry matrices: 
; i-index covers rows from top to bottom starting from 0
; j-index covers columns from left to rgiht starting from 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; finds the column number of the blank (the cell with the value of '0') in a row
; the input row is a list 
(defun which-column(row j)
 
 (cond 
     ((equal (car row) nil) nil)
     ((= (car row) 0) j)
     (T (which-column (cdr row) (+ 1 j)))
 )

)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Returns the i and j position of the blank (the cell with the value of '0')
; the input state is a list 
(defun whereis-blank (state i j)
 
 (cond
   ((null state) nil)
   ((which-column (car state) '0) (list i (which-column (car state) '0)))
   (T (whereis-blank (cdr state) (+ 1 i) '0))
 
 )
 

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; return i and j position of the blank
; the input is the array form of the state.
; This way we can easily use the array operations
(defun whereis-blank-array (array-state)
 
  (setf x nil)
  (loop named outer for i below (array-dimension array-state 0) do
       (loop for j below (array-dimension array-state 1) do
                       
            (if (eq (aref array-state i j) 0)
            (return-from outer (list i j)))   
                          
                       
   ))  ; closing both loops

)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; converting the list form of a state to an array
(defun state-to-array (state)

 (setf state (make-array (list *N-row* *N-col*) 
    :initial-contents state))

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; converting the array form of a state to a list
(defun array-to-list (array-state)
  
 (loop for i below (array-dimension array-state 0) 
  collect  (loop for j below (array-dimension array-state 1) 
    
    collect (aref array-state i j)
 
 ))  ; closing both loops

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;   ACTIONS - MOVES     ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; i,j show the location of the blank
(defun move-up (state)
  
  
  (setf state (state-to-array state))
  (setf ij-list (whereis-blank-array state))
  (setf i (car ij-list))
  (setf j (car (cdr ij-list)))
  
  (setf m (get-ij state i j))
  (if (or (= (+ i 1) *N-row*) (/= m 0))
     nil
     (progn 
       
       (setf n (get-ij state (+ i 1) j))
       
       (setf state (set-ij state i j n))
       (array-to-list (set-ij state (+ i 1) j '0))
     
     )
  )
)


(defun move-down (state)
  
  (setf state (state-to-array state))
  (setf ij-list (whereis-blank-array state))
  (setf i (car ij-list))
  (setf j (car (cdr ij-list)))
  
  (setf m (get-ij state i j))
  (if (or (= (- i 1) -1) (/= m 0))
     nil
     (progn 
       
       (setf n (get-ij state (- i 1) j))
       
       (setf state (set-ij state i j n))
       (array-to-list (set-ij state (- i 1) j '0))
     
     )
  )
)


(defun move-left (state)
  
  (setf state (state-to-array state))
  (setf ij-list (whereis-blank-array state))
  (setf i (car ij-list))
  (setf j (car (cdr ij-list)))
  
  
  (setf m (get-ij state i j))
  (if (or (= (+ j 1) *N-col*) (/= m 0))
     nil
     (progn 
       
       (setf n (get-ij state i (+ j 1)))
       
       (setf state (set-ij state i j n))
       (array-to-list (set-ij state i (+ j 1) '0))
     
     )
  )
)


(defun move-right (state)
  
  (setf state (state-to-array state))
  (setf ij-list (whereis-blank-array state))
  (setf i (car ij-list))
  (setf j (car (cdr ij-list)))
  
  (setf m (get-ij state i j))
  (if (or (= (- j 1) -1) (/= m 0))
     nil
     (progn 
       
       (setf n (get-ij state i (- j 1)))
       
       (setf state (set-ij state i j n))
       (array-to-list (set-ij state i (- j 1) '0))
     
     )
  )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;    END-OF-MOVES       ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; setting the state(i,j) = n
; state is in array form
(defun set-ij (state i j n)

  (setf (aref state i j) n)
  (setf out-state state)
)


; getting the value of state(i,j) 
; state is in array form
(defun get-ij (state i j)

  (aref state i j)
  
)



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

          
          ; in this puzzle we don't complete the entire search tree
          ; for a 3*3 puzzle, the number of possible states would be 9! = 362,880
          ; and one may get "stack-overflow" error
          ; Therefore, once we find the goal state, we terminate the process of
          ; finding more possible states
          (if (equal child *goal*)
             (setf *queue* ()) ; then
             (allmoves-make-node-state (cdr move) state level) ; else
          )
            
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

   
   
(defun start-over (start goal)
 
 ; start : '((2 8 3)(1 6 4)(7 0 5))
 ; goal  : '((1 2 3)(8 0 4)(7 6 5))
 
 (setf *tree* ())
 (setf *state-list* ())

 (setf *N-row* 3)
 (setf *N-col* 3)
 (setf *start* start)
 (setf *goal*  goal)   
 

 (setf *state-list* (cons *start* *state-list*))
 (setf start-node (cons *start* (cons nil (list '0))))
 (setf *tree* (cons start-node ()))
 
 (setf *queue* (list (list *start* 0)))
 (recursive-queue )
 
 
 
 
 (breadth-first 'equal)


)


























