
mathsentence(Ans) --> mathquestion([Equation]), {is(Ans,Equation)}.
mathsentence(Ans) --> mathcommand([Equation]), {is(Ans,Equation)}.

mathcommand(Equation) --> cverb(N1^N2^Equation), number(N1), [with], number(N2).

mathquestion(Eq) --> query, equation(Eq).

equation(Equation) --> number(N1), verb(N1^N2^Equation), number(N2).

query --> [what, is].
query --> [how, much, is].

number(Number) --> {num(NumberWord, Number)}, NumberWord.

cverb(N1^N2^[N1+N2])--> [add].
cverb(N1^N2^[N1-N2]) --> [subtract].
cverb(N1^N2^[N1*N2]) --> [multiply].
cverb(N1^N2^[N1/N2]) --> [divide].

verb(N1^N2^[N1+N2]) --> [plus].
verb(N1^N2^[N1-N2]) --> [minus].
verb(N1^N2^[N1*N2]) --> [times].
verb(N1^N2^[N1/N2]) --> [divided,by].

num([one],1).
num([two],2).
num([three],3).
num([four],4).
num([five],5).
num([six],6).
num([seven],7).
num([eight],8).
num([nine],9).
num([ten],10).
