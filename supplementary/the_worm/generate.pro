:- include('names.pl').

size(2048,2048).
secs(8).
constA(0.2).    % network connectedness
constB(0.3).    % Ratio of short vs long connections
constL(2896). % maximal distance

generate(Number) :-
    length(Nodes,Number),
    makeNodes(Nodes),
    connectNodes(Nodes),
    %removeNodes(Nodes, Nodes2),
    sort(Nodes2,Nodes3),
    printNodes(Nodes3).
    
connectNodes([]).
connectNodes([Node | T]) :-
    connectNode(Node, T),
    connectNodes(T).
    
    
% Here we use Waxman's model for generating a network topology.
% Two nodes u, v are connected with probability
% P = a * (su+sv) * e^-(d / b * L)
% where a > 0 increases the number of total edges,
% d is the distance between u and v,
% su, sv are the security levels of u and v respectively
% b changes the ratio of short and long edges
% L is the maximal distance.
% B.M.Waxman (1988) Routing of multipoint connections. 
% IEEE J. Select. Areas Commun. 6(9), 1617-1622.
connectNode(_, []).

connectNode([Name1, X1, Y1, Sec1, C1], [[Name2, X2, Y2, Sec2, C2] | OtherNodes]) :-
    connect([Name1, X1, Y1, Sec1, C1], [Name2, X2, Y2, Sec2, C2]), !,
    member(Name1, C2), member(Name2,C1),
    connectNode([Name1, X1, Y1, Sec1, C1], OtherNodes).

connectNode([Name1, X1, Y1, Sec1, C1], [_ | OtherNodes]) :-
    connectNode([Name1, X1, Y1, Sec1, C1], OtherNodes).



% Free Variable -> empty list
removeNodes([],[]).
   
removeNodes([[_,_,_,_, C] | R], Rest) :-
    length(C,0),!,
    removeNodes(R, Rest).


% Removes isolated nodes
removeNodes([[Name, X, Y, Sec, C] | R], [[Name, X, Y, Sec, C2] | Rest]) :-
    list_to_set(C,C2),
    removeNodes(R, Rest).



% Succeeds if two nodes shall be connected.
connect([_, X1, Y1, Sec1, _], [_, X2, Y2, Sec2, _]) :-
    D is sqrt((X1 - X2)^2 + (Y1 - Y2)^2),
    constA(A), constB(B), constL(L),
    SecSum is Sec1 + Sec2,
    Exponent is -D / (B * L),
    P is A * SecSum * exp(Exponent),
    P > 1.
    
makeNodes([]).
makeNodes([[Name, X, Y, Sec, _] | T]) :-
    name(Name),       % Give the computer a name
    size(MaxX,MaxY),   % Give it a coordinate.
    X is random(MaxX), % Distance will be used as probability
    Y is random(MaxY), % of connection.
    secs(MaxSec),
    Sec is 8 - floor(sqrt(random(MaxSec * MaxSec))),
    makeNodes(T).

printNodes(Nodes) :-
    write('name            x     y     sec  con'),nl,
    write('------------------------------------'),nl,
    printNodes2(Nodes),nl,nl,
    printNodes3(Nodes).


printNodes3([]).    
printNodes3([[Name,_,_,Sec,C] | R]) :-
    write('node('),write(Name),write(','),write(Sec),write(','),write(C),write(').'),nl,
    printNodes3(R).
    
printNodes2([]).
printNodes2([[Name, X, Y, Sec, C] | T]) :-
    write2(Name,16),
    write2(X,6),
    write2(Y,6),
    write2(Sec,5),
    write(C),
    nl,
    printNodes2(T).

    
write2(Name,TotalL) :-
    atomic(Name),
    write(Name),
    atom_chars(Name,NameC),
    length(NameC,L),
    Tabs is TotalL - L,
    tab(Tabs).

write2(_,TotalL) :-
    write('?'),
    Tabs is TotalL - 1,
    tab(Tabs).   
     