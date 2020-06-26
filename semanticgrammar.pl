%% syntactic structure, features, and semantics
%% call with sentence(Syntax,Features,Semantics,[the,dog,has,a,fluffy,tail],[]).

sentence(s(NP,VP),[pos=s],Subj^Obj^[VRel,NRel|Rest]) --> 
noun_phrase(NP,[_,number=Number],Subj^[NRel|NRest]), 
verb_phrase(VP,[_,number=Number],Subj^Obj^[VRel|VRest]), {merge(VRest,NRest,Rest)}.

noun_phrase(np(D,N),[pos=np,number=Number],Sem) --> 
det(D,[_,_,number=Number]), noun(N,[_,_,number=Number],Sem).

noun_phrase(np(D,A,N),[pos=np, number=Number],Conc^[NRel,ARel]) --> 
det(D,[_,_,number=Number]), adj(A, _,Conc^[ARel]), 
noun(N, [_,_,number=Number],Conc^[NRel]).

noun_phrase(np(A,N),[pos=np, number=Number],Conc^[NRel,ARel]) --> 
adj(A,_,Conc^[ARel]), noun(N,[_,_,number=Number],Conc^[NRel]).

verb_phrase(vp(V,NP),[pos=vp, number=Number],Subj^Obj^[VRel,NRel|Rest]) --> 
verb(V, [_,_,number=Number,_], Subj^Obj^[VRel|VRest]),
 noun_phrase(NP,_,Obj^[NRel|NRest]), {merge(VRest,NRest,Rest)}.

    noun(n(Word), [pos=noun|R], Sem) --> {word(Word,[pos=noun|R],Sem)},Word.
    verb(v(Word), [pos=verb|R], Sem) --> {word(Word,[pos=verb|R],Sem)},Word.
    adj(a(Word), [pos=adj|R], Sem) --> {word(Word,[pos=adj|R],Sem)},Word.
    det(d(Word), [pos=det|R]) -->{word(Word,[pos=det|R])},Word.

word([dog],[pos=noun, root=dog, number=sing], X^[dog(X)]).
word([dogs],[pos=noun, root=dog, number=plur], X^[dog(X)]).
word([has],[pos=verb, root=has, number=sing, tense=present],X^Y^[has(X,Y)]).
word([have],[pos=verb, root=has, number=plur, tense=present],X^Y^[has(X,Y)]).
word([had],[pos=verb, root=has, number=_, tense=past],X^Y^[has(X,Y)]).
word([fluffy],[pos=adj, root=fluffy],X^[fluffy(X)]).
word([tail],[pos=noun, root=tail, number=sing],X^[tail(X)]).
word([tails],[pos=noun, root=tail, number=plur],X^[tail(X)]).
word([the],[pos=det, root=the, number=_]).
word([a],[pos=det, root=a, number=sing]).

% "The dog has a fluffy tail."
% dog(X), tail(Y), fluffy(Y), has(X,Y).

merge([], A, A).

merge([H|T],A,[H|Merged]):-
      merge(T,A,Merged).
