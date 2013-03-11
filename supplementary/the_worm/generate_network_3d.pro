%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE_NETWORK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Manuel Ebert, maebuert at uos dot de, version 24 VI 2008
%
% requires 'names.pl' to be in the same folder
%
% Generates a computer network with computers of different security levels
% and formats it for MatLab Plotting or Prolog Databases.
% More secure computers will be more central in local clusters.
%
% Usage:
% generate(+Number, +A, +B).
% Will generate a network with up to Number nodes, an global connectivity
% of A and a ratio of long over short edges of B.
% Prolog will then create a file called "drawnetwork.m" which can be run
% in MatLab to plot the network. Furthermore a file "network.pl" will be
% created that contains the full network topology as predications over nodes.
% Use set_size(X,Y) to set a new size of the map and set_sec_levels(S) to change the
% number of security levels.
%
% Example:
% ?- set_size(1024, 1024), generate(30, 1.1, 0.5).
% In MatLab:
% addpath ~/My/Path/To/generate_network/
% drawnetwork
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I. INTERFACE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- include('names.pl').
:- dynamic constA/1, constB/1, size/2, secs/1, constL/1.

% Default parameters
size(10000,10000,10000). % size of map
sec_levels(8).           % number of security levels
constA(0.1).       % network connectedness
constB(0.2).       % Ratio of short vs long connections
constL(144000).    % maximal distance

% setsize(+X,+Y)
% change size of map
set_size(X,Y,Z) :- 
    retractall(size(_,_,_)), 
    assert(size(X,Y),Z),         % set new size
    MaxD is sqrt(X^2 + Y^2 + Z^2),   % calculate max distance
    retractall(constL(_)),    
    assert(constL(MaxD)).      % set new max distance

% set levels of security
set_sec_levels(S) :- 
    retractall(sec_levels(_)), 
    assert(sec_levels(S)).           % set new number of security levels

generate(Number, A, B) :-
    (exists_file('drawnetwork.m') -> delete_file('drawnetwork.m') ; nl), % check files
    (exists_file('network.pl') -> delete_file('network.pl') ; nl),
    retractall(constA(X)), retractall(constB(X)),                        % update constants
    assert(constA(A)), assert(constB(B)),
    write('Generating network...'),nl,
    generate(Number, X),                                                 % generate network
    write('Writing MatLab code...'), nl,
    tell('drawnetwork.m'),                                               % write matlab
    write('function drawnetwork;'),nl,
    nodes2matlab(X), told,
    write('Writing Prolog database...'),nl,
    tell('network.pl'),
    write_database(X), told,                                             % write db
    write('All done.'), nl.


generate(Number, Nodes3) :-
    length(Nodes,Number),           % Free list mit Number items
    make_nodes(Nodes),              % Unify empty Variables with nodes
    connect_nodes(Nodes),           % Unify the still empty connection lists
    remove_nodes(Nodes, Nodes2),    % remove unbound variables and unconnected nodes
    sort(Nodes2,Nodes3).            % sort them alphabetically


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% II. THE ACTUAL CODE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
% Generate Nodes
make_nodes([]).
make_nodes([[Name, X, Y, Z, Sec, _] | T]) :-
    name(Name),       % Give the computer a name
    size(MaxX,MaxY,MaxZ),   % Give it a coordinate.
    X is random(MaxX), % Distance will be used as probability
    Y is random(MaxY), % of connection.
    Z is random(MaxZ), % of connection.
    sec_levels(MaxSec),
    Sec is 8 - floor(sqrt(random(MaxSec * MaxSec))),
    make_nodes(T).

 
% One by one, connect all nodes
connect_nodes([]).
connect_nodes([Node | T]) :-
    connect_node(Node, T),
    connect_nodes(T).
    
% Connect one node to others.
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
connect_node(_, []).

connect_node([Name1, X1, Y1, Z1, Sec1, C1], [[Name2, X2, Y2, Z2, Sec2, C2] | OtherNodes]) :-
    connect([Name1, X1, Y1, Z1, Sec1, C1], [Name2, X2, Y2, Z2, Sec2, C2]), !,
    member(Name1, C2), member(Name2,C1),
    connect_node([Name1, X1, Y1, Z1, Sec1, C1], OtherNodes).

connect_node([Name1, X1, Y1, Z1, Sec1, C1], [_ | OtherNodes]) :-
    connect_node([Name1, X1, Y1, Z1, Sec1, C1], OtherNodes).



% Free Variable -> empty list
remove_nodes([],[]).
   
remove_nodes([[_,_,_,_,_,_, C] | R], Rest) :-
    length(C,0),!,
    remove_nodes(R, Rest).


% Removes isolated nodes
remove_nodes([[Name, X, Y, Z, Sec, C] | R], [[Name, X, Y, Z, Sec, C2] | Rest]) :-
    list_to_set(C,C2),
    remove_nodes(R, Rest).



% Succeeds if two nodes shall be connected.
connect([_, X1, Y1, Z1, Sec1, _], [_, X2, Y2, Z2, Sec2, _]) :-
    D is sqrt((X1 - X2)^2 + (Y1 - Y2)^2 + (Z1 - Z2)^2),
    constA(A), constB(B), constL(L),
    SecSum is Sec1 + Sec2,
    Exponent is -D / (B * L),
    P is A * SecSum * exp(Exponent),
    P > 1.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% III. OUTPUT OF NODES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% III.a ) FOR MATLAB

nodes2matlab(Nodes3) :- write('G = ['), allrows2matlab(Nodes3 ,Nodes3), write('];'),nl,
                        write('C = ['), allcoods2matlab(Nodes3), write('];'),nl,
                        write('gplot(G,C);'),nl,write('grid;'),nl,
                        names2matlab(Nodes3).

names2matlab([]).
names2matlab([[N,X,Y,Z,S,_] | T]) :-
    sec_levels(SMax), S2 is 1 - (S / SMax),
    write('text('),write(X),write(','),write(Y),write(','),write(Z),write(','),
    write('\''),write(N), write('\','), 
    write('\'HorizontalAlignment\',\'center\','),
    write('\'BackgroundColor\',[1 '), write(S2), write(' '), write(S2), write('],'),
    write('\'FontSize\',9);'),nl,
    names2matlab(T).

allcoods2matlab([]).
allcoods2matlab([[_,X,Y,Z,_,_] | T]) :-
    write(X), write(' '), write(Y), write(' '), write(Z), write(' ; '),
    allcoods2matlab(T).

allrows2matlab([], _).
allrows2matlab([H | T], Nodes) :-
    row2matlab(H,Nodes),
    allrows2matlab(T,Nodes).

row2matlab(_, []):- write(' ; ').
row2matlab([Name,X,Y,Z,Sec,C], [[Name2,_,_,_,_,_] | T]) :-
    (member(Name2,C) -> write(1) ; write(0)),
    write(' '),
    row2matlab([Name,X,Y,Z,Sec,C], T).
   
% III.b ) For Prolog
   
write_database([]).    
write_database([[Name,_,_,_,Sec,C] | R]) :-
    write('node('),write(Name),write(','),write(Sec),write(','),write(C),write(').'),nl,
    write_database(R).
         

% III.c ) For humans

print_nodes(Nodes) :-
    write('name            x     y     z     sec  con'),nl,
    write('------------------------------------------'),nl,
    print_nodes2(Nodes).



print_nodes2([]).
print_nodes2([[Name, X, Y, Z, Sec, C] | T]) :-
    write2(Name,16),
    write2(X,6),
    write2(Y,6),
    write2(Z,6),
    write2(Sec,5),
    write(C),
    nl,
    print_nodes2(T).

    
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
     