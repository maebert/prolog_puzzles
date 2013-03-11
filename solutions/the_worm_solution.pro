%!bp -g "['the_worm_solution.pro']"
%
% @author       Manuel Ebert
% @description  Solution to the Worm problem
% @system       b-prolog

:- include('network.pl').

% Goal: infect "feodosia"
goalp(nagatayuji).

% A simple predicate for testing
s(X) :- node(X,_,_), search(X,goalp,expand,'breadth-first',Path), write2(Path).

%s(X) :- search(X,goalp,expand,'breadth-first',Path), write2(Path).

write2([]) :- nl,nl.
write2([Node | R]) :-
    write(Node),write('('),node(Node,Sec,_),write(Sec),write(') <- '),
    write2(R).

% valid transition: A and B are connected and the security level
% of B is at most one category higher than that of A:

filter_by_security([],[],_).

filter_by_security([Node | Rest1], [Node | Rest2], Security) :-
    node(Node, Sec2, _),
    Sec2 =< Security, !,
    filter_by_security(Rest1, Rest2, Security).

filter_by_security([_ | Rest1], Rest2, Security):-
    filter_by_security(Rest1, Rest2, Security).


expand(Node,Suc) :-
    node(Node,Sec,C),
    Sec2 is Sec + 1,
    filter_by_security(C,Suc,Sec2).


search(Start,GoalP,Expand,Strategy,Path) :-
      search1(GoalP,Expand,Strategy,[[Start]],Path).

search1(GoalP,_Expand,_Strategy,[[End|Path]|_Agenda],[End|Path]) :-
     G =.. [GoalP,End],
     G.

search1(GoalP,Expand,Strategy,[[X|Path]|Agenda],RPath) :-
     Exp =.. [Expand,X,S],
     Exp,
     exp_path(S,[X|Path],Pathes),
     strategy(Strategy,Agenda,Pathes,Agenda1), !,
     search1(GoalP,Expand,Strategy,Agenda1,RPath) .

search1(GoalP,Expand,Strategy,[_|Agenda],Path) :-
     search1(GoalP,Expand,Strategy,Agenda,Path) .

strategy('breadth-first',Agenda,Pathes,Agenda1) :-
     append(Agenda,Pathes,Agenda1).

strategy('depth-first',Agenda,Pathes,Agenda1) :-
     append(Pathes,Agenda,Agenda1).

exp_path([],_P,[]).
exp_path([X|R],P,[[X|P]|Ps]) :-
     not(member(X,P)), !,
     exp_path(R,P,Ps).
exp_path([X|R],P,Ps) :-
     exp_path(R,P,Ps).
