; This code is commented by Ehsan Kourkchi
; as a requirment for the assignment #1 ICS361
; August 31 2015


; How to run a lisp progrm:
; > lisp or > clisp
; (load "guess.lisp")
; (guess-my-number)
; (smaller)
; (bigger)
;
;
;;;;;;;;;;;;;;;;;
; How it works?
;;;;;;;;;;;;;;;;;
; 1) This program initiially has an upper and lower bounds for 
; the desired number

; 2) As the initial guess, it averages out both ending limits, i.e. (upper+lower)/2

; 3) If the guessed number is smaller, then the upper bound ('big' variable) would be set to the current guessed 
; decremented by one. This way it makes sure that it will not prodcue any other number bigger 
; than the current guess

; 4) Simillarly, if the guessed numebr is larger, then the lower limit ('small' variable) is set to the current guess 
; plus one.

; This way, by squeezing the range of possible guessed numbers, we approach the actual number.




; "small" is the variable which is defined here and initialized to 1
(defparameter *small* 1)

; "big" is the variable which is defined here and initialized to 100
(defparameter *big* 100)

;;;;;;;;;;;;;;;;;;;;
; Fuction definition
; name of the function: guess-my-number
; no input arguments
; it returns (small+big)/2 

; 'ash' is the function that shifts the binary number to left or right. The amount of shift is specified as the input
; For example, in this case, (ash a -1) shifts the number 'a' to right by one space which means that the number 'a'
; would be divided by 2

; (+ a b) means a+b, therefore '(ash (+ *small* *big*) -1))' is equivalent to (small+big)/2
(defun guess-my-number ()
     (ash (+ *small* *big*) -1))
     ;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;
; Fuction definition
; name of the function: smaller
; no input arguments
; it has two lines:
; 1) It sets the variable 'big' to the current_guess that is decremented by one
; '(1- (guess-my-number))' means the current guess minus one
; 2) It calls function (guess-my-number) to generate the new guess
(defun smaller ()
     (setf *big* (1- (guess-my-number)))
     (guess-my-number))
     ;;;;;;;;;;;;;;;;;;;;

     
;;;;;;;;;;;;;;;;;;;;
; Fuction definition
; name of the function: bigger
; no input arguments
; it has two lines:
; 1) It sets the variable 'small' to the current_guess that is incremented by one
; '(1+ (guess-my-number))' means the current guess plus one
; 2) It calls function (guess-my-number) to generate the new guess
(defun bigger ()
     (setf *small* (1+ (guess-my-number)))
     (guess-my-number))
     ;;;;;;;;;;;;;;;;;;;;

     
     
     
;;;;;;;;;;;;;;;;;;;;
; Fuction definition
; name of the function: start-over
; no input arguments
; it has three lines:
; 1) resets the variable 'small', which is set to '1'
; 2) resets the variable 'big', which is set to '100'
; 3) It calls function (guess-my-number) to generate the first guess, i.e. 50

(defun start-over ()
   (defparameter *small* 1)
   (defparameter *big* 100)
   (guess-my-number))
   ;;;;;;;;;;;;;;;;;;;;
