; This code is written by Ehsan Kourkchi
; To do the Assignment 2 ---  ICS361
; October 8 2015



; To test this lode:
;
; 1) load it in lisp environment using the following command
; (load "ehsan20.search.lisp")
;
; 2) To run it, use "start" function as follows
; example > (start A C)
;; first node on open = ((A1 A2) NIL 0)
;; first node on open = ((B1 B2) (A1 A2) 1)
;; first node on open = ((E1 E2) (A1 A2) 1)
;; first node on open = ((C1 C2) (B1 B2) 2)
;; length of closed = 3
;; length of open = 2
;; solution path = ((A1 A2) (B1 B2) (C1 C2))
;; NIL
; 
; 3) How start works?
; start(starting-state goal-state)
;
; 4) *tree* is being used just to test this program.
;   
;                  A
;                /   \
;              B      E
;            / \      \
;           C   D      F
;              / \
;             G   H
;
;  To represent each node of the tree, each node is like following list
;  node == (child parent level)
;  "child" and "parent" are both valid state lists

;
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


(setf *open* ())
(setf *closed* ())
(setf *goal* ())
(setf *start* ())


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: nodeofstate
; tree-lst: a list of nodes, which define a tree
; state: a state which we are looking format
;
; output: it recursively search and returns the corresponding node of the input "state"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun nodeofstate (tree-lst state)

  (setf node nil)
 
  (if (equal tree-lst nil) 
      node
      
      (progn   ; else
          
          (setf node (car tree-lst))
          
           (if (equal  (car node) state)
              node
            (nodeofstate (cdr tree-lst) state) ; else
                
            )  ; endif   
               
      )  ; end-progn
      
    ) ; end-of-outer-if

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: stateofnode
; node: the node that we are interested in its state
; node == (state parent level)
;
; output: it returns the "state" of the node, i.e. the first member of the node-list
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun stateofnode (node)

  (car node)


)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: children-node
; tree-lst: a list of nodes, which define a tree
; node: the node that we are interested in its children
;
; output: A list of children of the input "node"
;
; example: (children-node *tree* A0)
; (((B1 B2) (A1 A2) 1) ((E1 E2) (A1 A2) 1))
;
; Function Dependencies:
; 1) children-state
; 2) children-recur
; 3) node-level
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun children-node (tree-lst node)
    
    (setf state (stateofnode node))  ; extracting the state of the node
    (setf level (node-level node))   ; extracting the level of a node
    
    (children-state tree-lst state level)

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: children-state
; tree-lst: a list of nodes, which define a tree
; state: the desired "state" in the search tree
; level: the level of the "state" in the tree
;
; output: It returns the children of a state in a list
;
; example: (children-state *tree* B 1)
;  (((C1 C2) (B1 B2) 2) ((D1 D2) (B1 B2) 2))
;
; Function Dependencies:
; 1) children-recur
; 2) node-level
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun children-state (tree-lst state level)
    
    (setf children-list nil)
    
    (cond 
       ((equal tree-lst nil) nil)  ; return "nil" if "tree-lst" is nil
       (T (children-recur tree-lst state level children-list)) 
       ; otherwise, start with the empty list of "children-list" and recursively fill it with children of the "state"
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
             
                (setf node (car tree-lst)) ; extracting the first node of the "tree-lst"
                
                ; "node" is the child of the "state" if its parent is the "state" and its level is
                ; one step deeper 
                ; if these conditions hold, add the found child to the "children-list"
                (if (and (eq (node-level node) (+ 1 level)) (equal (car(cdr node)) state)  )
                     (setf children-list (cons (car tree-lst) children-list))
                )  ; endif
               
                ; and
                
                ; continue the recursion
                (children-recur (cdr tree-lst) state level children-list)
            
      ) ; end-progn
        
   ) ; end-if
   
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: node-level
; node: the node that we are interested in its level
; 
; output: the level of the node
; node == (state parent level)

