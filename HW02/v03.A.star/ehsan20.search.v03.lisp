; This code is written by Ehsan Kourkchi
; To do the Assignment 2 ---  ICS361
; October 8 2015



; To test this lode:
;
; 1) load it in lisp environment using the following command
; (load "ehsan20.search.v03.lisp")
;
;
; 3) How start works?
; start(starting-state goal-state)



(setf *open* nil)
(setf *closed* nil)
(setf *goal* nil)
(setf *start* nil)
(setf *depth-limit* nil)
(setf *f-function* 'f-function)
(setf *g-function* 'g-function)
(setf *h-function* 'h-function)
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
; function name: children-of-node
; tree-lst: a list of nodes, which define a tree
; node: the node that we are interested in its children
;
; output: A list of children of the input "node"
;
; example: (children-of-node *tree* A0)
; (((B1 B2) (A1 A2) 1) ((E1 E2) (A1 A2) 1))
;
; Function Dependencies:
; 1) children-state
; 2) children-recur
; 3) node-level
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun children-of-node (node)
    
    (setf state (stateofnode node))  ; extracting the state of the node
    (setf level (node-level node))   ; extracting the level of a node
    
    (children-of-state state level)

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun parent-of (node)

  (car(cdr node))

)




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

  (car (cdr (cdr node)))

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun node-priority (node)

  (car (cdr (cdr (cdr node))))

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
(defun is-discovered (closed state)
  
  
  
  
  (if (equal closed nil)  ; return nil is the closed is nil
      nil  ; base-case
      
      (progn 
          
          (setf node (car closed))
          
          (if (equal  (car node) state) ; if the node-state matches with the input "state"
              T          ; return T (yes, it's discovered)
              (is-discovered (cdr closed) state) ; else: recursively look at the next node in the "tree-lst"
                
          )  ; end-if   
                
      ) ; end-progn
      
  )  ; end-if
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
   (setf *open* (list (list  *start* nil 0 (funcall *f-function* *start* 0))))
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
   
   
   (if (equal current-node nil)
      
      ; then
      (progn 
       (format t "~% Could not reach the goal: ~S~%" *goal*)
       (format t " Depth limit: ~S~%" *depth-limit*)
       
       (format t "~% ********************~%")
       (format t  " either, this puzzle does not have a solution ~%")
       (format t  " or, you need to increase the depth limit ~%~%")

       
       nil
        
      )
      
      ; else
      (progn
	(format t "first node on open = ~S~%" current-node)
	
	
	(setf *closed* (cons current-node *closed*))
	
	; testing if the goal is achienved based on the "goal-function"
	(if (funcall goal-function (stateofnode current-node) *goal*)
	    
	    ;then - the goal is achienved
	    ; print the results, including the "solution path"
	    (progn
	      (format t "~%length of closed = ~S~%" (list-length *closed*))
	      (format t "length of open = ~S~%" (list-length *open*))
	      (setf solution-list (solution-path current-node))
	      (format t "~%# of moves = ~S~%" (- (list-length solution-list) 1))
	      (format t "solution path = ~S~%" solution-list)
	      T
	    ) ; end-then
	  
	    ; else - 
	    ; we are done with the current node - add it to the *closed" list
	    ; add te children of the current node to the BEGINNING of the *open* list and 
	    ; recursively continue the process
	    (progn
	         
	      (setf *open* (append  (children-of-node current-node) *open*))
	      
	      (depth-first-recur goal-function)
	    ) ; end-else
	
	) ; end-if
      ) ; end-progn
   ) ; end-if

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun h-function (state level)
   
    0
   ;(random 10) 
 
)


(defun g-function (state level)
   
   level
 
)



(defun f-function (state level)
   
   (if (equal state nil)
      nil
      (progn
        (setf g-value (funcall *g-function* state level))
        (setf f-value (+ g-value (funcall *h-function* state level)))
      )
   )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun pop-open-priority ()

  (if (equal *open* nil)
     ; then
     nil  
     ; else
     
     (progn
       
       (setf best-node (car *open*))
       (setf open-copy (cdr *open*))
       (setf *open* nil)
       (setf best-node (pop-open-priority-recur open-copy best-node))  ; The fist element is the best, at first
       (setf *open* (reverse *open*))
       best-node
     )

  ) ; end-if

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun pop-open-priority-recur (list-node best-node)

  (if (equal list-node nil)
     best-node
  
     (progn    ; else
       
       (setf best-priority (node-priority best-node))
       (setf current-node (car list-node))
       (if (< (node-priority current-node) best-priority)
          
          (progn  ; then
            (setf *open* (cons best-node *open*)) ; it's no loner the best, back to the *open* list
            (pop-open-priority-recur (cdr list-node) current-node) 
          )
          
          (progn  ; else
            (setf *open* (cons current-node *open* )) ; it's no loner the best, back to the *open* list
            (pop-open-priority-recur (cdr list-node) best-node)     
          )
       )
       
       
       
       
     )  ; end-progn
      
  ) ; end-if

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun priority-append-open-recur (node head tail)
  
  (if (equal node nil)
     nil
     
     (progn
     
       (if (equal tail nil)
          
          (setf *open* (append head (list node)))
              
          (progn 
                 
             (if (< (node-priority (car tail)) (node-priority node))
                
                (progn 
                (setf head (append head (list (car tail))))
                (priority-append-open-recur node head (cdr tail))
                )
                
                (progn
                (setf head (append head (list node)))
                (setf *open* (append head tail))
                )
             )
       
          )
       )
     )
   
  )

)



(defun priority-append-open (list-node)
  
  (if (equal list-node nil)
     nil
     
     (progn
       
       (setf head nil)
       (setf tail *open*)
       (priority-append-open-recur (car list-node) head tail)
       
       (priority-append-open (cdr list-node))
     
     
     )
   
   )

)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun best-first (goal-function)
   
   (setf *open* (list (list  *start* nil 0 (funcall *f-function* *start* 0))))
   (setf *closed* nil)
   
   (best-first-recur goal-function)


)


