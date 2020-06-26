; This code is written by Ehsan Kourkchi
; To do the Assignment 2 ---  ICS361
; October 8 2015
;
; Based on the puzzle introduced here:
; http://www.mathsisfun.com/puzzles/farmer-crosses-river.html
;
; To load this program in lisp:
; lisp > (load "ehsan20.farmer_goat.v02.lisp")
;
; You need to have the file "search.lisp" in the same directory as this file. 
;
;  
; To run:
;   lisp> (start-over 'depth-first)
; Depth-First results ....
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
;; ;; 
; Lisp > (start-over 'breadth-first)
; Breadth First results
;; ;; first node on open = ((1 1 1 1) NIL 0)
;; ;; first node on open = ((0 1 0 1) (1 1 1 1) 1)
;; ;; first node on open = ((1 1 0 1) (0 1 0 1) 2)
;; ;; first node on open = ((0 1 0 0) (1 1 0 1) 3)
;; ;; first node on open = ((0 0 0 1) (1 1 0 1) 3)
;; ;; first node on open = ((1 1 1 0) (0 1 0 0) 4)
;; ;; first node on open = ((1 0 1 1) (0 0 0 1) 4)
;; ;; first node on open = ((0 0 1 0) (1 1 1 0) 5)
;; ;; first node on open = ((0 0 1 0) (1 0 1 1) 5)
;; ;; first node on open = ((1 0 1 0) (0 0 1 0) 6)
;; ;; first node on open = ((1 0 1 0) (0 0 1 0) 6)
;; ;; first node on open = ((0 0 0 0) (1 0 1 0) 7)
;; ;; 
;; ;; length of closed = 12
;; ;; length of open = 1
;; ;; 
;; ;; # of moves = 7
;; ;; solution path = ((1 1 1 1) (0 1 0 1) (1 1 0 1) (0 0 0 1) (1 0 1 1) (0 0 1 0) (1 0 1 0) (0 0 0 0))
;; ;; T
;; ;; 
;; ;; 



; Loading the search algorithms, i.e. "breadth-first" and "depth-first"
(load "ehsan20.search.v02.lisp")

   


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


;; ********************
;; T E S T
;
(defun start-over (search-type)


 
 (setf *start* '(1 1 1 1))   ; setting the start state
 (setf *goal* '(0 0 0 0))  ; setting the goal state
 
 (setf *open* nil)
 (setf *closed* nil)
 (setf *depth-limit* nil)
 
 (funcall search-type  'equal) ; looking for the solution


)
;; ********************






























