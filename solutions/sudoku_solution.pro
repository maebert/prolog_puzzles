%!bp -g "['sudoku_solution.pro']"
%
% @author       Manuel Ebert
% @system       b-prolog

test_case([
           [one,two,three,four,five,six],
           [four,five,six, one,two,three],
           [two,three,four,five,six,one],
           [five,six, one,two,three,four],
           [three,four,five,six,one,two],
           [six, one,two,three,four,five]
            ]).

valid(L) :- permutation([one,two,three,four,five,six], L).

col(I, grid, [C0,C1,C2,C3,C4,C5]) :-
    transpose(grid, grid2),
    nth0(I, grid2, [C0,C1,C2,C3,C4,C5]).

row(I, grid, Row) :- nth0(I, grid, Row).

grid(0,
      [[A0,B0,C0,D0,E0,F0],[A1,B1,C1,D1,E1,F1],_,_,_,_],
      [A0,B0,C0,A1,B1,C1]).
grid(1,
      [[A0,B0,C0,D0,E0,F0],[A1,B1,C1,D1,E1,F1],_,_,_,_],
      [D0,E0,F0,D1,E1,F1]).
grid(2,
      [_,_,[A2,B2,C2,D2,E2,F2],[A3,B3,C3,D3,E3,F3],_,_],
      [A2,B2,C2,A3,B3,C3]).
grid(3,
      [_,_,[A2,B2,C2,D2,E2,F2],[A3,B3,C3,D3,E3,F3],_,_],
      [D2,E2,F2,D3,E3,F3]).
grid(4,
      [_,_,_,_,[A4,B4,C4,D4,E4,F4],[A5,B5,C5,D5,E5,F5]],
      [A4,B4,C4,A5,B5,C5]).
grid(5,
      [_,_,_,_,[A4,B4,C4,D4,E4,F4],[A5,B5,C5,D5,E5,F5]],
      [D4,E4,F4,D5,E5,F5]).

check_rows([R0,R1,R2,R3,R4,R5]) :-
    valid(R0),
    valid(R1),
    valid(R2),
    valid(R3),
    valid(R4),
    valid(R5).

check_cols(Board) :-
    transpose(Board, VBoard),
    check_rows(VBoard).

check_grids(Board) :-
    grid(0, Board, F0), valid(F0),
    grid(1, Board, F1), valid(F1),
    grid(2, Board, F2), valid(F2),
    grid(3, Board, F3), valid(F3),
    grid(4, Board, F4), valid(F4),
    grid(5, Board, F5), valid(F5).

start([R0,R1,R2,R3,R4,R5]) :-
    valid(R0),
    valid(R1),
        grid(0,[R0,R1,R2,R3,R4,R5], F0), valid(F0),
        grid(1,[R0,R1,R2,R3,R4,R5], F1), valid(F1),
    valid(R2),
        check_cols([R0,R1,R2,R3,R4,R5]),
    valid(R3),
%        grid(2,[R0,R1,R2,R3,R4,R5], F2), valid(F2),
%        grid(3,[R0,R1,R2,R3,R4,R5], F3), valid(F3),
    valid(R4),
%        check_cols([R0,R1,R2,R3,R4,R5]),
    valid(R5),
%        grid(4,[R0,R1,R2,R3,R4,R5], F4), valid(F4),
%        grid(5,[R0,R1,R2,R3,R4,R5], F5), valid(F5),
%    check_all([R0,R1,R2,R3,R4,R5]).
    write_board([R0,R1,R2,R3,R4,R5]).

check_all(Board) :-
    check_rows(Board),
    check_cols(Board),
    check_grids(Bord).

gen(F) :- start(F), valid(F).

write_board([R0,R1,R2,R3,R4,R5]) :-
    write(R0), nl,
    write(R1), nl,
    write(R2), nl,
    write(R3), nl,
    write(R4), nl,
    write(R5), nl.

