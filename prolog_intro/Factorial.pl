/* Base case first. */

factorialKB(0,1).

/* Then recurse. Note: No error checking! */

factorialKB(N,Nfact):-
	Z is N-1, 
	factorialKB(Z,Zfact),
	Nfact is N * Zfact.

