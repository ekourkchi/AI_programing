/* Who knows each other. */

knows(kim, cosmo).
knows(kimo, kara).
knows(sassy, jock).
knows(cosmo, kimo).
knows(kara, sassy). 

/* We'd like "knowing" to be commutative [but not associative]. That is, if A knows B, B knows A; but if A knows B and B knows C, A doesn't necessarily know C. */

knows(X, Y) :- knows(Y, X). 

/* Who likes what/whom. Not commutative. */

likes(kim, cosmo).
likes(sassy, cosmo). 
likes(cosmo, sassy).
likes(cosmo, cheese).
likes(kim, cheese).
likes(jock, chocolate).
likes(kimo, chocolate).
likes(kara, jock). 

/* Oh, but people like themselves. */

likes(X, X). 

/* If two people know each other, and like the same person/thing, they like each other. */

likes(X, Y) :-
  knows(X, Y), 
  likes(X, Z), 
  likes(Y, Z). 