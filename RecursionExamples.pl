/* ISMEMBER/2. Suceeds if ARG1 (an atom) is a member of ARG2 (a list). */

ismember(A, [A|_]). 

ismember(A, [_|T]) :- 
  ismember(A, T). 

/* SUMUP/2. ARG2 (integer) is the sum of ARG1 (list of integers). */

sumup([], 0). 

sumup([H|T], N):- 
 sumup(T, N1), 
 N is H + N1. 

/* MYAPPEND/3. ARG3 is ARG1 and ARG2, appended. */

myappend([], L, L). 

myappend([H|T], A, [H|A1]):-
  myappend(T, A, A1). 


/* REVERSE1/2 ARG1 is a list. ARG1 is the reversed list. Here, we use myappend/3, defined above. However, this is not very efficient. Why? */

reverse1([A],[A]).

reverse1([H|T], RList) :-
  reverse1(T, Y),
  myappend(Y, [H], RList). 

/* REVERSELIST/2. ARG1 is a list. ARG1 is the reversed list. This approach is much more efficient, but a little harder to get your head around. */

reverselist(X, Y) :-
  reverse2(X, [], Y). 

reverse2([], Y, Y). 

reverse2([H|T], X, Y):-
  reverse2(T, [H|X], Y). 

/* ALLMEMBERS/2 */

allmembers(L, L2) :-
  bagof(A, ismember(A, L), L2).


  
