;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This code is written by Ehsan Kourkchi
; To do the Assignment 3 ---  ICS361
; Computer Science, University of Hawaii
; October 15 2015
; Email: ekourkchi@gmail.com
;
; Based on the puzzle introduced here:
; http://www.math.tamu.edu/~dallen/hollywood/diehard/diehard.htm
;
; To load this program in lisp:
; lisp > (load "ehsan20.water_jugs.v03.lisp")
;
; You need to have the file "ehsan20.search.v03.lisp" in the same directory as this file. 
; Note: In the following the heuristic function has been defined specifically for this game: water-jugs-heuristic
;  
; To run:
;   lisp > (search-type jug-A-capacity jug-B-capacity goal-gallon)
;   
;; ;; Example 1: lisp >  (start-over 'breadth-first 11 7 1)
;; ;; first node on open = ((0 0) NIL 0 2)
;; ;; first node on open = ((0 7) (0 0) 1 2)
;; ;; first node on open = ((11 0) (0 0) 1 2)
;; ;; first node on open = ((7 0) (0 7) 2 3)
;; ;; first node on open = ((11 7) (0 7) 2 3)
;; ;; first node on open = ((4 7) (11 0) 2 3)
;; ;; first node on open = ((11 7) (11 0) 2 3)
;; ;; first node on open = ((7 7) (7 0) 3 4)
;; ;; first node on open = ((4 0) (4 7) 3 4)
;; ;; first node on open = ((11 3) (7 7) 4 5)
;; ;; first node on open = ((0 4) (4 0) 4 5)
;; ;; first node on open = ((0 3) (11 3) 5 6)
;; ;; first node on open = ((11 4) (0 4) 5 6)
;; ;; first node on open = ((3 0) (0 3) 6 7)
;; ;; first node on open = ((8 7) (11 4) 6 7)
;; ;; first node on open = ((3 7) (3 0) 7 8)
;; ;; first node on open = ((8 0) (8 7) 7 8)
;; ;; first node on open = ((10 0) (3 7) 8 9)
;; ;; first node on open = ((1 7) (8 0) 8 8)
;; ;; 
;; ;; length of closed = 19
;; ;; length of open = 1
;; ;; 
;; ;; # of moves = 8
;; ;; solution path = ((0 0) (11 0) (4 7) (4 0) (0 4) (11 4) (8 7) (8 0) (1 7))
;; ;; T
;
;;
;; Example 2: lisp > (start-over 'depth-first 11 7 1)
;; ;; first node on open = ((0 0) NIL 0 2)
;; ;; first node on open = ((0 7) (0 0) 1 2)
;; ;; first node on open = ((7 0) (0 7) 2 3)
;; ;; first node on open = ((7 7) (7 0) 3 4)
;; ;; first node on open = ((11 3) (7 7) 4 5)
;; ;; first node on open = ((11 7) (11 3) 5 6)
;; ;; first node on open = ((11 0) (11 7) 6 7)
;; ;; first node on open = ((4 7) (11 0) 7 8)
;; ;; first node on open = ((4 0) (4 7) 8 9)
;; ;; first node on open = ((0 4) (4 0) 9 10)
;; ;; first node on open = ((11 4) (0 4) 10 11)
;; ;; first node on open = ((8 7) (11 4) 11 12)
;; ;; first node on open = ((8 0) (8 7) 12 13)
;; ;; first node on open = ((1 7) (8 0) 13 13)
;; ;; 
;; ;; length of closed = 14
;; ;; length of open = 6
;; ;; 
;; ;; # of moves = 13
;; ;; solution path = ((0 0) (0 7) (7 0) (7 7) (11 3) (11 7) (11 0) (4 7) (4 0) (0 4) (11 4) (8 7) (8 0) (1 7))
;; ;; T
;
;; Example 3: lisp > (start-over 'best-first 11 7 1)
;; ;; first node on open = ((0 0) NIL 0 2)
;; ;; first node on open = ((11 0) (0 0) 1 2)
;; ;; first node on open = ((0 7) (0 0) 1 2)
;; ;; first node on open = ((11 7) (0 7) 2 3)
;; ;; first node on open = ((7 0) (0 7) 2 3)
;; ;; first node on open = ((11 7) (11 0) 2 3)
;; ;; first node on open = ((4 7) (11 0) 2 3)
;; ;; first node on open = ((4 0) (4 7) 3 4)
;; ;; first node on open = ((7 7) (7 0) 3 4)
;; ;; first node on open = ((11 3) (7 7) 4 5)
;; ;; first node on open = ((0 4) (4 0) 4 5)
;; ;; first node on open = ((11 4) (0 4) 5 6)
;; ;; first node on open = ((0 3) (11 3) 5 6)
;; ;; first node on open = ((3 0) (0 3) 6 7)
;; ;; first node on open = ((8 7) (11 4) 6 7)
;; ;; first node on open = ((8 0) (8 7) 7 8)
;; ;; first node on open = ((1 7) (8 0) 8 8)
;; ;; 
;; ;; length of closed = 17
;; ;; length of open = 1
;; ;; 
;; ;; # of moves = 8
;; ;; solution path = ((0 0) (11 0) (4 7) (4 0) (0 4) (11 4) (8 7) (8 0) (1 7))
;; ;; T
;
;
;  As seen depth-first search reaches the solution faster (14 states in the closed list were checked), however it's not the optimum one, i.e. 13 moves
;  breadth-first search gives the optimum solution (8 moves), by checking 19 states, stored in the *closed* list
; best first search also find the optimum solution, by checking 17 states, that is better than breadth-first search




; Loading the search algorithms, i.e. "breadth-first" and "depth-first"
(load "ehsan20.search.v03.lisp")

   
; the list of all possible moves
; for each move, we define a function below
(setf  *moves* '(empty-A empty-B fill-A fill-B A-to-B B-to-A))



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


; This is heuristic function specifically used for this problem
;
; sum: is the total water in both jugs
; if sum < *goal* then we are at least two moves away ... 1) filling in one jug  2) transferring water from one to another
; if sum >=*goal* then we are at least one move away ...  1) transferring water from one to another
; if at least one of these jugs contains exactly the same amount water as needed, then we've achieved the goal 
; and we are no moves away from the solution
(defun water-jugs-heuristic (state level)
   
  (setf aa (in-A state))
  (setf bb (in-B state))
  
  (setf sum (+ aa bb))
  
  (cond
     ((or (eq aa *goal*)(eq bb *goal*)) 0)
     ((< sum *goal*) 2)
     ((>= sum *goal*) 1)
     
  ) ; end-cond
  
 
)




; To play the water-jug problem
; search-type is either 'breadth-first' or 'depth-first' or 'best-first'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun start-over (search-type jug-A-capacity jug-B-capacity goal-gallon)
 


 
 (setf *CA* jug-A-capacity)
 (setf *CB* jug-B-capacity)
 
 (setf *start* '(0 0))
 (setf *goal* goal-gallon)
 
 (setf *open* nil)
 (setf *closed* nil)
 (setf *depth-limit* nil)
 
 (setf *h-function* 'water-jugs-heuristic)
 
 
 (funcall search-type 'my-final-goal) ; The function "my-final-goal" is used ... 


)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






























