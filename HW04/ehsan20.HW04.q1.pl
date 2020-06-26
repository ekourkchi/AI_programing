
/*
To load the program: consult('ehsan20.HW04.q1.pl').

This code is written by Ehsan Kourkchi
To do the Assignment 4 (question 1) ---  ICS361
Computer Science, University of Hawaii
November 2015
Email: ekourkchi@gmail.com

Feature: Error handling feature has been added.

*/



%% This is the error handling part.
listlength(LIST, _):-
  LIST \= [], atomic(LIST),  format('The first argument must be a list.~n'), !.

listlength(_, N):-
  nonvar(N), \+ integer(N), format('The second argument must be either an integer or a variable.~n'), !.


%%  listlength/2

%% Base case: An empty list has the length of zero
listlength([], 0).

%% recursive call: Taking out head of the list as incrementing the number of the list elements.
listlength([_|T], N):-
    listlength(T, M), N is M+1.
    
    
    
