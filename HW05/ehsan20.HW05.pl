
/*****************************************************
% This code is written by Ehsan Kourkchi
% To do the Assignment 5 ---  ICS361
% Computer Science, University of Hawaii
% November 2015
% Email: ekourkchi@gmail.com
% 
% Feature: Error handling feature has been added.
% 
% To load the program: 
%       consult('ehsan20.HW05.pl').
%
%******************************************************/
% 
%  The code has been developed by Ehsan K. to answer 
%  the assignment 5, and is available in this file: ehsan20.HW05.pl
%  
%  1) All the requested features are covered.
%     - If the answer is positive, the returned answer would be formatted and returned
%     - If the answer is negative or it does not comply with what is available in the database,
%       then the query would be failed. In this case we first make sure that the minimum grammatical 
%       rules are met in the given query.
%     - If the grammar of the query is wrong, then a proper message is returned and the query would 
%       not be further evaluated against the database.
%  1.5) It understands the difference between, an actor, and an actress.
%  2) Extra features are provided for extra points.
%     - User can ask about the release year of a movie
%     - The release year can be also added to the end of each sentence
%     - User can also ask about the relative release time of movies
%  3) The examples of the regular queries and those extra features that are covered in this code are 
%     available in the transcript: ehsan20.HW05.txt
%

/* This is the list of covered movies in our database
Star Trek I:		 The Motion Picture (1979)
Star Trek II:		 The Wrath of Khan (1982)
Star Trek III:	 	 The Search for Spock (1984)
Star Trek IV:		 The Voyage Home (1986)
Star Trek V:		 The Final Frontier (1989)
Star Trek VI:		 The Undiscovered Country (1991)
 
Star Wars I:		 The Phantom Menace (1999)
Star Wars II:		 Attack of the Clones (2002)
Star Wars III:	 	 Revenge of the Sith (2005)
Star Wars IV:		 Star Wars (1977)
Star Wars V:		 The Empire Strikes Back (1980)
Star Wars VI:		 Return of the Jedi (1983)
Star Wars VII:	 	 The Force Awakens (2015)
*/




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  These are the definitions of regular Prolog predicates
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This predicate prints all member of a list, using "format" predicate
printList([]) :- format('~n').
printList([A]) :- format('~w', A), !.
printList([A|T]) :- format('~w ', A), printList(T).


% Checking if the word "right" sits at the end of a list, it fails if it doesn't.
right_end([right]).
right_end([_|T]) :- right_end(T).
   

% True if a movie is released after the year N   
after(Movie, N) :- release_year(Movie, Year), Year > N.  

% True if Movie1 was released after Movie2
after(Movie1, Movie2) :- 
   release_year(Movie1, Year1), release_year(Movie2, Year2), Year1 > Year2.
% True if Movie1 was released N-years after Movie2   
after(Movie1, Movie2, N) :- 
   release_year(Movie1, Year1), release_year(Movie2, Year2), Year1 is Year2 + N.   

   
% True if a movie is released before the year N
before(Movie, N) :- release_year(Movie, Year), Year < N. 
   
% True if Movie1 was released before Movie2
before(Movie1, Movie2) :- 
   release_year(Movie1, Year1), release_year(Movie2, Year2), Year1 < Year2.
% True if Movie1 was released N-years before Movie2
before(Movie1, Movie2, N) :- 
   release_year(Movie1, Year1), release_year(Movie2, Year2), Year2 is Year1 + N.




% IT fails if it's called by other predicates, in the case of having the wrong grammar.
wrong_grammar :- 
   format("I don't get it. Check your grammar! ~n"), !, fail. 
   
/* TOP/1

ARG1 is a sentence represented as a list of atoms (e.g. [is, it, true, that, mark, hamill, acts, in, star, wars, iv]).

TOP/1 will succeed or fail. Either way, it should write out a sensible answer.

*/

% This predicate is used when the sentence starts with "is it true that"
top(Sentence) :-
  yesno(Query, Sentence, []), % This is a call to the DCG.
  Query, % evaluates the query. Succeeds if true, fails if false.
  format("Yes, that's true.").

  
% This predicate is used when the sentence starts with "who"
top(Sentence) :-
 who(Who, Sentence, []), % This is a call to the DCG.
 np(Who, X, []),
 format("The person you're looking for is \""),
 printList(X),
 format("\".~n").
 
 
% This predicate is used when the sentence starts with "what"
top(Sentence) :-
 what(What, Sentence, []), % This is a call to the DCG.
 np(What, X, []),
 format("It is \""),
 printList(X),
 format("\".~n"). 


% This predicate is used when the sentence starts with "when"
top(Sentence) :-
 when(When, Sentence, []), % This is a call to the DCG.
 format(When),
 format(".~n"). 


% first we make sure that "right" comes at the end of the sentence, by using 
% "right_end" predicate. 
top(Sentence) :-
   right_end(Sentence),
   right(Query, Sentence, []),
   Query,
   format("Yes, that's right. ~n").


% This predicate is activated when the sentence starts with "did" 
top(Sentence) :-
   did_root(Query, Sentence, []),
   Query,
   format("Yes. ~n").


% If the "right" does not go at the end of the sentence
% and it does not start with "did", "when", "why", "who" and "is it true that"
% it checks whether the sentence contains right information.
% if not, it will fail.
top(Sentence) :-
   \+ right_end(Sentence),
   sentences(Query, Sentence, []),
   Query,
   format("Sounds right :) ~n").   