(defun best-first-recur (goal-function)
   
   
   ;(setf current-node (pop-open-priority))
   (setf current-node (pop-open))
   
   
   (if (equal current-node nil)
      
      ; then
      (progn 
       (format t "~% Could not reach the goal: ~S~%" *goal*)
       (format t " Depth limit: ~S~%" *depth-limit*)
       
       (format t "~% ********************~%")
       (format t  " either, this puzzle does not have a solution ~%")
       (format t  " or, you need to increase the depth limit ~%~%")
       nil
        
      )
      
      ; else
      (progn
	(format t "first node on open = ~S~%" current-node)
	
	
	(setf *closed* (cons current-node *closed*))
	
	; testing if the goal is achienved based on the "goal-function"
	(if (funcall goal-function (stateofnode current-node) *goal*)
	    
	    ;then - the goal is achienved
	    ; print the results, including the "solution path"
	    (progn
	      (format t "~%length of closed = ~S~%" (list-length *closed*))
	      (format t "length of open = ~S~%" (list-length *open*))
	      (setf solution-list (solution-path current-node))
	      (format t "~%# of moves = ~S~%" (- (list-length solution-list) 1))
	      (format t "solution path = ~S~%" solution-list)
	      T
	    ) ; end-then
	  
	  
	    ; else - 
	    ; we are done with the current node - add it to the *closed" list
	    ; add te children of the current node to the END of the *open* list and 
	    ; recursively continue the process
	    (progn
	      
	      ;(setf *open* (append *open* (children-of-node current-node) ))
	      (priority-append-open (children-of-node current-node))
	      
	      (best-first-recur goal-function)
	    ) ; end-else
	
	) ; end-if
      ) ; end-progn
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
   
   (setf *open* (list (list  *start* nil 0 (funcall *f-function* *start* 0))))
   (setf *closed* nil)
   
   (breadth-first-recur goal-function)


)


(defun breadth-first-recur (goal-function)

   (setf current-node (pop-open))
   
   
   
   (if (equal current-node nil)
      
      ; then
      (progn 
       (format t "~% Could not reach the goal: ~S~%" *goal*)
       (format t " Depth limit: ~S~%" *depth-limit*)
       
       (format t "~% ********************~%")
       (format t  " either, this puzzle does not have a solution ~%")
       (format t  " or, you need to increase the depth limit ~%~%")
       nil
        
      )
      
      ; else
      (progn
	(format t "first node on open = ~S~%" current-node)
	
	
	(setf *closed* (cons current-node *closed*))
	
	; testing if the goal is achienved based on the "goal-function"
	(if (funcall goal-function (stateofnode current-node) *goal*)
	    
	    ;then - the goal is achienved
	    ; print the results, including the "solution path"
	    (progn
	      (format t "~%length of closed = ~S~%" (list-length *closed*))
	      (format t "length of open = ~S~%" (list-length *open*))
	      (setf solution-list (solution-path current-node))
	      (format t "~%# of moves = ~S~%" (- (list-length solution-list) 1))
	      (format t "solution path = ~S~%" solution-list)
	      T
	    ) ; end-then
	  
	  
	    ; else - 
	    ; we are done with the current node - add it to the *closed" list
	    ; add te children of the current node to the END of the *open* list and 
	    ; recursively continue the process
	    (progn
	      
	      (setf *open* (append *open* (children-of-node current-node) ))
	      
	      (breadth-first-recur goal-function)
	    ) ; end-else
	
	) ; end-if
      ) ; end-progn
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
          (path-recur sol-path (state-parent *closed* state))
    
        ) ; end-progn
    ) ; end-if

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 

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
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; "make-new-state" tests if the "state" can be transformed to a new state 
; We always keep track of the level of a state in the search tree
; All the already discovered states are stored in the global list *closed*
; If the new state is already in this list, it would be ignored and nil would be returned

(defun make-new-state (move state)
   
   (setf new-state (funcall move state))
   
   
   (if (not (is-discovered *closed* new-state))
       
       ; then - the state is newly discovered
       (progn
       new-state
       )
       ; else
       nil ; already in the *closed* list
   ) ; end-if

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; returns a lsit of nodes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun children-of-state (state level)
    
    
    (cond 
       ((or (equal state nil) (and (not (equal *depth-limit* nil)) (= level *depth-limit*))) nil)
       (T (children-recur *moves* state level nil)) 
       
    )
   

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun children-recur (move state level children-list)

   (if (or (equal move nil)(equal state nil))
      children-list  ; base-case
      
      (progn ; else
                
                (setf child (make-new-state (car move) state))
                
                
                (if (not (equal child nil))
                 (progn
                     (setf node (list  child state (+ 1 level) (funcall *f-function* child (+ 1 level))))
                     (setf children-list (cons node children-list))
                  )
                )  ; endif
               
                ; and
                
                ; continue the recursion
                (children-recur (cdr move) state level children-list)
            
      ) ; end-progn
        
   ) ; end-if
   
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
