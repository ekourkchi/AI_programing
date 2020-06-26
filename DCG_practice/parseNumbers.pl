/*
?- consult('parseNumbers.pl').



*/


num(N) --> digit(N).
num(N) --> zero(N).
num(N) --> tens(N).
num(N) --> teen(N).
num(N) --> hundred(N).
num(N) --> thousand(N).

num(N) --> tens(N1), digit(N0), {N is N1 + N0}.

num(N) --> digit(N1), hundred(N0), num(N3), {M is N1 * N0}, {N is M + N3}.
num(N) --> hundred(N0), num(N3), {N is N0 + N3}.

num(N) --> digit(N1), thousand(N0), num(N3), {M is N1 * N0}, {N is M + N3}.
num(N) --> thousand(N0), num(N3), {N is N0 + N3}.

zero(0) --> [zero].
zero(0) --> [].

digit(1) --> [one].
digit(2) --> [two].
digit(3) --> [three].
digit(4) --> [four].
digit(5) --> [five].
digit(6) --> [six].
digit(7) --> [seven].
digit(8) --> [eight].
digit(9) --> [nine].

teen(10) --> [ten].
teen(11) --> [eleven].
teen(12) --> [twelve].
teen(13) --> [thirteen].
teen(14) --> [fourteen].
teen(15) --> [fifteen].
teen(16) --> [sixteen].
teen(17) --> [seventeen].
teen(18) --> [eighteen].
teen(19) --> [nineteen].


tens(20) --> [twenty].
tens(30) --> [thirty].
tens(40) --> [forty].
tens(40) --> [fourty].
tens(50) --> [fifty].
tens(60) --> [sixty].
tens(70) --> [seventy].
tens(80) --> [eighty].
tens(90) --> [ninety].

hundred(100) --> [hundred].
thousand(1000) --> [thousand].





