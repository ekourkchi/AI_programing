;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This code is written by Ehsan Kourkchi
; To do the Assignment 3 ---  ICS361
; Computer Science, University of Hawaii
; October 15 2015
; Email: ekourkchi@gmail.com
;
;
; 1) To load this program in lisp:
; lisp > (load "ehsan20.test.search.v03.lisp")
;
;
; 2) *tree* is being used just to test this program.
;   
;                 A
;               /   \
;              B     E
;            /  \     \
;           C    D     F
;              /  \
;             G    H
;
;  To represent each node of the tree, each node is in the form of
;  node == (child parent level)
;  "child" and "parent" are both valid state lists
;
; NOTE: The nodes are in the form of: (State Parent-state level priority)
; priority is only used in the bset-first search algortihm, 
; for the other searches it's the same as the level
;
; 3) To run this code, 
;
; breadth-first example > (breadth A F)
;; ;; first node on open = ((A1 A2) NIL 0 0)
;; ;; first node on open = ((B1 B2) (A1 A2) 1 1)
;; ;; first node on open = ((E1 E2) (A1 A2) 1 1)
;; ;; first node on open = ((C1 C2) (B1 B2) 2 2)
;; ;; first node on open = ((D1 D2) (B1 B2) 2 2)
;; ;; first node on open = ((F1 F2) (E1 E2) 2 2)
;; ;; 
;; ;; length of closed = 6
;; ;; length of open = 2
;; ;; 
;; ;; # of moves = 2
;; ;; solution path = ((A1 A2) (E1 E2) (F1 F2))
;; ;; T
;
;
; depth-first example > (depth A F)
;; ;; first node on open = ((A1 A2) NIL 0 0)
;; ;; first node on open = ((B1 B2) (A1 A2) 1 1)
;; ;; first node on open = ((C1 C2) (B1 B2) 2 2)
;; ;; first node on open = ((D1 D2) (B1 B2) 2 2)
;; ;; first node on open = ((G1 G2) (D1 D2) 3 3)
;; ;; first node on open = ((H1 H2) (D1 D2) 3 3)
;; ;; first node on open = ((E1 E2) (A1 A2) 1 1)
;; ;; first node on open = ((F1 F2) (E1 E2) 2 2)
;; ;; 
;; ;; length of closed = 8
;; ;; length of open = 0
;; ;; 
;; ;; # of moves = 2
;; ;; solution path = ((A1 A2) (E1 E2) (F1 F2))
;; ;; T
;
; best-first example > (best A F)
;; ;; first node on open = ((A1 A2) NIL 0 0)
;; ;; first node on open = ((E1 E2) (A1 A2) 1 1)
;; ;; first node on open = ((B1 B2) (A1 A2) 1 1)
;; ;; first node on open = ((D1 D2) (B1 B2) 2 2)
;; ;; first node on open = ((C1 C2) (B1 B2) 2 2)
;; ;; first node on open = ((F1 F2) (E1 E2) 2 2)
;; ;; 
;; ;; length of closed = 6
;; ;; length of open = 2
;; ;; 
;; ;; # of moves = 2
;; ;; solution path = ((A1 A2) (E1 E2) (F1 F2))
;; ;; T
;
; NOTE: this code would be loaded in the other codes to use its searching functions
; i.e. "breadth-first" and "depth-first"
; For more thorough documentation, look at the "start" function, and also the comments of each function.
;
; 
;
; List of states
(setf  A '(a1 a2))
(setf  B '(b1 b2))
(setf  C '(c1 c2))
(setf  D '(d1 d2))
(setf  E '(e1 e2))
(setf  F '(f1 f2))
(setf  G '(g1 g2))
(setf  H '(h1 h2))


; list of nodes
(setf A0 (cons A (cons nil (list '0))))
(setf B0 (cons B (cons A (list '1))))
(setf C0 (cons C (cons B (list '2))))
(setf D0 (cons D (cons B (list '2))))
(setf G0 (cons G (cons D (list '3))))
(setf H0 (cons H (cons D (list '3))))
(setf E0 (cons E (cons A (list '1))))
(setf F0 (cons F (cons E (list '2))))

; Storing the tree in a list 
(setf *tree* (cons A0 ()))
(setf *tree* (cons B0 *tree*))
(setf *tree* (cons C0 *tree*))
(setf *tree* (cons D0 *tree*))
(setf *tree* (cons E0 *tree*))
(setf *tree* (cons F0 *tree*))
(setf *tree* (cons G0 *tree*))
(setf *tree* (cons H0 *tree*))

;  This is how tree looks like:
;  (((H1 H2) (D1 D2) 3) ((G1 G2) (D1 D2) 3) ((F1 F2) (E1 E2) 2) ((E1 E2) (A1 A2) 1) ((D1 D2) (B1 B2) 2) ((C1 C2) (B1 B2) 2) ((B1 B2) (A1 A2) 1)
; ((A1 A2) NIL 0))



; Loading the search algorithms, i.e. "breadth-first" and "depth-first"
(load "ehsan20.search.v03.lisp")

; returns a lsit of nodes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun children-of-state (state level)
    
    
    (cond 
       ((or (equal state nil) (and (not (equal *depth-limit* nil)) (= level *depth-limit*))) nil)
       (T (children-recur *tree* state level nil)) 
       
    )
   

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: children-recur
;
; tree-lst: a list of nodes, which define a tree
; state: the desired "state" in the search tree
; level: the level of the "state" in the tree
; children-list: the input list of children

; output: "children-list" which is filled with all children of the "state"
;
; How it works: It looks at the first node in the "tree-lst"
; 1) if it is the child of the "state", then it is added to the "children-list"
; 2) The same process is recursively done for the rest of the "tree-lst", passing the current "children-list"
; 3) As recursion continues, the "children-list" grows bigger, 
;    until there is nothing left in "tree-lst" without inspection
; 
; Function Dependencies:
; 1) node-level
;
; Example: (children-recur *tree* D 2 '())
; These are the children of the state 'D' at the level of 2
; The input list is empty --> i.e. '()
;  (((G1 G2) (D1 D2) 3) ((H1 H2) (D1 D2) 3))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun children-recur (tree-lst state level children-list)

   (if (equal tree-lst nil) 
      children-list  ; base-case
      
      (progn ; else
             
                ;(setf node (append (car tree-lst) (f-function child (+ 1 level))) ) ; extracting the first node of the "tree-lst"
                (setf node  (car tree-lst)  )
                ; "node" is the child of the "state" if its parent is the "state" and its level is
                ; one step deeper 
                ; if these conditions hold, add the found child to the "children-list"
                (if (and (eq (node-level node) (+ 1 level)) (equal (parent-of node) state)  (not (ismember (parent-of node) *closed*)) )
                     (setf children-list (cons (append node (list(f-function (stateofnode node) (node-level node)))) children-list))
                )  ; endif
               
                ; and
                
                ; continue the recursion
                (children-recur (cdr tree-lst) state level children-list)
            
      ) ; end-progn
        
   ) ; end-if
   
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; testing breadth-first search
(defun breadth (start goal)
   (setf *start* start)
   (setf *goal* goal)
   (setf *open* nil)
   (setf *closed* nil)
   (setf *depth-limit* nil)
   (breadth-first 'equal)
)

; testing depth-first search
(defun depth (start goal)
   (setf *start* start)
   (setf *goal* goal)
   (setf *open* nil)
   (setf *closed* nil)
   (setf *depth-limit* nil)
   (depth-first 'equal)
)



; testing best-first search
(defun best (start goal)
   (setf *start* start)
   (setf *goal* goal)
   (setf *open* nil)
   (setf *closed* nil)
   (setf *depth-limit* nil)
   (best-first 'equal)
)
;; ********************
    
    



