% The Matching Problem

% Prolog programming can be so romantic! In this exercise you will help five men and women to find their one and true loves - well, maybe.

% The following problem is a special case of matching of bipartite graphs. I recommend that you do some online research to get a clue on how to tackle this problem. In our case, we've got five males, Arthur, Bob, Charles, Dirk and Ephraim, and five females, Anna, Beatrix, Claire, Deborah and Emily. All of them assigned ranks to all members of the opposite sex and should get married according to those ranks. Now someone is said to be living in a stable marriage if there is no member of the opposite sex such that both would rather have each other than their current partners (and the same condition holds for that someone's partner).

% (a) Your first task is to implement marry/5 that marries all individuals such that all marriages are stable.

% (b) Afterwards discuss your program addressing the issue of 'gender optimality / pessimality ': does your algorithm assign higher-ranked partners to one sex than the other? And does the position of a person in the ranking array affect the rank of their partner? How can this problem be circumvented? You can either discuss this theoretically by formal proof or empirically my analysing the mean assigned ranks and standard deviations for varying orderings and rankings.

% HINT: You will find loads of literature about this problem -- use it! But don't forget to cite where your inspiration and algorithms come from, or else it would be plagiarism.

maleRanks([[1,2,3,4,5],
           [4,1,2,5,3],
           [1,2,4,3,5],
           [2,5,4,1,3],
           [5,4,1,2,3]]).

femaleRanks([[3,4,1,5,2],
           [4,2,5,3,1],
           [3,4,1,2,5],
           [5,2,4,3,1],
           [3,2,4,5,1]]).
         
males([arthur, bob, charles, dirk, ephraim]).
females([anna, beatrix, claire, deborah, emily]).

% rank(?Name, ?Name, ?Rank)
% Used to retrieve the rank of the first Individual towards the other.
rank(Male, Female, Rank) :-
    males(Males), females(Females),
    nth0(NM, Males, Male),
    nth0(NF, Females, Female),
    maleRanks(Ranks),
    nth0(NM, Ranks, Row),
    nth0(NF, Row, Rank).

rank(Female, Male, Rank) :-
    males(Males), females(Females),
    nth0(NM, Males, Male),
    nth0(NF, Females, Female),
    femaleRanks(Ranks),
    nth0(NF, Ranks, Row),
    nth0(NM, Row, Rank).

% marry([-Couple1, -Couple2, -Couple3, -Couple4, -Couple5])
% Marries all individuals to heterosexual stable monogamous marriages, i.e. Couple1 = [arthur, deborah]
% Sounds like petit burgoise, but everything else would make the problem much more complex ;-)
marry([Couple1, Couple2, Couple3, Couple4, Couple5]) :-
