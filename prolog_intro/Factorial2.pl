/* FACTORIALKB/2
Second argument is the factorial of the first. 
*/

factorialKB(X,Y):-
	factorial3arg(X,1,Y).

/* FACTORIAL3ARG/3
Tail-recursive version of factorial. Call with the second argument set to 1. 
Use "trace." to understand why!
*/
	
/* Base case first. */

factorial3arg(0,F,F).

/* Then recurse. */

factorial3arg(N,A,F):-
	N>0,
	A1 is N*A,
	N1 is N-1,
	factorial3arg(N1,A1,F).