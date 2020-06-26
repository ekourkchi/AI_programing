; This code is commented by Ehsan Kourkchi
; to practice some lisp
; October 9 2015
;
; Based on the puzzle introduced here:
; http://www.tilepuzzles.com/default.asp?p=12
;
; To load this program in lisp:
; lisp >  (load "ehsan20.8puzzle.v03.lisp")
; 
;
; You need to have the file "search.lisp" in the same directory as this file. 
;
;  
; To run:
;   lisp >  start-over (search-type   depth-limit   start   goal )
;
;; ;; 
;; ;; Example 1: 
;; ;; Lisp > (start-over 'depth-first 6 '((2 8 3)(1 6 4)(7 0 5)) '((1 2 3)(8 0 4)(7 6 5)))
;; ;; open: ((((2 8 3) (1 6 4) (7 0 5)) NIL 0))
;; ;; first node on open = (((2 8 3) (1 6 4) (7 0 5)) NIL 0)
;; ;; first node on open = (((2 8 3) (1 6 4) (7 5 0)) ((2 8 3) (1 6 4) (7 0 5)) 1)
;; ;; first node on open = (((2 8 3) (1 6 0) (7 5 4)) ((2 8 3) (1 6 4) (7 5 0)) 2)
;; ;; first node on open = (((2 8 3) (1 0 6) (7 5 4)) ((2 8 3) (1 6 0) (7 5 4)) 3)
;; ;; first node on open = (((2 8 3) (0 1 6) (7 5 4)) ((2 8 3) (1 0 6) (7 5 4)) 4)
;; ;; first node on open = (((0 8 3) (2 1 6) (7 5 4)) ((2 8 3) (0 1 6) (7 5 4)) 5)
;; ;; first node on open = (((8 0 3) (2 1 6) (7 5 4)) ((0 8 3) (2 1 6) (7 5 4)) 6)
;; ;; first node on open = (((2 8 3) (7 1 6) (0 5 4)) ((2 8 3) (0 1 6) (7 5 4)) 5)
;; ;; --
;; ;; --
;; ;; --
;; ;; first node on open = (((2 3 4) (1 6 8) (7 0 5)) ((2 3 4) (1 0 8) (7 6 5)) 6)
;; ;; first node on open = (((2 3 4) (1 8 5) (7 6 0)) ((2 3 4) (1 8 0) (7 6 5)) 5)
;; ;; first node on open = (((2 3 4) (1 8 5) (7 0 6)) ((2 3 4) (1 8 5) (7 6 0)) 6)
;; ;; first node on open = (((0 2 3) (1 8 4) (7 6 5)) ((2 0 3) (1 8 4) (7 6 5)) 3)
;; ;; first node on open = (((1 2 3) (0 8 4) (7 6 5)) ((0 2 3) (1 8 4) (7 6 5)) 4)
;; ;; first node on open = (((1 2 3) (8 0 4) (7 6 5)) ((1 2 3) (0 8 4) (7 6 5)) 5)
;; ;; 
;; ;; length of closed = 98
;; ;; length of open = 1
;; ;; 
;; ;; # of moves = 5
;; ;; solution path = 
;; ;; (((2 8 3) (1 6 4) (7 0 5)) ((2 8 3) (1 0 4) (7 6 5)) ((2 0 3) (1 8 4) (7 6 5)) ((0 2 3) (1 8 4) (7 6 5)) ((1 2 3) (0 8 4) (7 6 5))
;; ;;  ((1 2 3) (8 0 4) (7 6 5)))
;; ;; T
;; ;; 
;; ;; Example 2:
;; ;; Lisp > (start-over 'breadth-first 6 '((2 8 3)(1 6 4)(7 0 5)) '((1 2 3)(8 0 4)(7 6 5)))
;; ;; first node on open = (((2 8 3) (1 6 4) (7 0 5)) NIL 0)
;; ;; first node on open = (((2 8 3) (1 6 4) (7 5 0)) ((2 8 3) (1 6 4) (7 0 5)) 1)
;; ;; first node on open = (((2 8 3) (1 6 4) (0 7 5)) ((2 8 3) (1 6 4) (7 0 5)) 1)
;; ;; first node on open = (((2 8 3) (1 0 4) (7 6 5)) ((2 8 3) (1 6 4) (7 0 5)) 1)
;; ;; first node on open = (((2 8 3) (1 6 0) (7 5 4)) ((2 8 3) (1 6 4) (7 5 0)) 2)
;; ;; first node on open = (((2 8 3) (0 6 4) (1 7 5)) ((2 8 3) (1 6 4) (0 7 5)) 2)
;; ;; first node on open = (((2 8 3) (1 4 0) (7 6 5)) ((2 8 3) (1 0 4) (7 6 5)) 2)
;; ;; first node on open = (((2 8 3) (0 1 4) (7 6 5)) ((2 8 3) (1 0 4) (7 6 5)) 2)
;; ;; first node on open = (((2 0 3) (1 8 4) (7 6 5)) ((2 8 3) (1 0 4) (7 6 5)) 2)
;; ;; first node on open = (((2 8 3) (1 0 6) (7 5 4)) ((2 8 3) (1 6 0) (7 5 4)) 3)
;; ;; first node on open = (((2 8 0) (1 6 3) (7 5 4)) ((2 8 3) (1 6 0) (7 5 4)) 3)
;; ;; first node on open = (((2 8 3) (6 0 4) (1 7 5)) ((2 8 3) (0 6 4) (1 7 5)) 3)
;; ;; first node on open = (((0 8 3) (2 6 4) (1 7 5)) ((2 8 3) (0 6 4) (1 7 5)) 3)
;; ;; first node on open = (((2 8 0) (1 4 3) (7 6 5)) ((2 8 3) (1 4 0) (7 6 5)) 3)
;; ;; first node on open = (((2 8 3) (1 4 5) (7 6 0)) ((2 8 3) (1 4 0) (7 6 5)) 3)
;; ;; first node on open = (((0 8 3) (2 1 4) (7 6 5)) ((2 8 3) (0 1 4) (7 6 5)) 3)
;; ;; first node on open = (((2 8 3) (7 1 4) (0 6 5)) ((2 8 3) (0 1 4) (7 6 5)) 3)
;; ;; first node on open = (((2 3 0) (1 8 4) (7 6 5)) ((2 0 3) (1 8 4) (7 6 5)) 3)
;; ;; --
;; ;; --
;; ;; --
;; ;; first node on open = (((8 1 3) (2 0 4) (7 6 5)) ((8 0 3) (2 1 4) (7 6 5)) 5)
;; ;; first node on open = (((2 8 3) (7 1 4) (6 5 0)) ((2 8 3) (7 1 4) (6 0 5)) 5)
;; ;; first node on open = (((2 8 3) (7 0 4) (6 1 5)) ((2 8 3) (7 1 4) (6 0 5)) 5)
;; ;; first node on open = (((2 3 4) (1 0 8) (7 6 5)) ((2 3 4) (1 8 0) (7 6 5)) 5)
;; ;; first node on open = (((2 3 4) (1 8 5) (7 6 0)) ((2 3 4) (1 8 0) (7 6 5)) 5)
;; ;; first node on open = (((1 2 3) (8 0 4) (7 6 5)) ((1 2 3) (0 8 4) (7 6 5)) 5)
;; ;; 
;; ;; length of closed = 60
;; ;; length of open = 41
;; ;; 
;; ;; # of moves = 5
;; ;; solution path = 
;; ;; (((2 8 3) (1 6 4) (7 0 5)) ((2 8 3) (1 0 4) (7 6 5)) ((2 0 3) (1 8 4) (7 6 5)) ((0 2 3) (1 8 4) (7 6 5)) ((1 2 3) (0 8 4) (7 6 5))
;; ;;  ((1 2 3) (8 0 4) (7 6 5)))
;; ;; T
;; ;; 
;; ;; 

    
    
    
    
(load "ehsan20.search.v03.lisp")
(setf *N-row* 3)
(setf *N-col* 3)

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
(defun which-column(row n j)
 
 (cond 
     ((equal (car row) nil) nil)
     ((= (car row) n) j)
     (T (which-column (cdr row) n (+ 1 j)))
 )

)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Returns the i and j position of the blank (the cell with the value of '0')
; the input state is a list 
(defun where-is? (state n i j)
 
 (cond
   ((null state) nil)
   ((which-column (car state) n '0) (list i (which-column (car state) n '0)))
   (T (where-is? (cdr state) n (+ 1 i) '0))
 
 )
 

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun where-is (state n)
 
  (where-is? state n 0 0)

)



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
; state is in array farray-stateorm
(defun get-ij (state i j)

  (aref state i j)
  
)





(defun 8uzzle-heuristic (state level)
 
 (setf array-state (state-to-array state))
 (setf array-goal (state-to-array *goal*))
 (setf sum 0)
 
 (loop for i below (array-dimension array-state 0) do
    (loop for j below (array-dimension array-state 1) do 
     
     
     (if (/= (get-ij array-state i j)(get-ij array-goal i j)) 
         
         (setf sum (+ sum 1))

     )
 
 )) 
  
 sum  ; # of out of palce
 
)


(defun 8uzzle-heuristic (state level)
 
 (setf array-state (state-to-array state))
 (setf array-goal (state-to-array *goal*))
 (setf sum 0)
 
 (loop for i below (array-dimension array-state 0) do
    (loop for j below (array-dimension array-state 1) do 
     
     
     (if (/= (get-ij array-state i j)(get-ij array-goal i j)) 
         
         (setf sum (+ sum 1))

     )
 
 )) 
  
 sum  ; # of out of palce
 
)





(defun 8uzzle-heuristic-manhattan (state level)
 
 (setf array-state (state-to-array state))
 
 (setf sum 0)
 
 (loop for i below (array-dimension array-state 0) do
    (loop for j below (array-dimension array-state 1) do 
 
         (setf n (get-ij array-state i j) )
         
         (setf pq (where-is *goal* n) )
         (setf p (car pq) )
         (setf q (car (cdr pq)) )
         
         ;(setf sum (+ sum (abs (- p i)) (abs (- q j))) )
         ;(setf sum (+ sum (sqrt (+ (expt (- p i) 2) (expt (- q j) 2)))) )
         (setf sum (+ sum (+ (expt (- p i) 2) (expt (- q j) 2))) )
         

 )) 
  
 sum  ; # of out of palce
 
)
;; (start-over 'best-first 20 '((1 3 4)(8 0 5)(7 2 6)) '((1 2 3)(8 0 4)(7 6 5)))

;; Start
;; 1 3 4
;; 8   5
;; 7 2 6
;; 
;; Goal
;; 1 2 3
;; 8   4
;; 7 6 5



; example: 6 moves
; (start-over 'depth-first 6 '((2 8 3)(1 6 4)(7 0 5)) '((1 2 3)(8 0 4)(7 6 5)))
; regular - 5 moves closed: 7 open=7
; manhattan - 5 moves closed:6 open:6
; depth - 5 moves closed: 98 open:1
; breadth - 5 moves closed: 60 open: 41
; 3 - 5 60 41
; 


; example: 4 moves
; (start-over 'best-first 10 '((2 8 3)(1 0 4)(7 6 5)) '((1 2 3)(8 0 4)(7 6 5)))
; depth-first: 8 moves
; manhattan: 4 moves - length of closed = 5  length of open = 5

; regular-best: 4 moves - length of closed = 6 - length of open = 6


; example: 12 moves
;; (start-over 'best-first 20 '((1 2 3)(4 5 8)(6 7 0)) '((1 2 3)(4 5 6)(7 8 0)))
; depth-first (unable to solve) *** - Lisp stack overflow. RESET
; breadth-first (unable to solve) *** - Lisp stack overflow. RESET
; manhattan - 12 moves open:47 closed: 37
; regular - 12 mvoes closed: 116 open: 63
; sqrt - 12 moves 65 45
; +^2 : 12 - 55 46





(defun start-over (search-type   depth-limit   start   goal )
 
 ; start : '((2 8 3)(1 6 4)(7 0 5))
 ; goal  : '((1 2 3)(8 0 4)(7 6 5))
 


 (setf *N-row* 3)
 (setf *N-col* 3)
 (setf *start* start)
 (setf *goal*  goal)   
 
 (setf *open* nil)
 (setf *closed* nil)
 (setf *depth-limit* depth-limit)

 (setf *h-function* '8uzzle-heuristic-manhattan)
 ;(setf *h-function* '8uzzle-heuristic)
 
 (funcall search-type 'equal)


)


