% This checks if the sentence is right.
% This predicate was used when I developed the code
sanity(Sentence) :-
   sentences(Query, Sentence, []),
   Query.
   

   
   
   
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the DCG part of this code ....
%
% To avoid any confusion, "Eval" is used when a parameter 
% must be evaluated at some point. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%top([is, it, true, that, mark, hamill, acts, in, star, wars, iv]).
yesno(Eval) --> [is, it, true, that], sentences(Eval).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%top([mark, hamill, acts, in, star, wars, iv, right]).
right(Eval) -->  sentences(Eval), [right].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%top([did, mark, hamill, act, in, star, wars, iv]).
did_root(Eval) --> did(Eval, _).
% When a sentence start with "did', the rest is in
% simple or past form
did(Eval, Year) --> [did], statement(Eval, Year, p).

% statement_ is used when the query should be failed due to the wrong grammar
did(Eval, Year) --> [did], statement_(Eval, Year, s).
did(Eval, Year) --> [did], statement_(Eval, Year, ed).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% top([who, acts, in, star, wars, iv]).
who(Sub) --> [who], tobe_verb(Sub, Eval, who), {Eval}.
who(Sub) --> [who], vp(Sub, Eval, _, s), {Eval}.
who(Sub) --> [who], vp(Sub, Eval, _, ed), {Eval}.

% Since we are dealing with 3rd person verbs, simple present tense does not work
% and it's grammatically wrong
who(Sub) --> [who], vp(Sub, Eval, _, p), {Eval}, !, {wrong_grammar}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

what(Sub) --> [what], tobe_verb(Sub, Eval, what), {Eval}.

% top([what, movie, was, released, in, 1977]).
what(Sub) --> [what, movie, was], when_released(Eval, Sub, Year), [in] , [Year], {Eval}.


% top([what, movie, was, released, after, star, wars, vi]).
what(Sub) --> [what, movie, was, released],  before_after(Eval, Sub, _), {Eval}.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% top([when, did, mark, hamill, act, in, star, wars, vi]).
when(Year) --> [when], did(Eval, Year), {Eval}.

% top([when, was, star, trek, iii, released]).
when(Year) --> [when, was], np(Sub), when_released(Eval, Sub, Year), {Eval}.

when_released(release_year(Sub, Year), Sub, Year) --> [released].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



before_after(Eval, Sub, Obj) --> before_movie(Eval, Sub, Obj).
before_after(Eval, Sub, Obj) --> before_movie(Eval, Sub, Obj, _).
before_after(Eval, Sub, Obj) --> after_movie(Eval, Sub, Obj).
before_after(Eval, Sub, Obj) --> after_movie(Eval, Sub, Obj, _).

before_after(Eval, Sub, _) --> before_movie(Eval, Sub).
before_after(Eval, Sub, _) --> after_movie(Eval, Sub).

before_movie(before(Sub, Obj), Sub, Obj) --> [before], np(Obj).
after_movie(after(Sub, Obj), Sub, Obj) --> [after], np(Obj).

before_movie(before(Movie, N), Movie) --> [before], num(N).
after_movie(after(Movie, N), Movie) --> [after], num(N).


% To handle how many years after/before ?
% Num(N) can handle numbers in both numeric and word forms
before_movie(before(Sub, Obj, N), Sub, Obj, N) --> num(N), [years, before], np(Obj).
after_movie(after(Sub, Obj, N), Sub, Obj, N) --> num(N), [years, after], np(Obj).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% This is the top-level sentence generator ...

% Here, the general form of a sentence is defined
sentences((Eval1,Eval2)) -->   single_sentence(Eval1), rest_sentences(Eval2).

rest_sentences(true) --> [].
rest_sentences(Eval) --> sentences(Eval).

% Multiple sentences should be finished with "and" and a single sentence.
rest_sentences(Eval) --> [and], single_sentence(Eval).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In the case of wrong grammar "statement_" is used, with a couple of other predicates that follows it as below.
statement_(true, _, Tense) --> np(_), vp_(_, _, _, Tense), !, {wrong_grammar}.
vp_(_, _, _, Tense) --> verb2(_, _, _, Tense), np(_), {release_year(_, _)}.
vp_(_, _, _, Tense) --> verb3(_, _, _, Tense), prep(_), {release_year(_, _)}.
vp_(_, _, _, Tense) --> verb3(_, _, _, Tense), np(_), in_movie(_), {release_year(_, _)}.


statement(Eval, Year, Tense)  --> np(Sub), vp(Sub, Eval, Year, Tense).

%% A simple 3-rd person sentence
%% It's either in 3rd person, or simple-past tense.
single_sentence(Eval) --> statement(Eval, _, s).
single_sentence(Eval) --> statement(Eval, _, ed).


% cannot be in simple-present form
single_sentence(true) --> statement_(true, _, p).  % in the case of wrong grammar, no evaluation is needed.
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Handling the title of a movie
% top([the, title, of, star, wars, iv, is, a, new, hope]).
single_sentence(Eval) --> [the, title, of], np(Movie), [is], is_clause_2(Movie, Eval).

% Handling questions about the release year of a movie
% top([star, wars, iv, was, released, in, 1977]).
single_sentence(Eval) --> np(Sub), was_released(Eval, Sub).

% top([star, wars, iv, was, released, six, years, before, star, wars, vi, right]).
single_sentence(Eval) --> np(Sub), [was, released],  before_after(Eval, Sub, _).


% noun-phrase + a to-be verb
single_sentence(Eval) --> np(Sub), tobe_verb(Sub, Eval, _).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
was_released(Eval, Sub) --> [was, released], in_year(Eval, Sub, _).

