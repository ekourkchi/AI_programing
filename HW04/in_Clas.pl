/*

To load the program: consult('in_Clas.pl').




To load the program: consult('in_Clas.pl').



*/


/* ismember/2. Checks if its first argument (an atom) is a member of its 
second item (a list).  */
% ismember(Item, List) is true if the Item is the member of the List.

% Base case: true if the Item is the first element of the input list
ismember(H, [H|_]).
% Recursion on the second argument of the predicate
ismember(A, [_|T]):- ismember(A, T).




/* ---------------------------------------------------*/


/* sum_up/2. Takes a list of numbers as its first argument, and returns the 
sum of the numbers as its second argument */

% base case
sum_up(0, []).
% Recursion on the second argument
sum_up(N, [H|T]):- sum_up(M, T), N is M + H.

% Example:
% ?- sum_up(N, [1,2,4]).
% N = 7.


/* ---------------------------------------------------*/

/* myappend/3. The third argument is the first two arguments, appended */
% Here we are recusing on the first list, since we can easy have access to the
% first element. 
% myappend(L1, L2, L) is true if L is the result of L2 that is appended at the end of L1


% base case
myappend([], L, L):- !.
myappend([H|L1], L2, [H|L]):- myappend(L1, L2, L).

% ?- myappend([1,2], [5,3],  L).
% L = [1, 2, 5, 3].

/* ---------------------------------------------------*/


/* reverselist/2. Reverses the order of its first argument and returns the 
reversed list as its second argument. [Hint: might want to create a second 
predicate with *3* arguments to do all the work. See discussion here: 
http://www.learnprolognow.org/lpnpage.php?pagetype=html&pageid=lpn-htmlse25] */

% reverselist(L1, L2) is true is L2 is the reverse of L1.
% L1 and L2 has the exact same elements, orderred in different ways

% base case 
reverselist([], []).
reverselist([H|L1], L2):- last(L2, First_list, Last_item), H = Last_item, reverselist(L1, First_list), !.


% last(List, First_list, Last_item)
% It's true, if the Last_item is the las t item in the list
% and First_list is the list after removing the last item

% Example: 
% ?- last([1,2,3,4,5], L1, L2).
% L1 = [1, 2, 3, 4],
% L2 = 5 ;

last([Last_item], [], Last_item).
last([H|List], [H|First_list], Last_item):- last(List, First_list, Last_item).
   
/* ---------------------------------------------------*/
