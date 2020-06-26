
/*****************************************************
% This code is written by Ehsan Kourkchi
% To do the Assignment 6 ---  ICS361
% Computer Science, University of Hawaii
% December 2015
% Email: ekourkchi@gmail.com
% 
% Feature: Error handling feature has been added.
% 
% To load the program: 
%       consult('ehsan20.HW06.B.Astar.8puzzle.pl').
%
%******************************************************/



% State : a 1-D list that represents the initial state of the tile-puzzle. 
% Goal : a 1-D list that represents the goal
% Solution_path : a set of moves that starts with the initial state and ends with the goal state 

astar(State, Goal, Solution_path) :-
    manhatan(State, 0, Goal, D),
    pop_open([[State, -1, 0, D]], [], Goal, _, _, Solution_path), !.
    
% default solution ....
astar(State, Solution_path) :- 
    pop_open([[State, -1, 0]], [], [1,2,3,4,5,6,7,8,0], _, _, Solution_path), !.
  
  
% Test cases: 

% Moves: 5 
%%  astar([2, 8, 3, 1, 6, 4, 7, 0, 5], [1, 2, 3, 8, 0, 4, 7, 6, 5], Solution).

% Moves: 6 
%%  astar([1, 3, 4, 8, 0, 5, 7, 2, 6], [1, 2, 3, 8, 0, 4, 7, 6, 5], Solution).

% Medium - 9 moves
%%  astar([1, 2, 3, 8, 0, 4, 7, 6, 5], [2, 8, 1, 0, 4, 3, 7, 6, 5], Solution).
    
    
% Hard - 12 moves  
%  astar([1, 2, 3, 4, 5, 8, 6, 7, 0], [1, 2, 3, 4, 5, 6, 7, 8, 0], Solution).

    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  PRINTING Predicates
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printState([]) :- format('~n').
printState([A|T]) :- n_elements([A|T], N), mod3(N, 0), format('~n ~w ', A), printState(T).
printState([A|T]) :- n_elements([A|T], N), mod3(N, M), M > 0, format('~w ', A), printState(T).


print_Chain([]).
print_Chain([State|Chain]):-
    printState(State),
    print_Chain(Chain).

printParent( _, Parent) :- 
    Parent < 0, format('NIL ').


printParent(Closed, Parent) :-
    Parent >= 0, 
    where_is([State, _, _, _], Closed, Parent),
    printLinear(State).

printLinear_([]).
printLinear_([A|PState]) :-
    format('~w ', A),
    printLinear_(PState).


printLinear(State) :-
    format(' ('),
    printLinear_(State),
    format(') ').
    

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Auxiliary Predicates
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% reverse([1,2,3], L, []).
% This predicate reverses a list
reverse([], Z, Z).
reverse([H|T], Z, Acc) :- reverse(T,Z,[H|Acc]).


% Usage: n_elements(List, N)
% N is the number of elements in the List
n_elements([], 0).
n_elements([_|A], N) :-  n_elements(A, M), N is M + 1.


% Usage: zero_point(List, N)
% N is the location of '0' in ths list
% Since '0' represents the blank tile in our puzzle, 
% it's important to find it position
% Note: N starts from 0
zero_point([0|_], 0).
zero_point([_|A], N) :- zero_point(A, M), N is M + 1.


% M = N mod 3
mod3(N, M):- N < 3, M is N.
mod3(N, M):- N > 2, mod3(N-3, M).

% If N is the index of a tile in represented 1D array, then I and J show
% its coordinates in real 2D puzzle board
% I represents row number
% J represents column number
n_ij(N, I, J) :- mod3(N, J), I is (N-J)/3.
ij_n(I, J, N) :- N is I*3+J.


% Usage: is_equal(L1, L2)
% True if both Lists, L1 and L2 are the same
is_equal([], []).
is_equal([L|T1], [L|T2]):-
    is_equal(T1, T2).

    
% Usage: push_end(A, L1, L2)
% Pushes the item 'A' at the end of the list 'L1' and 
% returns the result in 'L2'
push_end(A, [], [A]).
push_end(A, [H|T1], [H|T2]) :-
    push_end(A, T1, T2).