in_year(release_year(Sub, Year), Sub, Year) --> [in, Year].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% When we use a "to be" verb in a sentence, we 
% can ask questions with what, why, when, who.
% So, in order to specify how to ask questions,
% we pass a variable to "is_clause" to specify how
% to ask a question when we have a specific structure.


tobe_verb(Sub, Eval, Q) --> [is], is_clause(Sub, Eval, Q).

% We ask about the subject with "who".
is_clause(Sub, director(Sub), who) --> [a, director].
is_clause(Sub, director(Sub), who) --> [an, director], !, {wrong_grammar}.

is_clause(Sub, actor(Sub), who) --> [an, actor].
is_clause(_, true, who) --> [a, actor], !, {wrong_grammar}.  % in the case of wrong grammar, no evaluation is needed.

is_clause(Sub, actress(Sub), who) --> [an, actress].
is_clause(_, true, who) --> [a, actress], !, {wrong_grammar}.  % in the case of wrong grammar, no evaluation is needed.

is_clause(Sub, acts_in(Sub, Movie), who) --> [an, actor], prep(Movie), {actor(Sub)}.
is_clause(Sub, true, who) --> [a, actor], prep(_), {actor(Sub)}, !, {wrong_grammar}.  % in the case of wrong grammar, no evaluation is needed.

is_clause(Sub, acts_in(Sub, Movie), who) --> [an, actress], prep(Movie), {actress(Sub)}.
is_clause(Sub, true, who) --> [a, actress], prep(_), {actress(Sub)}, !, {wrong_grammar}.  % in the case of wrong grammar, no evaluation is needed.


% top([mark, hamill, is, the, actor, for, luke, skywalker, in, star, wars, iv]).
is_clause(Sub, acts_as(Sub, Character), who) --> [the, actor, for], np(Character).

% If the name of a movie is mentioned, then we need to make more evaluations
is_clause(Sub, acts_as(Sub, Character), who) --> [the, actor, for], np(Character), prep(Movie), {acts_in(Sub, Movie)}.
% The same would be applied, if the release year is mentioned.
is_clause(Sub, acts_as(Sub, Character), who) --> [the, actor, for], np(Character), in_year(Year), {(acts_in(Sub, Movie), release_year(Movie, Year))}.

is_clause(Sub, director_of(Sub, Movie), who) --> [the, director, of], np(Movie).


is_clause(Character, acts_as(Sub, Character), who) --> [the, character, of], np(Sub).

% If the name of a movie is mentioned, then we need to make more evaluations
is_clause(Character, acts_as(Sub, Character), who) --> [the, character, of], np(Sub), prep(Movie), {acts_in(Sub, Movie)}.


% We ask about the subject with "what".
is_clause(Sub, title_of(Sub, Movie), what) --> [the, title, of], np(Movie).
%top([a, new, hope, is, the, title, of, star, wars, iv]).


is_clause_2(Movie, title_of(Sub, Movie)) --> np(Sub).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% If the year is NOT mentioned at the end of each sentence, the verb can be either in present or past tense form.

% top([william, shatner, directed, star, trek, v]).
vp(Sub, Eval, Year, Tense) --> verb2(Sub, Obj, Eval, Tense), np(Obj), {release_year(Obj, Year)}.

% top([who, acted, in, star, wars, iv, in, 1977]).
vp(Sub, Eval, Year, Tense) --> verb3(Sub, Prep, Eval, Tense), prep(Prep), {release_year(Prep, Year)}.

% top([william, shatner, plays, captain, kirk, in, star, trek, v]).
vp(Sub, Eval, Year, Tense) --> verb3(Sub, Prep, Eval, Tense), np(Obj), {acts_as(Sub, Obj)}, in_movie(Prep), {release_year(Prep, Year)}.


% If the year is mentioned at the end of each sentence, the verb should be in past tense form.
vp(Sub, Eval, Year, ed) --> verb2(Sub, Obj, Eval, ed), np(Obj), in_year(Year), {release_year(Obj, Year)}.
vp(Sub, Eval, Year, ed) --> verb3(Sub, Prep, Eval, ed), prep(Prep), in_year(Year), {release_year(Prep, Year)}.
vp(Sub, Eval, Year, ed) --> verb3(Sub, Prep, Eval, ed), np(Obj), {acts_as(Sub, Obj)}, in_movie(Prep), in_year(Year), {release_year(Prep, Year)}.


%%%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "p" stands for "present simple tense"
% "s" stands for "present simple, 3rd person"
% "ed" stands for "past tense"

verb2(X, Y, director_of(X, Y), p)	 --> [direct].
verb2(X, Y, director_of(X, Y), s)	 --> [directs].
verb2(X, Y, director_of(X, Y), ed)	 --> [directed].  
   
% X acts in the movie Y
verb3(X, Y, acts_in(X, Y), p)	 --> [act].
verb3(X, Y, acts_in(X, Y), s)	 --> [acts].
verb3(X, Y, acts_in(X, Y), ed)	 --> [acted].

% X plays in the movie Y
verb3(X, Y, acts_in(X, Y), p)	 --> [play].
verb3(X, Y, acts_in(X, Y), s)	 --> [plays].
verb3(X, Y, acts_in(X, Y), ed)	 --> [played].





%%%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fundamental definitions

np(Sem) --> proper_noun(Sem).

% can either be blank
in_movie(_) --> [].
% or contains the production year
in_movie(Movie) --> [in], np(Movie).

in_year(Year) --> [in], [Year].

% simple prepositional form with "in"
prep(Sem) --> [in], np(Sem).
%%%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% the following section, handles the word-numbers.
% also if an integer number is written in a sentence, it easily returns the
% integer number itself

