%% DCG

sentence --> noun_phrase, verb_phrase.
noun_phrase --> det, noun.
noun_phrase --> det, adj, noun.
verb_phrase --> verb, noun_phrase.
noun --> [dog].
noun --> [tail].
verb --> [has].
adj --> [big].
adj --> [fluffy].
det --> [the].
det --> [a].


%% sentence(X,[]). to generate
%% sentence([the, dog, has, a, fluffy, tail],[]). to parse

