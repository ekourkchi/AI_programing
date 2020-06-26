;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ; This code is written by Ehsan Kourkchi
;; ; To do the Assignment 6 ---  ICS361
;; ; Computer Science, University of Hawaii
;; ; December 2015
;; ; Email: ekourkchi@gmail.com
;; ;
;; ; To load this program in lisp:
;; ; lisp > (load "ehsan20.HW06.C.lisp")
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




; This function returns the number elements in the list 'balls'
; Example: 
;    (n_elements '(red white black) 0)
;    3

(defun n_elements (balls num)

   (if (equal balls nil)  
      
      num  ; then base-case
      
      (n_elements (cdr balls) (+ 1 num)) ; else
    
   )  ; end-if
 
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; It adds "item" to the beginning of the lists in "list-item" and returns the new-list
;;
;; Example: (list-cons 'item '((apple) (orange)))
;;          ((ITEM ORANGE) (ITEM APPLE))
;; Dependency: 
;;    This uses the recursive function list-cons-recur

(defun list-cons (item list-item)
   
   (cond
      ((null list-item) nil)
      (T (list-cons-recur item list-item nil))
   )
)


; 
(defun list-cons-recur (item list-item new-list)
   
   (if (null list-item)
        
      new-list  ; then 
   
      (progn    ; else
       
        (setf A (car list-item))
        (setf A-new (cons item A))   ; adding 'item' to the beginning of the lists
   
        (setf new-list (cons A-new new-list))   ; adding the new list (A-new) to 'new-list'
        (setf out (list-cons-recur item (cdr list-item) new-list))
   
        out
      ) ; end-else
   
   ) ; end-if
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; permute-color(b w r g)
; Recursively creates all permutations of the given number colors
; b: # of black balls
; w: # of white balls
; r: # of red balls
; g: # of green balls
;
; This is the basic approach to produce all valid permutations:
; 0) all permutations of a list L is:
;     1) remove one element from the list L and call the new list Lp, call the removed element P
;     2) find all permutations of Lp --> recursively go to (0) 
;     3) add the element P at the beginning of all Lp permutations
;     4) go back to (1) and repeat the process for another element
;
; Here, the only difference is that we remove each colors, as opposed to individual elements
; This is because, removing the balls with the same color in the step (1) above, results in the same permutations, 
;   (basically, all balls with the same color are the same), and we are not interested in similar permutations.
;
;  Example: (permute-color 1 1 1 1)   --> It returns a list of all permutations for (Black White Red Green)
;  
;;  ((BLACK GREEN WHITE RED) (BLACK GREEN RED WHITE) (BLACK RED WHITE GREEN) (BLACK RED GREEN WHITE) (BLACK WHITE RED GREEN) (BLACK WHITE GREEN RED)
;;  (WHITE GREEN BLACK RED) (WHITE GREEN RED BLACK) (WHITE RED BLACK GREEN) (WHITE RED GREEN BLACK) (WHITE BLACK RED GREEN) (WHITE BLACK GREEN RED)
;;  (RED GREEN BLACK WHITE) (RED GREEN WHITE BLACK) (RED WHITE BLACK GREEN) (RED WHITE GREEN BLACK) (RED BLACK WHITE GREEN) (RED BLACK GREEN WHITE)
;;  (GREEN RED BLACK WHITE) (GREEN RED WHITE BLACK) (GREEN WHITE BLACK RED) (GREEN WHITE RED BLACK) (GREEN BLACK WHITE RED) (GREEN BLACK RED WHITE))
;  
;  number of permutations: 4! = 24
(defun permute-color (b w r g)
       

   
   (if (= 1  (+ (+ (+ b w) r) g))
   
   (cond           ; then base-case

     ((< b 0) nil)
     ((< w 0) nil)
     ((< r 0) nil)
     ((< g 0) nil)
     ((= b 1) '((black)))
     ((= w 1) '((white)))
     ((= r 1) '((red)))
     ((= g 1) '((green)))
   
   )
   
   
   (cond            ; else
   
       ((< b 0) nil)
       ((< w 0) nil)
       ((< r 0) nil)
       ((< g 0) nil)
       ((= 0  (+ (+ (+ b w) r) g)) nil)
       (T (append 
            (list-cons 'black (permute-color (- b 1) w  r g)) 
            (list-cons 'white (permute-color b (- w 1)  r g))
            (list-cons 'red (permute-color b w (- r 1)  g))
            (list-cons 'green (permute-color b w r (- g 1) ))
       )) 
   
  
   ) ; end-else
   
   
   ) ; end-if
    
   
) ; end-function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Recursively finds the item in the list 'state' at index=index
; index is 0-based, i.e. starts from 0
; n is set to 0 when start calling the function 
; Example: (what-is-recur '(e q f s f) 3 0)
;          S
(defun what-is-recur (state index n)
   
   (cond 
      ((= index n) (car state))
      (T (what-is-recur (cdr state) index (+ n 1)))
   )

)  


; This is the interface function to the previous recursive function
; Index starts from 1
;
; Example: (what-is '(e q f s f) 2)
; Q
(defun what-is (state index)
  
  (what-is-recur state (- index 1) 0)
  
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   C O N D I T I O N S   
;;   C O N D I T I O N S   
;;   C O N D I T I O N S   
;;   C O N D I T I O N S   
;; -------------------------------------------------------------------------   
;;     You have eight colored balls: 1 black, 2 white, 2 red and 3 green.
;; -------------------------------------------------------------------------
;;     Cond 1: The balls in positions 2 and 3 are not green.
;;     Cond 2: The balls in positions 4 and 8 are the same color.
;;     Cond 3: The balls in positions 1 and 7 are of different colors.
;;     Cond 4: There is a green ball to the left of every red ball.
;;     Cond 5: A white ball is neither first nor last.
;;     Cond 6: The balls in positions 6 and 7 are not red.
;; ------------------------------------------------------------------------- 
 



; Cond 1: The balls in positions 2 and 3 are not green.
(defun cond1 (state)
  
  (cond
     ((equal (what-is state 2) 'green) nil)
     ((equal (what-is state 3) 'green) nil)
     (T T)
  )
  
)

;; ------------------------------------------------------------------------- 
; Cond 2: The balls in positions 4 and 8 are the same color.
(defun cond2 (state)
  
  (setf ball4 (what-is state 4))
  (setf ball8 (what-is state 8))
  (cond
     ((equal ball4 ball8) T)
     (T nil)
  )
  
)

;; ------------------------------------------------------------------------- 
; Cond 3: The balls in positions 1 and 7 are of different colors.
(defun cond3 (state)

  (setf ball1 (what-is state 1))
  (setf ball7 (what-is state 7))
  (cond
     ((equal ball1 ball7) nil)
     (T T)
  )
  
)
  

;; ------------------------------------------------------------------------- 
(defun left-of-red (state left-color)
   
   (setf head (car state)) 
   (setf tail (cdr state)) 
   
   (cond 
       ((null state) T)
       ((equal head 'red) (and (equal left-color 'green) (left-of-red tail head)))
       (T  (left-of-red tail head))
   
   )

)

; Cond 4: There is a green ball to the left of every red ball.  
(defun cond4 (state)

  (setf ball1 (what-is state 1))
  
  (cond
     ((equal ball1 'red) nil)
     (T (left-of-red state 'green))
  )
  
)
;; ------------------------------------------------------------------------- 

; Cond 5: A white ball is neither first nor last.
(defun cond5 (state)
  
  (setf size (n_elements state 0))
  
  (cond
     ((equal (what-is state 1) 'white) nil)
     ((equal (what-is state size) 'white) nil)
     (T T)
  )
  
)
      
 ;; -------------------------------------------------------------------------      
; Cond 6: The balls in positions 6 and 7 are not red.
(defun cond6 (state)


  (cond
     ((equal (what-is state 6) 'red) nil)
     ((equal (what-is state 7) 'red) nil)
     (T T)
  )
  

)
      

;; -------------------------------------------------------------------------       

; This combines all conditions (cond1 to cond6)
(defun conds (state)

  (cond
     ((not (cond1 state)) nil)
     ((not (cond2 state)) nil)
     ((not (cond3 state)) nil)
     ((not (cond4 state)) nil)
     ((not (cond5 state)) nil)
     ((not (cond6 state)) nil)
     (T T)
  )

)

;; ------------------------------------------------------------------------- 

;; Given a list of 'states', i.e. all possible permutation of all balls,
;; it recursively produces all valid states in 'valid-states' list.
;; 
;; This is called by 'main' function as the interface
;; valid-states should be set to 'nil' when starting 
(defun check-conds-list (states valid-states)
   
   
   (setf state (car states))
   
   (if (equal state nil) ; base-case (if-1)
   
      valid-states    ; then-1
     
      (if (conds state)   ; else-1 (if-2)
       
        (progn   ; then-2 (state is valid, add to valid-states)
           (setf valid-states (cons state valid-states))
           (check-conds-list (cdr states) valid-states)
        )
        
        (check-conds-list (cdr states) valid-states)  ; else-2  (state is NOT valid, pass valid-states to the next level)

      ) ; end-if-2
   ) ; end-if-1

) ; end-function
      
;; ------------------------------------------------------------------------- 
      
; This is the main function that produces the desired list of ball permutations
; based on the given conditions
; b = 1
; w = 2
; r = 2
; g = 3
; You have eight colored balls: 1 black, 2 white, 2 red and 3 green.
(defun main (b w r g)

   (check-conds-list (permute-color b w r g) nil)

)

;; Results --
;; > (main 1 2 2 3)
;; ((GREEN RED WHITE GREEN RED BLACK WHITE GREEN) (GREEN RED WHITE GREEN RED WHITE BLACK GREEN) (GREEN RED BLACK GREEN RED WHITE WHITE GREEN))
;; ------------------------------------------------------------------------- 
;; ------------------------------------------------------------------------- 
;; ------------------------------------------------------------------------- 
