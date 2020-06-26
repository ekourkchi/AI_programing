/* NOTE: This file is just a starting point! It is very much incomplete. You will have to modify the given clauses, and add new ones. 

Try these: 

?- top([is, it, true, that, mark, hamill, acts, in, star, wars, iv]).

?- top([who, acts, in, star, wars, iv]).

*/

/* TOP/1

ARG1 is a sentence represented as a list of atoms (e.g. [is, it, true, that, mark, hamill, acts, in, star, wars, iv]).

TOP/1 will succeed or fail. Either way, it should write out a sensible answer.

*/

top(Sentence) :-
  yesno(Query, Sentence, []), % This is a call to the DCG.
  Query, % evaluates the query. Succeeds if true, fails if false.
  format("Yes, that's true").

top(Sentence) :-
  who(Who, Sentence, []), % This is a call to the DCG.
  format("The person you're looking for is "),
  format(Who). % Can you make this better? It really should write out the text of the answer, not just the symbol. 

/* DCG: Here's the grammar. Right now it's very simple. */


who(X) --> [who], verb_phrase(X^_^[Query]), {Query}.

yesno(Sem) --> [is, it, true, that], statement(_^_^[Sem]). 

statement(Subj^Obj^Sem) --> 
 noun_phrase(Subj),
 verb_phrase(Subj^Obj^Sem).

noun_phrase(Sem) --> proper_noun(Sem).

verb_phrase(Subj^Obj^Sem) -->
    verb(Subj^Obj^Sem),
    noun_phrase(Obj).

proper_noun(mark_hamill) --> [mark, hamill].
proper_noun(star_wars4) --> [star, wars, iv].
verb(X^Y^[acts_in(X,Y)]) --> [acts, in].

/* DATABASE. Obviously, you're going to have to fill this out a lot. */

actor(mark_hamill).
acts_in(mark_hamill, star_wars4).
acts_in(harrison_ford, star_wars4).
