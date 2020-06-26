/* SITUATION: Vincent hates all burgers except for Big Kahuna burgers. */

/* hates(vincent,X)  :-  big_kahuna_burger(X),!,fail. 
hates(vincent,X)  :-  burger(X). */
    
burger(X)  :-  big_mac(X). 
burger(X)  :-  big_kahuna_burger(X). 
burger(X)  :-  whopper(X). 
    
big_mac(a). 
big_kahuna_burger(b). 
big_mac(c). 
whopper(d).

hates(vincent,X) :- burger(X), \+ big_kahuna_burger(X).