; example: (node-level G0)
;  3  <-- the level of the node 'G0'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun node-level (node)

  (car (last node))

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: state-parent
;
; tree-lst: a list of nodes, which define a tree
; state: the desired "state" in the search tree
; 
; output: the state-parent of the input "state"
; 
; How it works: 
; It recrsively checks all the states of all nodes in the "tree-lst" list
;
; example: (state-parent *tree* G)
; (D1 D2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun state-parent (tree-lst state)
  
  (setf parent nil)
  
  
  (if (equal tree-lst nil)  ; return nil is the tree-lst is nil
      parent  ; base-case
      
      (progn 
          
          (setf node (car tree-lst))
          
          (if (equal  (car node) state) ; if the node-state matches with the input "state"
              (car (cdr node))          ; return the second element of the node (the state parent)
              (state-parent (cdr tree-lst) state) ; else: recursively look at the next node in the "tree-lst"
                
          )  ; end-if   
                
      ) ; end-progn
      
  )  ; end-if
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: state-level
;
; tree-lst: a list of nodes, which define a tree
; state: the desired "state" in the search tree
; 
; output: the level of the input "state"
; 
; How it works: Exactly the same idea as "state-parent" function
; It recrsively checks all the states of all nodes in the "tree-lst" list
;
; example: (state-level *tree* G)
;  3  <-- the level of the state 'G'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun state-level (tree-lst state)

  (if (equal tree-lst nil)
      nil
  )

  
  (if (equal state nil)
      (setf level '-1)
  )
  
  (if (equal tree-lst nil)
      nil   ; base-case
      
      (progn 
          
          (setf node (car tree-lst))
          
          (if (equal  (car node) state)
              (node-level node)
              (state-level (cdr tree-lst) state)
          )  ; end-if   
                
      ) ; end-progn
      
  ) ; end-if

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: pop-open
;
; input: it changes the global variable *open*,
; which serves as the open-list
; 
; output: It removes the first element of the *open* list and returns it
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun pop-open ()

  (if (equal *open* nil)
     nil
  
     (progn    ; else
       (setf tmp (car *open*))
       (setf *open* (cdr *open*))
       tmp
     )  ; end-progn
      
  ) ; end-if

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: depth-first
;
; input: goal-function
; The name of the function that determines we've achienved our goal
; in most cases it is the 'equal function
; For Water-Jug problem, we needed to define the goal-function specifically
; 
; Function: It calls "depth-first-recur" and recursively looks for the desired goal
; based on the "goal-function"
; 
; Functione Dependencies:
; 1) depth-first-recur
; 2) nodeofstate
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun depth-first (goal-function)
   
   ; initializing the *open* list with the *start* state
   (setf *open* (cons (nodeofstate *tree* *start*) ()))
   
   (setf *closed* nil)
   
   ; running the recursion
   (depth-first-recur goal-function)

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: depth-first-recur
;
; input: goal-function
; The name of the function that determines we've achienved our goal
; 
; Function: It calls "depth-first-recur" and recursively looks for the desired goal
; based on the "goal-function"
; 
; Functione Dependencies:
; 1) children-node
; 2) solution-path
; 3) stateofnode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun depth-first-recur (goal-function)

   (setf current-node (pop-open))
   (format t "first node on open = ~S~%" current-node)
   (if (equal current-node nil)
     nil
   )
   
   ; testing if the goal is achienved based on the "goal-function"
   (if (funcall goal-function (stateofnode current-node) *goal*)
       
       ;then - the goal is achienved
       ; print the results, including the "solution path"
       (progn
         (format t "length of closed = ~S~%" (list-length *closed*))
         (format t "length of open = ~S~%" (list-length *open*))
         (format t "solution path = ~S~%" (solution-path current-node))
         
       ) ; end-then
    
       ; else - 
       ; we are done with the current node - add it to the *closed" list
       ; add te children of the current node to the BEGINNING of the *open* list and 
       ; recursively continue the process
       (progn
         (setf *closed* (cons current-node *closed*))
         (setf *open* (append  (children-node *tree* current-node) *open*))
         (depth-first-recur goal-function)
       ) ; end-else
   
   ) ; end-if

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; function name 1: breadth-first
;; function name 2: breadth-first-recur
; these two functios are exaclty the same as "depth-first" and "depth-first-recur"
; except the order of adding the children to the *open* list
;
; The only different is commented out ...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun breadth-first (goal-function)
   
   (setf *open* (cons (nodeofstate *tree* *start*) ()))
   
   (setf *closed* nil)
   
   (breadth-first-recur goal-function)


)


(defun breadth-first-recur (goal-function)

   (setf current-node (pop-open))
   (format t "first node on open = ~S~%" current-node)
   (if (equal current-node nil)
     nil
   )
    
   (if (funcall goal-function (stateofnode current-node) *goal*)
       
       ; then
       (progn
         (format t "length of closed = ~S~%" (list-length *closed*))
         (format t "length of open = ~S~%" (list-length *open*))
         (format t "solution path = ~S~%" (solution-path current-node))
         
       )
       
       ; else - 
       ; we are done with the current node - add it to the *closed" list
       ; add te children of the current node to the END of the *open* list and 
       ; recursively continue the process
       (progn
         (setf *closed* (cons current-node *closed*))
         (setf *open* (append *open* (children-node *tree* current-node) ))
         (breadth-first-recur goal-function)
       )
   
   ) ; end-if

     
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function name: solution-path
;
; input: goal-node
; The found node which holds the desired goal-state.
; 
; Output: A list of all states that begins with the *start* state and ends with *goal*
; 
; Functione Dependencies:
; 1) path-recur
; 2) stateofnode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun solution-path (goal-node)

   (setf sol-path nil)
   (setf state (stateofnode goal-node))
   (path-recur sol-path state)
)

;;;
; function name: path-recur
;  
; Input: sol-path --> the list of solution path
; state: an "state" in the chain of the solution path
;  
; How: add the "state" in to the "sol-path" list
; and recursively continue with its parent, while passing the "sol-path" list
; this way "sol-path" grows including the chain of states from *start* to *goal*
;;; 
(defun path-recur (sol-path state)
    

    (if (equal state *start*)
        (setf sol-path (cons state sol-path))
        (progn
        (setf sol-path (cons state sol-path))
        (path-recur sol-path (state-parent *tree* state)
        )
    
    )
    )

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
    
 
;; ********************
;; T E S T
;;
;; Example:
;; ;; lisp > (start A G)
;; ;; first node on open = ((A1 A2) NIL 0)
;; ;; first node on open = ((B1 B2) (A1 A2) 1)
;; ;; first node on open = ((E1 E2) (A1 A2) 1)
;; ;; first node on open = ((C1 C2) (B1 B2) 2)
;; ;; first node on open = ((D1 D2) (B1 B2) 2)
;; ;; first node on open = ((F1 F2) (E1 E2) 2)
;; ;; first node on open = ((G1 G2) (D1 D2) 3)
;; ;; length of closed = 6
;; ;; length of open = 1
;; ;; solution path = ((A1 A2) (B1 B2) (D1 D2) (G1 G2))
;; ;; NIL
;; 
;; ********************

(defun start (start goal)
   (setf *start* start)
   (setf *goal* goal)
   (breadth-first 'equal)
)
;; ********************

    
    
    
    
   