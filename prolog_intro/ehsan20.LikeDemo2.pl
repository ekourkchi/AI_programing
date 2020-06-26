%% ------------------------------------------------------------------------------
%% This program modified by Ehsan Kourkchi on Oct, 15, 2015
%% ------------------------------------------------------------------------------
%% In order to resolve the confusion and avoid the infinite recursion
%% two different types of "like" function is defined.
%% Ultimately, 'likes' function is constructed based on the other sub-like functions.
%%
%% If two A directly likes B ... then likes0(A, B) is a defined fact, and its true.
%% Always A directly likes itself. likes(A, A) is always true.
%% 
%% If two entities like each other indirectly, then "likes1" is a function to be true.
%% 
%% A likes B if and only if (A directly likes B), or, (A do not like B directly, but A likes B indirectly.)
%% We use "(A do not like B directly)" in order to avoid creating the a solution multiple times.
%% 
%% ------------------------------------------------------------------------------

/* Who knows whom. */

knowsAB(kim, cosmo).
knowsAB(kimo, kara).
knowsAB(sassy, jock).
knowsAB(cosmo, kimo).
knowsAB(kara, sassy). 
knowsAB(jock, kimo).

/* We'd like "knowing" to be commutative (but not associative). 
That is, if A knows B, B knows A; but if A knows B and B knows C, A doesn't necessarily know C. */

knows(X, Y) :- knowsAB(Y, X). 
knows(X, Y) :- knowsAB(X, Y).



/* Who likes0 what or whom. Not commutative. */

likes0(kim, cosmo).
likes0(sassy, cosmo). 
likes0(cosmo, sassy).
likes0(cosmo, cheese).
likes0(kim, cheese).
likes0(jock, chocolate).
likes0(kimo, chocolate).
likes0(kara, jock). 


/* Oh, also, people like themselves. */

likes0(X, X). % Is this the problem? 

/* If two people know each other, and like the same person or thing, they like each other. */

likes1(X, Y) :- % Or is this? 
  X \== Y,
  knows(X, Y), 
  likes0(X, Z),
  X \== Z,
  likes0(Y, Z),
  Y \== Z.


 
likes(X, Y) :-   likes0(X, Y).  
likes(X, Y) :-   likes1(X, Y), not(likes0(X, Y)).


  
  
  
  