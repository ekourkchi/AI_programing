
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
%       consult('ehsan20.HW06.A.BFS.15puzzle.pl').
%
%******************************************************/



% State : a 1-D list that represents the initial state of the tile-puzzle. 
% Goal : a 1-D list that represents the goal
% Solution_path : a set of moves that starts with the initial state and ends with the goal state 

bfs(State, Goal, Solution_path) :-
    pop_open([[State, -1, 0]], [], Goal, _, _, Solution_path).
    
% default solution ....
bfs(State, Solution_path) :- 
    pop_open([[State, -1, 0]], [], [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0], _, _, Solution_path).


%% easy: # of Moves: 5 
%%   bfs([13, 9, 7, 15, 3, 6, 8, 4, 11, 10, 2, 12, 5, 1, 14, 0], [13, 0, 9, 15, 3, 6, 7, 4, 11, 10, 8, 12, 5, 1, 2, 14], Solution).
%
%  13 | 9  |  7 | 15             13 | *  |  9 | 15
%   3 | 6  |  8 |  4    --->      3 |  6 |  7 |  4
%  11 | 10 |  2 | 12             11 | 10 |  8 | 12
%   5 |  1 | 14 |  *              5 |  1 |  2 | 14
%

%% Hard:  # of Moves: 9 
%%   bfs([13, 9, 7, 15, 3, 6, 8, 4, 11, 10, 2, 12, 5, 1, 14, 0], [3, 13, 9, 15, 11, 6, 7, 4, 10, 0, 8, 12, 5, 1, 2, 14], Solution).
%
%  13 | 9  |  7 | 15              3 | 13 |  9 | 15
%   3 | 6  |  8 |  4    --->     11 |  6 |  7 |  4
%  11 | 10 |  2 | 12             10 |  * |  8 | 12
%   5 |  1 | 14 |  *              5 |  1 |  2 | 14
%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  PRINTING Predicates
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printState([]) :- format('~n').
printState([A|T]) :- n_elements([A|T], N), mod4(N, 0), format('~n ~w ', A), printState(T).
printState([A|T]) :- n_elements([A|T], N), mod4(N, M), M > 0, format('~w ', A), printState(T).


print_Chain([]).
print_Chain([State|Chain]):-
    printState(State),
    print_Chain(Chain).

printParent( _, Parent) :- 
    Parent < 0, format('NIL ').


printParent(Closed, Parent) :-
    Parent >= 0, 
    where_is([State, _, _], Closed, Parent),
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
% N is the location of '0' in the list
% Since '0' represents the blank tile in our puzzle, 
% it's important to find it position
% Note: N starts from 0
zero_point([0|_], 0).
zero_point([_|A], N) :- zero_point(A, M), N is M + 1.


% M = N mod 4
mod4(N, M):- N < 4, M is N.
mod4(N, M):- N > 3, mod4(N-4, M).


% If N is the index of a tile in represented 1D array, then I and J show
% its coordinates in real 2D puzzle board
% I represents row number
% J represents column number
n_ij(N, I, J) :- mod4(N, J), I is (N-J)/4.
ij_n(I, J, N) :- N is I*4+J.


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
    
% Usage: where_is(A, List, N)
% N is the index of the item 'A' in the 'List'
where_is(A, [A|_], 0).
where_is(A, [_|T], N):-
    where_is(A, T, M),
    N is M+1.

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
move_up(I0, J0, I, J) :- I is I0 + 1, I < 4, J is J0.
move_down(I0, J0, I, J) :- I is I0 - 1, I > -1, J is J0.
move_left(I0, J0, I, J) :- J is J0 + 1, J < 4, I is I0.
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
make_child(State, Child):- 
    zero_point(State, N0),
    all_moves(N0, N),
    swap(State, N0, N, Child).
    

% Usage: is_in_Plist(Pstate, Closed_list)
% Pstate = [[puzzl-1d-state], Parent, Level] 
% Each Pstate, contains the state of the board plus the index of its parent in 
% the closed list, 'Parent', and it's level in the state-tree, 'Level'.
% It returns 'true' is the State in a Pstate is already available in the closed list
% In another word, it checks whether a state has already been checked out
%
is_in_Plist([S1|_], [[S2|_]|_]) :- is_equal(S1, S2).
is_in_Plist(Pstate, [_|Closed]) :- is_in_Plist(Pstate, Closed).
    

% Usage: pstate_make_child(Parent_Pstate, Closed_list, Child_Pstate)
% This predicate is more or less like 'make_child' predicate. Instead of States, it uses Pstates = [State, Parent, Level]
% and it returns the child in the form Pstate. (if the State is not already available in the Closed list)
pstate_make_child([State, _, Level], Closed, [Child, Parent_, Level_]) :-
    make_child(State, Child),
    n_elements(Closed, N),
    Parent_ is N,
    Level_ is Level+1,
    \+ is_in_Plist([Child, Parent_, Level_], Closed).
   

% Usage: pop_open(Open-list, Closed-list, Goal-state, New_Open, New-Closed, Solution_path)
% Given the Open-list and Closed-list, the first item in the open list is popped out and 
% is compared against the Goal-sate. If it does not meet the goal, it pushes at the end of the close list
% and its Children states (if they are not already available in the closed list) would be added at the end of the the open list
% The new open and closed list would be returned in New_Open and New_Closed lists.
pop_open([[State, Parent, Level]|Open], Closed, Goal, New_Open, New_Closed, Solution_path) :- 
    \+ is_equal(State, Goal),
    bagof(Child, pstate_make_child([State, Parent, Level], Closed, Child), Children),
    push_end([State, Parent, Level], Closed, New_Closed),
    format(' first node on open =', Level),
    printLinear(State),
    printParent(Closed, Parent),
    push_end_list(Children, Open, New_Open),
    format('level: ~w ~n', Level),
    !, pop_open(New_Open, New_Closed, Goal, _, _, Solution_path).
    

% This is the same as the previous one, but it's activated when 'bagof' is false, meaning that 
% there is no new children produced by 'pstate_make_child'
pop_open([[State, Parent, Level]|Open], Closed, Goal, New_Open, New_Closed, Solution_path) :- 
    \+ is_equal(State, Goal),
    \+ bagof(Child, pstate_make_child([State, Parent, Level], Closed, Child), Children),
    push_end([State, Parent, Level], Closed, New_Closed),
    format(' first node on open =', Level),
    printLinear(State),
    printParent(Closed, Parent),
    push_end_list(Children, Open, New_Open),
    format('level: ~w ~n', Level),
    !, pop_open(Open, New_Closed, Goal, _, _, Solution_path).
        

% If the popped state is the goal-state that we are looking for, this part of the predicate becomes activated,
% It produces the chain of moves and prints out the results.
pop_open([[State, Parent, Level]|Open], Closed, Goal, _, _, Solution_path) :- 
    is_equal(State, Goal),  
    format(' first node on open ='),
    printLinear(State),
    printParent(Closed, Parent),
    format('level: ~w ', Level),
    format('~n~n Hooraay ! :) ~n'),
    format(' # of Moves: ~w ~n', Level),
    n_elements(Closed, M), format(' length of closed = : ~w ~n', M),
    n_elements(Open, N), format(' length of open = ~w ~n', N),
    make_chain(Parent, Closed, Chain), reverse(Chain, Rev_Chain, []), 
    push_end(Goal, Rev_Chain, Solution_path),  % goal state is added to the end of the solution path
    print_Chain(Solution_path), !.
    

   
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
    where_is([State, Parent_, _], Closed, Parent),
    make_chain(Parent_, Closed, T).
    
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    