% Usage: push_end_list(A_list, L1, L2)
% It is the same as the previous predicates, except the first item which is a list
% The entire 'A_list' is pushed at the end of the list 'L1' and the result is returned in 'L2'.
push_end_list([], L, L). 
push_end_list([A|Alist], L1, L2) :-
    push_end(A, L1, Temp),
    push_end_list(Alist, Temp, L2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*   push_best_list(ItemList, L1, L2) adds all items of ItemList to
     the list 'L1' based on the priorities (F-values) and creates the list 'L2' as 
     the result. 
     
     F = G + H
     F is the heuristic fucntion
     G is the level of the node
     H is the Manhatan Distance in this problem   
     */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

push_best_(Result, L1, A, []) :-
    reverse(L1, Left, []),
    push_end(A, Left, Result).
    
push_best_(Result, L1, [State0, Parent0, Level0, F0], [[State, Parent, Level, F]|L2]) :-
    F0 =< F,
    reverse(L1, Left, []),
    push_end([State0, Parent0, Level0, F0], Left, Temp),
    push_end_list([[State, Parent, Level, F]|L2], Temp, Result).


% Usage: push_best_(Result, [], Item, List)
% Example: push_best_(Result, [], [1,1,2,-1], [[1,1,1,0],[1,2,3,1.5],[1,1,1,3],[1,1,1,4]]).   
push_best_(Result, L1, [State0, Parent0, Level0, F0], [[State, Parent, Level, F]|L2]) :-
    F0 > F,
    push_best_(Result, [[State, Parent, Level, F]|L1], [State0, Parent0, Level0, F0], L2).
    

push_best_list_(List, [], [], List).    
push_best_list_(Result, [], [Item|ItemList], List) :-
    \+ is_in_Plist(Item, List),
    push_best_(Temp, [], Item, List),
    push_best_list_(Result, [], ItemList, Temp).

% Ignoring those items that are already available in the Open list
push_best_list_(Result, [], [_|ItemList], List) :-
    push_best_list_(Result, [], ItemList, List).    

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%  Push function interfaces.
% They are designed in such a way that, the user can replace 'push_end_list' with 'push_best_list'
% and simply changes the Open-list to a priority queue
 
push_best(Item, L1, L2) :-
    push_best_(L2, [], Item, L1).
    
    
push_best_list(ItemList, L1, L2) :-
    push_best_list_(L2, [], ItemList, L1).
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Usage: where_is(A, List, N)
% N is the index of the item 'A' in the 'List'
where_is(A, [A|_], 0).
where_is(A, [_|T], N):-
    where_is(A, T, M),
    N is M+1.

    
single_dist(A, N, Goal, D):-
    n_ij(N, I, J),
    where_is(A, Goal, M),
    n_ij(M, P, Q),
    D is abs(I-P)+abs(J-Q).
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* The predicate to calculate the Manhattan distance  */ 


% Usage: manhatan(State, 0, Goal, D)
% Where D is the manhatan distance.
% Example: manhatan([1,2,3,5,7,8,6], 0, [1,2,4,3,5,6,8,7,0], D).
manhatan([], _, _, 0).
manhatan([A|T], N, Goal, Distance) :-
    single_dist(A, N, Goal, D1),
    M is N + 1,
    manhatan(T, M, Goal, D2),
    Distance is D2 + D1.
    
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
% Usage: set(A, L1, N, L2)
% The item 'A' would be entered at the position N
% of the list 'L1' and returned as 'L2'
% It's like: L1[N] = A  
set(A, [_|T], 0, [A|T]).
set(A, [H|T1], N, [H|T2]):- 
    M is N-1,
    set(A, T1, M, T2).

% Items at positions N1 and N2 in the list 'L1'
% would be swapped and the resulting list 
% is returned as L2
swap(L1, N1, N2, L2):-
    where_is(A1, L1, N1),
    where_is(A2, L1, N2),
    set(A1, L1, N2, Temp),
    set(A2, Temp, N1, L2).
    

%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  A C T I O N S
%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% I0, J0 are coordinates of the blank tile
% I and J are coordinates of the neighbor tiles
move_up(I0, J0, I, J) :- I is I0 + 1, I < 3, J is J0.
move_down(I0, J0, I, J) :- I is I0 - 1, I > -1, J is J0.
move_left(I0, J0, I, J) :- J is J0 + 1, J < 3, I is I0.
move_right(I0, J0, I, J) :- J is J0 - 1, J > -1, I is I0.


% I0, J0 are coordinates of the blank tile
% I, J are the coordinates of the tiles for possible moves
all_moves(I0, J0, I, J) :- 
    move_up(I0, J0, I, J);
    move_down(I0, J0, I, J);
    move_left(I0, J0, I, J);
    move_right(I0, J0, I, J).


% The same as the previous predicate,
% Uses N (1D array indices) instead of I, J
all_moves(N0, N) :-
    n_ij(N0, I0, J0),
    all_moves(I0, J0, I, J),
    ij_n(I, J, N).

%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  More complex predicates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Given a state of the puzzle, presented in a 1-D list,
% based on the puzzle legal moves, all possible child states are returned as 'Child'
% Example:  make_child([1,3,4,2,7,0,6,5,11,12,14,13,8,9,10,15], Child).
make_child(State, Child):- 
    zero_point(State, N0),
    all_moves(N0, N),
    swap(State, N0, N, Child).
    

% Usage: is_in_Plist(Pstate, Closed_list)
% Pstate = [[puzzl-1d-state], Parent, Level] 
% Each Pstate, contains the state of the board plus the index of its parent in 
% the closed list, 'Parent', and it's level in the state-tree, 'Level'.
% It returns 'true' is the State in a Pstate is already available in the closed list
% In another word, it checks wether a state has already been checked out
% Example: is_in_Plist([[1,2,3],2,3], [[[0,2,3],2,3], [[1,0,3],2,3], [[1,2,3],1,3]]).
%
is_in_Plist([S1|_], [[S2|_]|_]) :- is_equal(S1, S2).
is_in_Plist(Pstate, [_|Closed]) :- is_in_Plist(Pstate, Closed).
    

% Usage: pstate_make_child(Parent_Pstate, Closed_list, Child_Pstate)
% This predicate is more or less like 'make_child' predicate. Instead of States, it uses Pstates = [State, Parent, Level]
% and it returns the child in the form Pstate. (if the State is not already available in the Closed list)
pstate_make_child([State, _, Level, _], Closed, [Child, Parent_, Level_, F], Goal) :-
    make_child(State, Child),
    n_elements(Closed, N),
    Parent_ is N,
    Level_ is Level+1,
    manhatan(Child, 0, Goal, D),
    F is Level_ + D,
    \+ is_in_Plist([Child, _, _, _], Closed).
   

% Usage: pop_open(Open-list, Closed-list, Goal-state, New_Open, New-Closed, Solution_path)
% Given the Open-list and Closed-list, the first item in the open list is popped out and 
% is compared against the Goal-sate. If it does not meet the goal, it pushes at the end of the close list
% and its Children states (if they are not already available in the closed list) would be added at the end of the the open list
% The new open and closed list would be returned in New_Open and New_Closed lists.
pop_open([[State, Parent, Level, F]|Open], Closed, Goal, New_Open, New_Closed, Solution_path) :- 
    \+ is_equal(State, Goal),
    bagof(Child, pstate_make_child([State, _, Level, _], Closed, Child, Goal), Children),
    push_end([State, Parent, Level, F], Closed, New_Closed),
    format(' first node on open ='),
    printLinear(State),
    printParent(Closed, Parent),
    push_best_list(Children, Open, New_Open),
    format('level: ~w ', Level),
    format('F: ~w ~n', F),
    !, pop_open(New_Open, New_Closed, Goal, _, _, Solution_path).
    

% This is the same as the previous one, but it's activated when 'bagof' is false, meaning that 
% there is no new children produced by 'pstate_make_child'
pop_open([[State, Parent, Level, F]|Open], Closed, Goal, New_Open, New_Closed, Solution_path) :- 
    \+ is_equal(State, Goal),
    \+ bagof(Child, pstate_make_child([State, _, Level, _], Closed, Child, Goal), Children),
    push_end([State, Parent, Level, F], Closed, New_Closed),
    format(' first node on open ='),
    printLinear(State),
    printParent(Closed, Parent),
    push_best_list(Children, Open, New_Open),
    format('level: ~w ', Level),
    format('F: ~w ~n', F),
    !, pop_open(Open, New_Closed, Goal, _, _, Solution_path).
        

% If the popped state is the goal-state that we are looking for, this part of the predicate becomes activated,
% It produces the chain of moves and prints out the results.
%?- pop_open([[[1,3,3,2,7,0,6,5,11,12,13,13,8,9,10,15],2,3]], [], [1,3,3,2,7,0,6,5,11,12,13,13,8,9,10,15], New_Open, New_Closed, Solution_path).
pop_open([[State, Parent, Level, F]|Open], Closed, Goal, _, _, Solution_path) :- 
    is_equal(State, Goal),    
    format(' first node on open ='),
    printLinear(State),
    printParent(Closed, Parent),
    format('level: ~w ', Level),
    format('F: ~w ~n', F),
    format('~n Hooraay ! :) ~n'),
    n_elements(Closed, M), format(' length of closed = : ~w ~n', M),
    n_elements(Open, N), format(' length of open = ~w ~n', N),   % 
    format('~n # of Moves: ~w ~n', Level),
    make_chain(Parent, Closed, Chain), reverse(Chain, Rev_Chain, []), 
    push_end(Goal, Rev_Chain, Solution_path),  % goal state is added to the end of the solution path
    print_Chain(Solution_path), !.
    

   
%?- pop_open([], [], [1,3,4,2,7,0,6,5,11,12,13,13,8,9,10,15], New_Open, New_Closed).
%The Open list is empty ! :) 
%false.
pop_open([], _, _, _, _, _) :- 
    format('The Open list is empty ! :( ~n'),
    format('No solution found ! ~n'),
    fail.
    
 
% Usage: make_chain(Parent, Closed-list, State-list)
% Inputs: Parent, Closed-list
% Output: State-list
% Parent is the index of the parent of a node in the closed list. 
% Since we are constantly adding to the end of the Closed list, this indices stays the same 
% Using these indices saves memory, since we do not need to save the entire parent state
% 
% This predicate, traces back all the nodes, from the goal node by using it's parent index, 'Parent'
% all the way to the starting node. The resulting chain is returned in "State-list"
make_chain(-1, _, []).
make_chain(Parent, Closed, [State|T]) :- 
    where_is([State, Parent_, _, _], Closed, Parent),
    make_chain(Parent_, Closed, T).
    
    
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    


