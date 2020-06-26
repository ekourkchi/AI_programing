
/* To load the program: consult('ehsan20.HW04.q2.s1.pl').

This code is written by Ehsan Kourkchi
To do the Assignment 4  (question 2) ---  ICS361
Computer Science, University of Hawaii
November 2015
Email: ekourkchi@gmail.com

Feature: Error handling feature has been added.

To load the program: consult('ehsan20.HW04.q2.pl').


 *************************************** */
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

%% color/7 gets a list of colors as the input, and returns the number of each color
%% in the following given variable
%% ----------------------------------------
%% Example: color([red, white, blue, yellow], Red, Green, Blue, Yellow, Black, White).
%% Red = Blue, Blue = Yellow, Yellow = White, White = 1,
%% Green = Black, Black = 0 .
%% ----------------------------------------

%% This is the error handling part.
color(LIST, _, _, _, _, _, _):-
  LIST \= [], atomic(LIST),  format('The first argument must be a list.~n'), !.

color(_,  Red, _, _, _, _, _):-
  nonvar(Red), \+ integer(Red), format('The second argument must be either an integer or a variable.~n'), !.

color(_,  _, Green, _, _, _, _):-
  nonvar(Green), \+ integer(Green), format('The third argument must be either an integer or a variable.~n'), !.

color(_,  _, _, Blue, _, _, _):-
  nonvar(Blue), \+ integer(Blue), format('The forth argument must be either an integer or a variable.~n'), !.
  
color(_,  _, _, _, Yellow, _, _):-
  nonvar(Yellow), \+ integer(Yellow), format('The fifth argument must be either an integer or a variable.~n'), !.
  
color(_,  _, _, _, _, Black, _):-
  nonvar(Black), \+ integer(Black), format('The sixth argument must be either an integer or a variable.~n'), !.
  
color(_,  _, _, _, _, _, White):-
  nonvar(White), \+ integer(White), format('The seventh argument must be either an integer or a variable.~n'), !.

%%    color([red,blue,blue,yellow],  Red, Green, Blue, Yellow, Black, White).

%% base case
color([], 0, 0, 0, 0 ,0, 0).

%% several recursive cases, one for each color.
color([H|T], Red, Green, Blue, Yellow, Black, White):-
   H = red, color(T, Red_, Green, Blue, Yellow, Black, White), Red is Red_+1.
color([H|T], Red, Green, Blue, Yellow, Black, White):-
   H = green, color(T, Red, Green_, Blue, Yellow, Black, White), Green is Green_+1.
color([H|T], Red, Green, Blue, Yellow, Black, White):-
   H = blue, color(T, Red, Green, Blue_, Yellow, Black, White), Blue is Blue_+1.
color([H|T], Red, Green, Blue, Yellow, Black, White):-
   H = yellow, color(T, Red, Green, Blue, Yellow_, Black, White), Yellow is Yellow_+1.
color([H|T], Red, Green, Blue, Yellow, Black, White):-
   H = black, color(T, Red, Green, Blue, Yellow, Black_, White), Black is Black_+1.
color([H|T], Red, Green, Blue, Yellow, Black, White):-
   H = white, color(T, Red, Green, Blue, Yellow, Black, White_), White is White_+1.   

   
   
/* *************************************** */
% This is the error handling part.
situation1(LIST):-
  LIST \= [], atomic(LIST),  format('Please give a list as the argument.~n'), !.

/*
This is the predicate for the situation 1, 
    
    condition 1) You have six colored balls: 2 green, 2 blue and 2 yellow
    condition 2) No balls of the same color may be adjacent to one another.
 

  This makes sure that condition 1 holds --> we have 6 balls, so the 
  list must have 6 memebrs, and 2 green, 2 blue and 2 yellow, and conditions 2 (constraint1) must hold
*/
situation1(LIST):-
   listlength(LIST, 6), !, color(LIST, 0, 2, 2, 2, 0, 0), constraint1(LIST).

   
%% base case: If list is empty or it has only one ball in it, we are ok
constraint1(LIST):- listlength(LIST, 0); listlength(LIST, 1).

%% recursive case: If list has more than one elements, we look at the first two members,
%% H2 and H1, they should not be in the same color, and the constraint1 should hold for the rest of 
%% the list when we remove the header, H1.
constraint1([H1|T]):-
   T = [H2|_], H1 \= H2, constraint1(T), !.
/* ***************************************   


  
  This is the predicate for the situation 2, 
    condition 1) You have six colored balls: 4 black, 1 red and 1 blue.
    condition 2) There are no more than 2 black balls in a row.


*************************************** */
% This is the error handling part.
situation2(LIST):-
  LIST \= [], atomic(LIST),  format('Please give a list as the argument.~n'), !.

%% Base case, again we make sure that the list has only 6 memebrs, 1-red, 1-blue, and 4-black. 
%% Then we make sure that the conditions 2 of the situatiion #2 holds.
situation2(LIST):-
   listlength(LIST, 6), !, color(LIST, 1, 0, 1, 0, 4, 0), constraint2(LIST).

   
%% Condition 2 above is checked here.
%% Base case: If the list is either empty, or has 1 memeber or 2 members, we are sure that there are no more than
%% 2 black balls in a row. Because, we have at most 2 balls in this case.
constraint2(LIST):- listlength(LIST, 0); listlength(LIST, 1);  listlength(LIST, 2), !.

