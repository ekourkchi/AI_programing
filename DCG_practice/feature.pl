
s --> np(Num),vp(Num).


np(Num) --> det(Num), n(Num).

np(singular) -->  pn.
np(plural) --> n(plural).


vp(Num) --> verb(Num), np(_).
vp(Num) --> verb(Num).


det(_Num) --> [the].


det(singular1) --> [a].
det(singular2) --> [an].
det(plural)    --> [some].
det(uncountable) --> [some].




n(singular1) --> [dog].
n(singular2) --> [animal].
n(uncountable) --> [milk].
n(plural) --> [dogs].
n(plural) --> [animals].

verb(plural) --> [have].
verb(singular) --> [has].
verb(singular1) --> [has].
verb(singular2) --> [has].

pn --> [she].

%s --> np(Num),vp(Num).
 
%np(Num) --> det(Num), n(Num). 
%np(sing) --> pn. 
%np(plu) --> n(plu).
 
%vp(Num) --> verb(Num), np(_). 
%vp(Num) --> verb(Num). 


%det(sing) --> [every]. 
%det(sing) --> [a]. 
%det(_Num) --> [the]. 
 
%verb(sing) --> [chases]. 
%verb(plu) --> [chase]. 
%verb(sing) --> [miaows]. 
%verb(plu) --> [miaow]. 
 
%n(sing) --> [dog]. 
%n(plu) --> [dogs]. 
%n(sing) --> [cat]. 
%n(plu) --> [cats]. 
 
%pn --> [fido]. 
%pn --> [tigger].


/*
s --> np(Num), vp(Num).
 
np(Num)      --> det(Num), n(Num).
np(singular) --> pn.
np(plural)   --> n(plural).
 
 
vp(Num) --> verb(Num), np(_).
vp(Num) --> verb(Num).
 
det(_)           --> [the].
det(singular1)   --> [a].    % regular noun
det(singular2)   --> [an].   % a noun that starts with a vowel
det(plural)      --> [some].
det(uncountable) --> [some].
 
 
n(singular1)   --> [dog].
n(singular2)   --> [animal].
n(uncountable) --> [milk].
n(plural)      --> [dogs].
n(plural)      --> [animals].
 
verb(plural)    --> [have].
verb(singular)  --> [has].
 
%% The following rules can be better defined.
verb(singular1) --> [has].
verb(singular2) --> [has].
 
pn --> [she].
 
----
Example for good sentences: 
 
?- s([she, has, a, dog],[]).
true ;
 
?- s([she, has, an, animal],[]).
true ;
 
?- s([she, has, some, dogs],[]).
true ;
 
?- s([she, has, some, animals],[]).
true ;
 
?- s([she, has, some, milk],[]).
true ;
 
 
----- 
Example for bad sentences:
 
?- s([she, has, a, animal],[]).
false.
 
?- s([she, has, an, dog],[]).
false.
 
?- s([she, has, some, dog],[]).
false.
 
?- s([she, has, a, milk],[]).
false.
 
 
NOTE: This code does not capture all the grammatical errors. So it can still generate a sentence which is still wrong.
Example: 
  [a, dog, has, she]  
It's more or less the way Yoda talks in Star-Wars.
---
Ehsan Kourkchi

Institute for Astronomy (IfA) - C216A
2680 Woodlawn Drive
Honolulu, HI 96822-1839

*/
