
/*
This code is written by Ehsan Kourkchi
To do the Assignment 4  (question 3) ---  ICS361
Computer Science, University of Hawaii
November 2015
Email: ekourkchi@gmail.com

Feature: Error handling feature has been added.

To load the program: consult('ehsan20.HW04.q3.pl').

*/


/* *************************************** */
%% Here, we are using the listlength predicate, defined for question 1.

%%  listlength/2

listlength(LIST, _):-
  LIST \= [], atomic(LIST),  format('The first argument must be a list.~n'), !.

listlength(_, N):-
  nonvar(N), \+ integer(N), format('The second argument must be either an integer or a variable.~n'), !.


  
listlength([], 0).
listlength([_|T], N):-
  listlength(T, M), N is M+1.
    
/* *************************************** */

  
/* *************************************** */
%% This is the error handling part.
split3(_, LIST):-
  LIST \= [], atomic(LIST),  format('The second argument must be a list.~n'), !.

split3(N, _):-
  nonvar(N), \+ integer(N), format('The first argument must be either an integer or a variable.~n'), !.

/* N, a positive integer, and 
 L, a list of positive integers
 split3(N,L) 
 
 Basically, it works in a very simple way,
 First, it partitions the list "L" into three non-empty sub-list (i.e. L1, L2, and L3)
 Then for each list, the items woudl be added up and compared to the given value "N".

*/
split3(N,L):- 
    partition3(L1, L2, L3, L),
    addItems(L1, N1), N1 =< N,
    addItems(L2, N2), N2 =< N,
    addItems(L3, N3), N3 =< N, !.


    
/* *************************************** 
  myappend/3 concatenates 2 lists. myappend(L1, L2, L) is true if L is 
  the result of concatenating L1 and L2
  
  Example: 
  ?- myappend([1,2],[3,2],L).
  L = [1, 2, 3, 2].

*/
myappend([], L, L).

myappend([H|T1], L2, [H|T]):-
    myappend(T1, L2, T).
/* ************************************** */

   
/* *************************************** 
  partition3/4 is a predicate that partitions a list into 3 non-empty sublists.
  partition3(L1, L2, L3, L) is true if L is the result of merging L1, L2 and L3, while none of
  L1, L2, and L3 are empty. 
  
  Example:
  ?- partition3(L1, L2, L3, [1,2,4,6,4,3]).
    L1 = [1],
    L2 = [2],
    L3 = [4, 6, 4, 3] ;
    L1 = [1],
    L2 = [2, 4],
    L3 = [6, 4, 3] ;
    L1 = [1, 2],
    L2 = [4],
    L3 = [6, 4, 3] ;
    L1 = [1],
    L2 = [2, 4, 6],
    L3 = [4, 3] ;
    L1 = [1, 2],
    L2 = [4, 6],
    L3 = [4, 3] ;
    L1 = [1, 2, 4],
    L2 = [6],
    L3 = [4, 3] ;
    L1 = [1],
    L2 = [2, 4, 6, 4],
    L3 = [3] ;
    L1 = [1, 2],
    L2 = [4, 6, 4],
    L3 = [3] ;
    L1 = [1, 2, 4],
    L2 = [6, 4],
    L3 = [3] ;
    L1 = [1, 2, 4, 6],
    L2 = [4],
    L3 = [3] ;
    false.

    As seen, it finds all the possible partitions.
  
*/
partition3(L1, L2, L3, L):- 
    myappend(L12, L3, L), myappend(L1, L2, L12),
    listlength(L1, N1), N1 > 0,
    listlength(L2, N2), N2 > 0,
    listlength(L3, N3), N3 > 0.
    

/* *************************************** 
  addItems/2: sums up all numerical items in the list and returns it in its second argument
  
  Example: 
  ?- addItems([1,5,6,4], N).
  N = 16.

*/ 
%% base case: an empty list has no item, therefore the sum is zero
addItems([], 0).

%% we recursively take out the first item of the list and add its value to the SUM, 
%% until we hit the base-case.
addItems([H|T], SUM):-
     addItems(T, SUM_), SUM is SUM_ + H. 
/* ************************************** */

 splitTest(_) :-
       \+ split3(5,[]),
       \+ split3(6,[5, 5, 12]),
       split3(14,[6, 5, 10, 1, 1, 1, 14]),
       split3(5,[3, 1, 4, 1, 2]),
       \+ split3(6,[4, 3, 5, 2, 1]),
       \+ split3(7,[4, 5, 7, 2, 3]),
       split3(8,[3,5,4,2,7,1]),
       \+ split3(3,[1, 2, 2, 2, 1, 1]),
       \+ split3(1,[1,1]),
       split3(1,[1,1,1]),
       \+ split3(1,[1,1,1,1]),
       \+ split3(1,[1,1,1,1,1]),
       \+ split3(1,[1]),
       split3(2,[1,1,1,1,1,1]),
       split3(2,[1,-1,1]),
       \+ split3(4,[4,4,1,2,3]),
       \+ split3(2,[1,1,2,4]),
       split3(4,[4,1,0]),
       \+ split3(4,[5,1,1,1]),
       split3(3,[1,2,1,2,1,2]).


     