% This code is first written for the online class discussion on Laulilma:
% https://laulima.hawaii.edu/portal/tool/9353813a-2b83-476f-a79a-a70234fb0aba/posts/list/968182.page

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num(N) --> [N], {integer(N)}.

num(N) --> digit(N).
num(N) --> zero(N).
num(N) --> tens(N).
num(N) --> teen(N).
num(N) --> hundred(N).
num(N) --> thousand(N).

% handling numbers <99
num(N) --> tens(N1), digit(N0), {N is N1 + N0}.

% handling numbers >199 and <999
num(N) --> digit(N1), hundred(N0), num(N3), {M is N1 * N0}, {N is M + N3}.

% handling numbers >99 and <199
num(N) --> hundred(N0), num(N3), {N is N0 + N3}.

% handling numbers >999 and <1999
num(N) --> thousand(N0), num(N3), {N is N0 + N3}.

% handling numbers >1999 and <9999
num(N) --> digit(N1), thousand(N0), num(N3), {M is N1 * N0}, {N is M + N3}.


zero(0) --> [zero].

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* DATABASE. 
This database contain the following movies. 
All 10 actors/actresses are includes, taken from IMDb web-page (http://www.imdb.com).

*/
% Star Trek I:		 The Motion Picture (1979)
% Star Trek II:		 The Wrath of Khan (1982)
% Star Trek III:	 The Search for Spock (1984)
% Star Trek IV:		 The Voyage Home (1986)
% Star Trek V:		 The Final Frontier (1989)
% Star Trek VI:		 The Undiscovered Country (1991)
 
% Star Wars I:		 The Phantom Menace (1999)
% Star Wars II:		 Attack of the Clones (2002)
% Star Wars III:	 Revenge of the Sith (2005)
% Star Wars IV:		 Star Wars (1977)
% Star Wars V:		 The Empire Strikes Back (1980)
% Star Wars VI:		 Return of the Jedi (1983)
% Star Wars VII:	 The Force Awakens (2015)



title_of(phantom_menace, star_wars1).
title_of(attack_clones, star_wars2).
title_of(revenge_sith, star_wars3).
title_of(a_new_hope, star_wars4).
title_of(empire_strikes_back, star_wars5).
title_of(return_jedi, star_wars6).
title_of(force_awakens, star_wars7).

title_of(motion_picture, star_trek1).
title_of(wrath_khan, star_trek2).
title_of(search_spock, star_trek3).
title_of(voyage_home, star_trek4).
title_of(final_frontier, star_trek5).
title_of(undiscover_country, star_trek6).



release_year(star_wars1, 1999).
release_year(star_wars2, 2002).
release_year(star_wars3, 2005).
release_year(star_wars4, 1977).
release_year(star_wars5, 1980).
release_year(star_wars6, 1983).
release_year(star_wars7, 2015).

release_year(star_trek1, 1979).
release_year(star_trek2, 1982).
release_year(star_trek3, 1984).
release_year(star_trek4, 1986).
release_year(star_trek5, 1989).
release_year(star_trek6, 1991).



director_of(george_lucas, star_wars1).
director_of(george_lucas, star_wars2).
director_of(george_lucas, star_wars3).
director_of(irvin_kershner, star_wars4).
director_of(irvin_kershner, star_wars5).
director_of(richard_marquand, star_wars6).
director_of(jj_abrams, star_wars7).

director_of(robert_wise, star_trek1).
director_of(nicholas_meyer, star_trek2).
director_of(leonard_nimoy, star_trek3).
director_of(leonard_nimoy, star_trek4).
director_of(william_shatner, star_trek5).
director_of(nicholas_meyer, star_trek6).


director(irvin_kershner).
director(george_lucas).
director(richard_marquand).
director(jj_abrams).
director(robert_wise).
director(nicholas_meyer).
director(leonard_nimoy).
director(william_shatner).

actress(carrie_fisher).
actress(natalie_portman).
actress(pernilla_august).
actress(keisha_hughes).
actress(daisy_ridley).
actress(billie_lourd).
actress(gwendoline_christie).
actress(majel_barrett).
actress(nichelle_nichols).
actress(persis_khambatta).
actress(grace_lee_whitney).
actress(bibi_besch).
actress(kirstie_alley).
actress(robin_curtis).
actress(jane_wyatt).
actress(catherine_hicks).
actress(cynthia_gouw).
actress(kim_cattrall).



actor(mark_hamill).
actor(harrison_ford).
actor(peter_cushing).
actor(alec_guinness).
actor(anthony_daniels).
actor(kenny_baker).
actor(peter_mayhew).
actor(david_prowse).
actor(phil_brown).
actor(billy_williams).
actor(anthony_daniels).
actor(kenny_baker).
actor(frank_oz).
actor(sebastian_shaw).
actor(ian_mcdiarmid).
actor(liam_neeson).
actor(jake_lloyd).
actor(oliver_ford_davies).
actor(hugh_quarshie).
actor(ahmed_best).
actor(hayden_christensen).
actor(christopher_lee).
actor(samuel_jackson).
actor(temuera_morrison).
actor(jimmy_smits).
actor(adam_driver).
actor(domhnall_gleeson).
actor(oscar_isaac).
actor(simon_pegg).
actor(john_boyega).
actor(andy_serkis).
actor(william_shatner).
actor(leonard_nimoy).
actor(deForest_kelley).
actor(james_doohan).
actor(george_takei).
actor(walter_koenig).
actor(stephen_collins).
actor(mark_lenard).
actor(merritt_butrick).
actor(paul_winfield).
actor(ricardo_montalban).
actor(phil_morris).
actor(scott_mcGinnis).
actor(robert_hooks).
actor(mark_lenard).
actor(robert_ellenstein).
actor(david_warner).
actor(laurence_luckinbill).
actor(charles_cooper).
actor(todd_bryant).
actor(brock_peters).
actor(leon_russom).


acts_in(mark_hamill, star_wars4).
acts_in(harrison_ford, star_wars4).
acts_in(carrie_fisher, star_wars4).
acts_in(peter_cushing, star_wars4).
acts_in(alec_guinness, star_wars4).
acts_in(anthony_daniels, star_wars4).
acts_in(kenny_baker, star_wars4).
acts_in(peter_mayhew, star_wars4).
acts_in(david_prowse, star_wars4).
acts_in(phil_brown, star_wars4).
acts_in(mark_hamill, star_wars5).
acts_in(harrison_ford, star_wars5).
acts_in(carrie_fisher, star_wars5).
acts_in(billy_williams, star_wars5).
acts_in(anthony_daniels, star_wars5).
acts_in(david_prowse, star_wars5).
acts_in(peter_mayhew, star_wars5).
acts_in(kenny_baker, star_wars5).
acts_in(alec_guinness, star_wars5).
acts_in(frank_oz, star_wars5).
acts_in(mark_hamill, star_wars6).
acts_in(harrison_ford, star_wars6).
acts_in(carrie_fisher, star_wars6).
acts_in(billy_williams, star_wars6).
acts_in(anthony_daniels, star_wars6).
acts_in(peter_mayhew, star_wars6).
acts_in(sebastian_shaw, star_wars6).
acts_in(ian_mcdiarmid, star_wars6).
acts_in(kenny_baker, star_wars6).
acts_in(frank_oz, star_wars6).
acts_in(david_prowse, star_wars6).
acts_in(alec_guinness, star_wars6).
acts_in(kenny_baker, star_wars6).
acts_in(natalie_portman, star_wars1).
acts_in(ewan_mcGregor, star_wars1).
acts_in(jake_lloyd, star_wars1).
acts_in(ian_mcdiarmid, star_wars1).
acts_in(pernilla_august, star_wars1).
acts_in(oliver_ford_davies, star_wars1).
acts_in(hugh_quarshie, star_wars1).
acts_in(ahmed_best, star_wars1).
acts_in(anthony_daniels, star_wars1).
acts_in(kenny_baker, star_wars1).
acts_in(frank_oz, star_wars1).
acts_in(ewan_mcGregor, star_wars2).
acts_in(natalie_portman, star_wars2).
acts_in(hayden_christensen, star_wars2).
acts_in(christopher_lee, star_wars2).
acts_in(samuel_jackson, star_wars2).
acts_in(frank_oz, star_wars2). 
acts_in(ian_mcdiarmid,  star_wars2).
acts_in(pernilla_august, star_wars2).
acts_in(temuera_morrison, star_wars2).
acts_in(jimmy_smits, star_wars2).
acts_in(ewan_mcGregor, star_wars3).
acts_in(natalie_portman, star_wars3).
acts_in(hayden_christensen, star_wars3).
acts_in(ian_mcdiarmid,  star_wars3).
acts_in(samuel_jackson, star_wars3).
acts_in(jimmy_smits, star_wars3).
acts_in(frank_oz, star_wars3). 
acts_in(anthony_daniels, star_wars3).
acts_in(christopher_lee, star_wars3).
acts_in(keisha_hughes, star_wars3).
acts_in(daisy_ridley, star_wars7).
acts_in(carrie_fisher, star_wars7).
acts_in(mark_hamill, star_wars7).
acts_in(adam_driver, star_wars7).
acts_in(harrison_ford, star_wars7).
acts_in(billie_lourd, star_wars7).
acts_in(domhnall_gleeson, star_wars7).
acts_in(gwendoline_christie, star_wars7).
acts_in(oscar_isaac,  star_wars7).
acts_in(simon_pegg, star_wars7).
acts_in(peter_mayhew, star_wars7).
acts_in(john_boyega, star_wars7).
acts_in(andy_serkis,  star_wars7).
acts_in(kenny_baker, star_wars7).
acts_in(william_shatner, star_trek1).
acts_in(leonard_nimoy, star_trek1).
acts_in(deForest_kelley, star_trek1).
acts_in(james_doohan, star_trek1).
acts_in(george_takei, star_trek1).
acts_in(majel_barrett, star_trek1).
acts_in(walter_koenig, star_trek1).
acts_in(nichelle_nichols, star_trek1).
acts_in(persis_khambatta, star_trek1).
acts_in(stephen_collins, star_trek1).
acts_in(grace_lee_whitney, star_trek1).
acts_in(mark_lenard, star_trek1).
acts_in(william_shatner, star_trek2).
acts_in(leonard_nimoy, star_trek2).
acts_in(deForest_kelley, star_trek2).
acts_in(james_doohan, star_trek2).
acts_in(walter_koenig, star_trek2).
acts_in(george_takei, star_trek2).
acts_in(nichelle_nichols, star_trek2).
acts_in(bibi_besch, star_trek2).
acts_in(merritt_butrick, star_trek2).
acts_in(paul_winfield, star_trek2).
acts_in(kirstie_alley, star_trek2).
acts_in(ricardo_montalban, star_trek2).
acts_in(william_shatner, star_trek3).
acts_in(leonard_nimoy, star_trek3).
acts_in(deForest_kelley, star_trek3).
acts_in(james_doohan, star_trek3).
acts_in(walter_koenig, star_trek3).
acts_in(george_takei, star_trek3).
acts_in(nichelle_nichols, star_trek3).
acts_in(robin_curtis, star_trek3).
acts_in(merritt_butrick, star_trek3).
acts_in(phil_morris, star_trek3).
acts_in(scott_mcGinnis, star_trek3).
acts_in(robert_hooks, star_trek3).
acts_in(william_shatner, star_trek4).
acts_in(leonard_nimoy, star_trek4).
acts_in(deForest_kelley, star_trek4).
acts_in(james_doohan, star_trek4).
acts_in(george_takei, star_trek4).
acts_in(walter_koenig, star_trek4).
acts_in(nichelle_nichols, star_trek4).
acts_in(jane_wyatt, star_trek4).
acts_in(catherine_hicks, star_trek4).
acts_in(mark_lenard, star_trek4).
acts_in(robin_curtis, star_trek4).
acts_in(robert_ellenstein, star_trek4).
acts_in(william_shatner, star_trek5).
acts_in(leonard_nimoy, star_trek5).
acts_in(deForest_kelley, star_trek5).
acts_in(james_doohan, star_trek5).
acts_in(walter_koenig, star_trek5).
acts_in(nichelle_nichols, star_trek5).
acts_in(george_takei, star_trek5).
acts_in(david_warner, star_trek5).
acts_in(laurence_luckinbill, star_trek5).
acts_in(charles_cooper, star_trek5).
acts_in(cynthia_gouw, star_trek5).
acts_in(todd_bryant, star_trek5).
acts_in(william_shatner, star_trek6).
acts_in(leonard_nimoy, star_trek6).
acts_in(deForest_kelley, star_trek6).
acts_in(james_doohan, star_trek6).
acts_in(walter_koenig, star_trek6).
acts_in(nichelle_nichols, star_trek6).
acts_in(george_takei, star_trek6).
acts_in(kim_cattrall, star_trek6).
acts_in(mark_lenard, star_trek6).
acts_in(grace_lee_whitney, star_trek6).
acts_in(brock_peters, star_trek6).
acts_in(leon_russom, star_trek6).



acts_as(mark_hamill, luke_skywalker).
acts_as(harrison_ford, han_solo).
acts_as(carrie_fisher, princess_leia).
acts_as(peter_cushing, grand_moff_tarkin).
acts_as(alec_guinness, obi_wan).
acts_as(anthony_daniels, c_3PO).
acts_as(kenny_baker, r2_D2).
acts_as(peter_mayhew, chewbacca).
acts_as(david_prowse, darth_vader).
acts_as(phil_brown, uncle_owen).
acts_as(billy_williams, lando_calrissian).
acts_as(frank_oz, yoda).
acts_as(sebastian_shaw, anakin_skywalker).
acts_as(ian_mcdiarmid, the_emperor).
acts_as(kenny_baker, paploo).
acts_as(ewan_mcGregor, obi_wan).
acts_as(natalie_portman, queen_amidala).
acts_as(natalie_portman, padme).
acts_as(jake_lloyd, anakin_skywalker).
acts_as(ian_mcdiarmid, senator_palpatine).
acts_as(pernilla_august, shmi_skywalker).
acts_as(oliver_ford_davies, sio_bibble).
acts_as(hugh_quarshie, captain_panaka).
acts_as(ahmed_best, jar_jar).
acts_as(hayden_christensen, anakin_skywalker).
acts_as(christopher_lee, count_dooku).
acts_as(christopher_lee, darth_tyranus).
acts_as(samuel_jackson, mace_windu).
acts_as(ian_mcdiarmid, palpatine).
acts_as(temuera_morrison, jango_fett).
acts_as(jimmy_smits, senator_bail).
acts_as(keisha_hughes, queen_of_naboo).
acts_as(daisy_ridley, rey).
acts_as(adam_driver, kylo_ren).
acts_as(billie_lourd, something).
acts_as(domhnall_gleeson, general_hux).
acts_as(gwendoline_christie, captain_phasma).
acts_as(oscar_isaac, poe_dameron).
acts_as(simon_pegg, something).
acts_as(john_boyega, finn).
acts_as(andy_serkis, leader_snoke).
acts_as(william_shatner, captain_kirk).
acts_as(leonard_nimoy, spock).
acts_as(deForest_kelley, dr_mcCoy).
acts_as(james_doohan, scotty).
acts_as(george_takei, sulu).
acts_as(majel_barrett, dr_chapel).
acts_as(walter_koenig, chekov).
acts_as(nichelle_nichols, uhura).
acts_as(persis_khambatta, ilia).
acts_as(stephen_collins, decker).
acts_as(grace_lee_whitney, janice_rand).
acts_as(mark_lenard, klingon_captain).
acts_as(bibi_besch, carol).
acts_as(merritt_butrick, david).
acts_as(paul_winfield, terrell).
acts_as(kirstie_alley, saavik).
acts_as(ricardo_montalban, khan).
acts_as(robin_curtis, saavik).
acts_as(phil_morris, trainee_foster).
acts_as(scott_mcGinnis, mr_adventure).
acts_as(robert_hooks, admiral_morrow).
acts_as(jane_wyatt, amanda).
acts_as(catherine_hicks, gillian).
acts_as(mark_lenard, sarek).
acts_as(robert_ellenstein, feder_president).
acts_as(david_warner, john_talbot).
acts_as(laurence_luckinbill, sybok).
acts_as(charles_cooper, korrd).
acts_as(cynthia_gouw, caithlin_dar).
acts_as(todd_bryant, captain_klaa).
acts_as(kim_cattrall, lt_valeris).
acts_as(grace_lee_whitney, comm_officer).
acts_as(brock_peters, admiral_cartwright).
acts_as(leon_russom, chief_command).




proper_noun(star_wars4)		 --> [star, wars, iv].
proper_noun(a_new_hope)		 --> [a, new, hope].
proper_noun(irvin_kershner)	 --> [irvin, kershner].
proper_noun(mark_hamill)	 --> [mark, hamill].
proper_noun(luke_skywalker)	 --> [luke, skywalker].
proper_noun(harrison_ford)	 --> [harrison, ford].
proper_noun(han_solo)		 --> [han, solo].
proper_noun(carrie_fisher)	 --> [carrie, fisher].
proper_noun(princess_leia)	 --> [princess, leia, organa].
proper_noun(peter_cushing)	 --> [peter, cushing].
proper_noun(grand_moff_tarkin)	 --> [grand, moff, tarkin].
proper_noun(alec_guinness)	 --> [alec, guinness].
proper_noun(obi_wan)		 --> [obi-wan, kenobi].
proper_noun(anthony_daniels)	 --> [anthony, daniels].
proper_noun(c_3PO)		 --> [c_3PO].
proper_noun(kenny_baker)	 --> [kenny, baker].
proper_noun(r2_D2)		 --> [r2_D2].
proper_noun(peter_mayhew)	 --> [peter, mayhew].
proper_noun(chewbacca)		 --> [chewbacca].
proper_noun(david_prowse)	 --> [david, prowse].
proper_noun(darth_vader)	 --> [darth, vader].
proper_noun(phil_brown)		 --> [phil, brown].
proper_noun(uncle_owen)		 --> [uncle, owen].
proper_noun(star_wars5)		 --> [star, wars, v].
proper_noun(empire_strikes_back) --> [the, empire, strikes, back].
proper_noun(billy_williams)	 --> [billy, dee, williams].
proper_noun(lando_calrissian)	 --> [lando, calrissian].
proper_noun(frank_oz)		 --> [frank, oz].
proper_noun(yoda)		 --> [yoda].
proper_noun(richard_marquand)	 --> [richard, marquand].
proper_noun(star_wars6)		 --> [star, wars, vi].
proper_noun(return_jedi)	 --> [return, of, the, jedi].
proper_noun(sebastian_shaw)	 --> [sebastian, shaw].
proper_noun(anakin_skywalker)	 --> [anakin, skywalker].
proper_noun(the_emperor)	 --> [the, emperor].
proper_noun(ian_mcdiarmid)	 --> [ian, mcDiarmid].
proper_noun(paploo)		 --> [paploo].
proper_noun(george_lucas)	 --> [george, lucas].
proper_noun(star_wars1)		 --> [star, wars, i].
proper_noun(phantom_menace)	 --> [the, phantom, menace].
proper_noun(liam_neeson)	 --> [liam, neeson].
proper_noun(qui-gon)		 --> [qui-gon, jinn].
proper_noun(ewan_mcGregor)	 --> [ewan, mcGregor].
proper_noun(natalie_portman)	 --> [natalie, portman].
proper_noun(queen_amidala)	 --> [queen, amidala].
proper_noun(padme)		 --> [padme].
proper_noun(jake_lloyd)		 --> [jake, lloyd].
proper_noun(senator_palpatine)	 --> [senator, palpatine].
proper_noun(pernilla_august)	 --> [pernilla, august].
proper_noun(shmi_skywalker)	 --> [shmi, skywalker].
proper_noun(oliver_ford_davies)	 --> [oliver, ford, davies].
proper_noun(sio_bibble)		 --> [sio, bibble].
proper_noun(hugh_quarshie)	 --> [hugh, quarshie].
proper_noun(captain_panaka)	 --> [captain, panaka].
proper_noun(ahmed_best)		 --> [ahmed, best].
proper_noun(jar_jar)		 --> [jar, jar, binks].
proper_noun(star_wars2)		 --> [star, wars, ii].
proper_noun(attack_clones)	 --> [attack, of, the, clones].
proper_noun(hayden_christensen)	 --> [hayden, christensen].
proper_noun(christopher_lee)	 --> [christopher, lee].
proper_noun(count_dooku)	 --> [count, dooku].
proper_noun(darth_tyranus)	 --> [darth, tyranus].
proper_noun(samuel_jackson)	 --> [samuel, jackson].
proper_noun(mace_windu)		 --> [mace, windu].
proper_noun(palpatine) 		 --> [supreme, chancellor, palpatine].
proper_noun(temuera_morrison)	 --> [temuera, morrison].
proper_noun(jango_fett)		 --> [jango, fett].
proper_noun(jimmy_smits)	 --> [jimmy, smits].
proper_noun(senator_bail)	 --> [senator, bail, organa].
proper_noun(star_wars3)		 --> [star, wars, iii].
proper_noun(revenge_sith)	 --> [revenge, of, the, sith].
proper_noun(keisha_hughes)	 --> [keisha, castle-hughes].
proper_noun(queen_of_naboo)	 --> [queen, of, naboo].
proper_noun(star_wars7)		 --> [star, wars, vii].
proper_noun(force_awakens)	 --> [the, force, awakens].
proper_noun(jj_abrams)		 --> [jj, abrams].
proper_noun(daisy_ridley)	 --> [daisy, ridley].
proper_noun(rey)		 --> [rey].
proper_noun(adam_driver)	 --> [adam, driver].
proper_noun(kylo_ren)		 --> [kylo, ren].
proper_noun(billie_lourd)	 --> [billie, lourd].
proper_noun(something)		 --> [something].
proper_noun(domhnall_gleeson)	 --> [domhnall, gleeson].
proper_noun(general_hux)	 --> [general, hux].
proper_noun(gwendoline_christie) --> [gwendoline, christie].
proper_noun(captain_phasma)	 --> [captain, phasma].
proper_noun(oscar_isaac)	 --> [oscar, isaac].
proper_noun(poe_dameron)	 --> [poe, dameron].
proper_noun(simon_pegg)		 --> [simon, pegg].
proper_noun(john_boyega)	 --> [john, boyega].
proper_noun(finn)		 --> [finn].
proper_noun(andy_serkis)	 --> [andy, serkis].
proper_noun(leader_snoke)	 --> [supreme, leader, snoke].
proper_noun(motion_picture)	 --> [the, motion, picture].
proper_noun(star_trek1)		 --> [star, trek, i].
proper_noun(robert_wise)	 --> [robert, wise].
proper_noun(william_shatner)	 --> [william, shatner].
proper_noun(captain_kirk)	 --> [captain, kirk].
proper_noun(leonard_nimoy)	 --> [leonard, nimoy].
proper_noun(spock)		 --> [spock].
proper_noun(deForest_kelley)	 --> [deForest, kelley].
proper_noun(dr_mcCoy)		 --> [dr, mcCoy].
proper_noun(james_doohan)	 --> [james, doohan].
proper_noun(scotty)		 --> [scotty].
proper_noun(george_takei)	 --> [george, takei].
proper_noun(sulu)		 --> [sulu].
proper_noun(majel_barrett)	 --> [majel, barrett].
proper_noun(dr_chapel)		 --> [dr, chapel].
proper_noun(walter_koenig)	 --> [walter, koenig].
proper_noun(chekov)		 --> [chekov].
proper_noun(nichelle_nichols)	 --> [nichelle, nichols].
proper_noun(uhura)		 --> [uhura].
proper_noun(persis_khambatta)	 --> [persis, khambatta].
proper_noun(ilia)		 --> [ilia].
proper_noun(stephen_collins)	 --> [stephen, collins].
proper_noun(decker)		 --> [decker].
proper_noun(grace_lee_whitney)	 --> [grace, lee, whitney].
proper_noun(janice_rand)	 --> [janice, rand].
proper_noun(mark_lenard)	 --> [mark, lenard].
proper_noun(klingon_captain)	 --> [klingon, captain].
proper_noun(wrath_khan)		 --> [the, wrath, of, khan].
proper_noun(star_trek2)		 --> [star, trek, ii].
proper_noun(nicholas_meyer)	 --> [nicholas, meyer].
proper_noun(bibi_besch)		 --> [bibi, besch].
proper_noun(carol)		 --> [carol].
proper_noun(merritt_butrick)	 --> [merritt, butrick].
proper_noun(david)		 --> [david].
proper_noun(paul_winfield)	 --> [paul, winfield].
proper_noun(terrell)		 --> [terrell].
proper_noun(kirstie_alley)	 --> [kirstie, alley].
proper_noun(saavik)		 --> [saavik].
proper_noun(ricardo_montalban)	 --> [ricardo, montalban].
proper_noun(khan)		 --> [khan].
proper_noun(search_spock)	 --> [the, search, for, spock].
proper_noun(star_trek3)		 --> [star, trek, iii].
proper_noun(robin_curtis)	 --> [robin, curtis].
proper_noun(phil_morris)	 --> [phil, morris].
proper_noun(trainee_foster)	 --> [trainee, foster].
proper_noun(scott_mcGinnis)	 --> [scott, mcGinnis].
proper_noun(mr_adventure)	 --> [mr, adventure].
proper_noun(robert_hooks)	 --> [robert, hooks].
proper_noun(admiral_morrow)	 --> [admiral, morrow].
proper_noun(voyage_home)	 --> [the, voyage, home].
proper_noun(star_trek4)		 --> [star, trek, iv].
proper_noun(jane_wyatt)		 --> [jane, wyatt]. 
proper_noun(amanda)		 --> [amanda]. 
proper_noun(catherine_hicks)	 --> [catherine, hicks]. 
proper_noun(gillian)		 --> [gillian]. 
proper_noun(mark_lenard)	 --> [mark, lenard]. 
proper_noun(sarek)		 --> [sarek]. 
proper_noun(robert_ellenstein)	 --> [robert, ellenstein]. 
proper_noun(feder_president)	 --> [federation, council, president]. 
proper_noun(final_frontier)	 --> [the, final, frontier].
proper_noun(star_trek5)		 --> [star, trek, v].
proper_noun(david_warner)	 --> [david, warner].
proper_noun(john_talbot)	 --> [st, john, talbot].
proper_noun(laurence_luckinbill) --> [laurence, luckinbill].
proper_noun(sybok)		 --> [sybok].
proper_noun(charles_cooper)	 --> [charles, cooper].
proper_noun(korrd)		 --> [korrd].
proper_noun(cynthia_gouw)	 --> [cynthia, gouw].
proper_noun(caithlin_dar)	 --> [caithlin, dar].
proper_noun(todd_bryant)	 --> [todd, bryant].
proper_noun(captain_klaa)	 --> [captain, klaa].
proper_noun(undiscover_country)	 --> [the, undiscovered, country].
proper_noun(star_trek6)		 --> [star, trek, vi].
proper_noun(kim_cattrall)	 --> [kim, cattrall].
proper_noun(lt_valeris)		 --> [lt, valeris].
proper_noun(comm_officer)	 --> [excelsior, communications, officer].
proper_noun(brock_peters)	 --> [brock, peters].
proper_noun(admiral_cartwright)	 --> [admiral, cartwright].
proper_noun(leon_russom)	 --> [leon, russom].
proper_noun(chief_command)	 --> [chief, in, command].



%%% END of Data-Base %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%















