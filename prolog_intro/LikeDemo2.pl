/* Who knows whom. */

knowsAB(kim, cosmo).
knowsAB(kimo, kara).
knowsAB(sassy, jock).
knowsAB(cosmo, kimo).
knowsAB(kara, sassy). 

/* We'd like "knowing" to be commutative (but not associative). That is, if A knows B, B knows A; but if A knows B and B knows C, A doesn't necessarily know C. */

knows(X, Y) :- knowsAB(Y, X). 
knows(X, Y) :- knowsAB(X, Y).

/* Who likes what or whom. Not commutative. */

likes(kim, cosmo).
likes(sassy, cosmo). 
likes(cosmo, sassy).
likes(cosmo, cheese).
likes(kim, cheese).
likes(jock, chocolate).
likes(kimo, chocolate).
likes(kara, jock). 

/* Oh, also, people like themselves. */

likes(X, X). % Is this the problem? 

/* If two people know each other, and like the same person or thing, they like each other. */

likes(X, Y) :- % Or is this? 
  knows(X, Y), 
  likes(X, Z), 
  likes(Y, Z). 