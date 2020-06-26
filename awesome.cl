(defun is_awesome (thingy thingyworld)
  (cond
   ((null thingyworld) nil)
   ((and (eq (car thingyworld) thingy) (spiffy thingy)) t)
   (t (is_awesome thingy (cdr thingyworld)))))

(defun spiffy (stuff)
  (cond
   ((null stuff) t)
   (t nil)))

/* TEST CASES

(is_awesome 7 '(7 () 6 4))
(is_awesome nil '(7 () 6 4))
(is_awesome (is_awesome 3 '(a () b)) '(a () b))
(is_awesome (not (spiffy 7)) '(1 3 5 7 nil))

*/
