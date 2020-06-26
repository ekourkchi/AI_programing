; This code is commented by Ehsan Kourkchi
; to practice some lisp
; October 8 2015
;
; Based on the puzzle introduced here:
; http://www.math.tamu.edu/~dallen/hollywood/diehard/diehard.htm
;
; To load this program in lisp:
; lisp > (load "ehsan20.water_jugs.v03.lisp")
;
; You need to have the file "search.lisp" in the same directory as this file. 
;
;  
; To run:
;   lisp > (search-type jug-A-capacity jug-B-capacity goal-gallon)
;   
;; ;; Example 1: lisp >  (start-over 'breadth-first 7 3 5)
;; ;; first node on open = ((0 0) NIL 0)
;; ;; first node on open = ((0 3) (0 0) 1)
;; ;; first node on open = ((7 0) (0 0) 1)
;; ;; first node on open = ((3 0) (0 3) 2)
;; ;; first node on open = ((7 3) (0 3) 2)
;; ;; first node on open = ((4 3) (7 0) 2)
;; ;; first node on open = ((7 3) (7 0) 2)
;; ;; first node on open = ((3 3) (3 0) 3)
;; ;; first node on open = ((4 0) (4 3) 3)
;; ;; first node on open = ((6 0) (3 3) 4)
;; ;; first node on open = ((1 3) (4 0) 4)
;; ;; first node on open = ((6 3) (6 0) 5)
;; ;; first node on open = ((1 0) (1 3) 5)
;; ;; first node on open = ((7 2) (6 3) 6)
;; ;; first node on open = ((0 1) (1 0) 6)
;; ;; first node on open = ((0 2) (7 2) 7)
;; ;; first node on open = ((7 1) (0 1) 7)
;; ;; first node on open = ((2 0) (0 2) 8)
;; ;; first node on open = ((5 3) (7 1) 8)
;; ;; 
;; ;; length of closed = 19
;; ;; length of open = 1
;; ;; 
;; ;; # of moves = 8
;; ;; solution path = ((0 0) (7 0) (4 3) (4 0) (1 3) (1 0) (0 1) (7 1) (5 3))
;; ;; T
;;
;; Example 2: lisp > (start-over 'depth-first 7 3 5)
;; ;; open: (((0 0) NIL 0))
;; ;; first node on open = ((0 0) NIL 0)
;; ;; first node on open = ((0 3) (0 0) 1)
;; ;; first node on open = ((3 0) (0 3) 2)
;; ;; first node on open = ((3 3) (3 0) 3)
;; ;; first node on open = ((6 0) (3 3) 4)
;; ;; first node on open = ((6 3) (6 0) 5)
;; ;; first node on open = ((7 2) (6 3) 6)
;; ;; first node on open = ((7 3) (7 2) 7)
;; ;; first node on open = ((7 0) (7 3) 8)
;; ;; first node on open = ((4 3) (7 0) 9)
;; ;; first node on open = ((4 0) (4 3) 10)
;; ;; first node on open = ((1 3) (4 0) 11)
;; ;; first node on open = ((1 0) (1 3) 12)
;; ;; first node on open = ((0 1) (1 0) 13)
;; ;; first node on open = ((7 1) (0 1) 14)
;; ;; first node on open = ((5 3) (7 1) 15)
;; ;; 
;; ;; length of closed = 16
;; ;; length of open = 8
;; ;; 
;; ;; # of moves = 15
;; ;; solution path = ((0 0) (0 3) (3 0) (3 3) (6 0) (6 3) (7 2) (7 3) (7 0) (4 3) (4 0) (1 3) (1 0) (0 1) (7 1) (5 3))
;; ;; T



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



(defun water-jugs-heuristic (state level)
   
  (setf aa (in-A state))
  (setf bb (in-B state))
  
  (setf sum (+ aa bb))
  
  (cond
     ((or (eq aa *goal*)(eq bb *goal*)) 0)
     ((< sum *goal*) 2)
     ((>= sum *goal*) 1)
     
  )
  
 
 
)





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

;; 	     (if (or (equal *depth-limit* nil) (<= (node-level current-node) *depth-limit*))





























