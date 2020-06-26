%% DCG: combines syntactic features, and semantic representations.
% call like: sentence(Semantics, [the,dog,has,a,fluffy,tail], []).

sentence(Subj^Obj^[VRel,NRel|Rest]) --> 
    noun_phrase(Subj^[NRel|NRest]), 
    verb_phrase(Subj^Obj^[VRel|VRest]), {merge(VRest,NRest,Rest)}.

noun_phrase(Sem) --> 
    det, noun(Sem).

noun_phrase(Conc^[NRel,ARel]) --> 
    det, adj(Conc^[ARel]), 
    noun(Conc^[NRel]).

noun_phrase(Conc^[NRel,ARel]) --> 
    adj(Conc^[ARel]), noun(Conc^[NRel]).

verb_phrase(Subj^Obj^[VRel,NRel|Rest]) --> 
    verb(Subj^Obj^[VRel|VRest]),
    noun_phrase(Obj^[NRel|NRest]), {merge(VRest,NRest,Rest)}.

noun(Sem) --> {word(Word, Sem, noun)},Word.
verb(Sem) --> {word(Word,Sem, verb)},Word.
adj(Sem) --> {word(Word,Sem, adjective)},Word.
det --> {word(Word, determiner)},Word.

word([dog],X^[dog(X)],noun).
word([dogs],X^[dog(X)],noun).
word([has],X^Y^[has(X,Y)],verb).
word([have],X^Y^[has(X,Y)],verb).
word([had],X^Y^[has(X,Y)],verb).
word([fluffy],X^[fluffy(X)],adjective).
word([tail],X^[tail(X)],noun).
word([tails],X^[tail(X)],noun).
word([the],determiner).
word([a],determiner).

merge([], A, A).

merge([H|T],A,[H|Merged]):-
      merge(T,A,Merged).
