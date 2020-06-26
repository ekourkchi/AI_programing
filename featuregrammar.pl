/* This is a simple DCG, which uses the "number" feature to enforce agreement in  verb phrases (e.g. so that "The dogs have some fluffy tails" parses, but "The dog have some fluffy tails" does not) and in noun phrases (e.g. so that "A dogs have fluffy tails" doesn't parse).

Note that other features ("root", "tense" and "part of speech" aka "pos") are included, but not used to enforce agreement in this particular grammar. 

This DCG also keeps track of sentence structure, and returns it as the first argument to sentence/4. 

Call sentence/4 as follows, to generate valid sentences:

?- sentence(Syntax, Features, Sentence, []). 

Use ";" to scan through them and see if they are all, in fact, grammatical. 

Or, check a particular sentence like this: 

?- sentence(Syntax, Features, [the,dogs,have,some,tails], []).

*/

% The DCG. Top symbol: sentence.

sentence(s(NP,VP),[pos=s]) --> noun_phrase(NP,[_,number=Number]), verb_phrase(VP,[_,number=Number]).
noun_phrase(np(D,N),[pos=np,number=Number]) --> det(D,[_,_,number=Number]), noun(N,[_,_,number=Number]).
noun_phrase(np(D,A,N),[pos=np, number=Number]) --> det(D,[_,_,number=Number]), adj(A, _), noun(N, [_,_,number=Number]).
noun_phrase(np(A,N),[pos=np, number=plur]) --> adj(A,_), noun(N,[_,_,number=plur]).
verb_phrase(vp(V,NP),[pos=vp, number=Number]) --> verb(V, [_,_,number=Number,_]), noun_phrase(NP,_).

/* These rules just allow the DCG to access a dictionary kept in an easier-to-read format. If you prefer, instead of a separate dictionary, you just could have rules like: 

noun(n([dog]), [pos=noun, root=dog, number=sing]) --> [dog].

Up to you.

*/

noun(n(Word), [pos=noun|R]) --> {word(Word,[pos=noun|R])},Word.
verb(v(Word), [pos=verb|R]) --> {word(Word,[pos=verb|R])},Word.
adj(a(Word), [pos=adj|R]) --> {word(Word,[pos=adj|R])},Word.
det(d(Word), [pos=det|R]) -->{word(Word,[pos=det|R])},Word.

% The dictionary.

word([dog],[pos=noun, root=dog, number=sing]).
word([dogs],[pos=noun, root=dog, number=plur]).
word([has],[pos=verb, root=has, number=sing, tense=present]).
word([have],[pos=verb, root=has, number=plur, tense=present]).
word([had],[pos=verb, root=has, number=_, tense=past]).
word([fluffy],[pos=adj, root=fluffy]).
word([tail],[pos=noun, root=tail, number=sing]).
word([tails],[pos=noun, root=tail, number=plur]).
word([the],[pos=det, root=the, number=_]).
word([a],[pos=det, root=a, number=sing]).
word([some],[pos=det, root=some, number=plur]).