%% If the fist element of the list is not black, we are ok, as long as the rest of the list 
%% hold the condition
constraint2([H|T]):-
   H \= black, constraint2(T), !.  

%% If the first element is black, (meaning that the above predicate is not true),
%% then we are ok as long as th first and second eleemnts are not in the same color, and the 
%% constraint for the rest of the list holds.
constraint2([H1|T]):-
   T = [H2|_], H1 \= H2, constraint2(T), !.    

%%  So if the above conditions do not hold, it means that, the first element might be black,
%%  and the first and second balls can be black. Therefore, we check for the third ball, and if it has 
%%  a different color and the constraint holds for the rest of the list, we are OK.
constraint2([_|T1]):-
   T1 = [H2|T2], T2 = [H3|_], H2 \= H3, constraint2(T1), !.

 
 /* ***************************************      
   
  
  Situation #3 (30 points)

    cond 1) You have eight colored balls: 1 black, 2 white, 2 red and 3 green.
    cond 2) The balls in positions 2 and 3 are not green.
    cond 3) The balls in positions 4 and 8 are the same color.
    cond 4) The balls in positions 1 and 7 are of different colors.
    cond 5) There is a green ball to the left of every red ball.
    cond 6) A white ball is neither first nor last.
    cond 7) The balls in positions 6 and 7 are not red.

  
 *************************************** */
% This is the error handling part.
situation3(LIST):-
  LIST \= [], atomic(LIST),  format('Please give a list as the argument.~n'), !.


%% Base case: checking the "cond1" and making sure that the other conditions are held using constraint3/1.
%% color([red,blue,blue,yellow],  Red, Green, Blue, Yellow, Black, White).

situation3(LIST):-
   listlength(LIST, 8), !, color(LIST, 2, 3, 0, 0, 1, 2), constraint3(LIST).

   

constraint3(LIST):- 
   notGreen_2(LIST), 		% cond 2) The balls in positions 2
   notGreen_3(LIST),		% cond 2) and 3 are not green.
   sameColor_4_8(LIST),		% cond 3) The balls in positions 4 and 8 are the same color.
   differentColor_1_7(LIST),	% cond 4) The balls in positions 1 and 7 are of different colors.
   check_green_red(LIST),	% cond 5) There is a green ball to the left of every red ball.
   notFirstWhite(LIST),		% cond 6) A white ball is neither first
   notLastWhite(LIST),		% cond 6) nor last.
   notRed_6(LIST),		% cond 7) The balls in positions 6
   notRed_7(LIST).		% cond 7) and 7 are not red.
   
/* *************************************** */     


/*  ***************************************     
position/3 is a useful predicate that returns the positiin of a given item (a color is this case),  in a list.

Example: 
  ?- position([green, red, green, red, black, green], green, N).
    N = 1 ;
    N = 3 ;
    N = 6 ;
    false.

*/
position([H|_], Item, 1):-
   H = Item.
position([_|T], Item, N):-
   position(T, Item, M), N is M+1.
   
   
/* *************************************** */     
   
%% The balls in positions 2 and 3 are not green.
notGreen_2(LIST):- position(LIST, Item, 2), Item \= green.
notGreen_3(LIST):- position(LIST, Item, 3), Item \= green.


%% The balls in positions 4 and 8 are the same color.
sameColor_4_8(LIST):- position(LIST, Item1, 4), position(LIST, Item2, 8), Item1 = Item2.
   

%% The balls in positions 1 and 7 are of different colors.
differentColor_1_7(LIST):- position(LIST, Item1, 1), position(LIST, Item2, 7), Item1 \= Item2.

/* *************************************** */
%% There is a green ball to the left of every red ball.

%% we make sure that there is no red ball in the beginning of the list.
%% Otherwise we are required to have a green ball on its left side, and th green ball 
%% should be the first element
check_green_red(LIST):-
  notRed_1(LIST), leftGreen(LIST).

notRed_1(LIST):- position(LIST, Item, 1), Item \= red.


%% leftgreen/1 is a predicate that make sure that there is a green ball on the left side of each red ball.
%% Base case: is the list is empty or has one member, return true.
%% Note that we are sure that there is no list of single red ball at this poiont, otherwise we could have caught it previously
leftGreen(LIST):- listlength(LIST, 0); listlength(LIST, 1).

%% If the second ball is not red, we don't bother checking the left ball and we continue the recursion.
leftGreen([_|T]):- 
    T = [H2|_], H2 \= red, leftGreen(T),!.

%% If the above conditions do not hold, there is chance that the second ball in the list is red and 
%% here, we make sure that the left ball to be green.
leftGreen([H1|T]):-
    H1 = green, leftGreen(T),!.
/* *************************************** */
    
    
    
%% A white ball is neither first nor last.
notFirstWhite(LIST):- position(LIST, Item, 1), Item \= white.
notLastWhite(LIST):- position(LIST, Item, 8), Item \= white.

%% The balls in positions 6 and 7 are not red.
notRed_6(LIST):- position(LIST, Item, 6), Item \= red.
notRed_7(LIST):- position(LIST, Item, 7), Item \= red.

