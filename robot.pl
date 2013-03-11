% The Kidnapped Robot Problem

% NOTE TO SELF:
% Evil tutors would replace the scan/2 predicate with one that first does the scan and then adds some noise the the measurements, just like the real thing.

% Alright, this is an actual problem from AI and robotics. The scenario is as follows: you've just built a mobile robot, equipped it with four ultrasonic range finders to measure the distance to obstacles in the four principal directions and programmed it with a map of its environment. Now someone with questionable morale standards kidnapped your little robot and released it somewhere else on the map. Your robot wants to drive home, but to plan a route it must first localise itself on the map.

% This can only be done by using its sensors to measure the proximity to the walls around him. This is done using the scan/2 - predicate. Suppose the robots immediate surroundings look like this:

%    #######
%    ##...#.
%    ##..+#.
%    #......
%    ###.### 

% Where + denotes the robot (and also the direction of the ultrasonic range finders), # denotes a wall and . empty space. The predicate would then unify Result with a list containing the measurements of the upper, right, lower and left range finder, respectively. So in this case:
% ?- scan(State, Result).
% Result = [2, 1, 2, 3]

% Furthermore the robot can use the move_up/2, move_down/2, move_left/2 and move_right/2 to, well, move one square into the respective direction. The predicates will be false if there is a wall in the direction that the robot wants to move, otherwise NewState will be unified to the state after moving.

% Talking about the state: this is a list containing the world map and the robots actual x and y positions -- which are actually unknown to the robot. So best is you just don't care about what your state contains right now.

% So this is what you should do: implement find_position/2, a predicate that when called will eventuall unify Position to a list containing the robots actual x and y position. This will be done by performing a sequence of scans and moves until the robot is sure where it is, e.g.
% find_position(State0, [X, Y]) :-
%     scan(State0, Results0),
%     move_up(State0, State1),
%     scan(State1, Results1),
%     move_right(State1, State2),
%     scan(State2, Results2),
%     do_incredible_magic([Results0, Results1, Results2], X, Y).

% Of course you will have to be a bit more precise with the last predicate. 
% You can use random_state/1 for testing (so will we).
% After you implemented everything, run evaluate/0 and note the results in your solution.

% HINT: use a hypothesis space (i.e. the space of all possible positions given a sensor reading) and watch it shrink to a single hypothesis as you move and scan.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRE-DEFINED PREDICATES BEGIN HERE
% Don't touch them. Seriously.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% world(-List)
% This is our world - w is a wall and o is empty space where our robot can move.
world([ [w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w], 
        [w,o,o,w,o,o,o,o,o,o,w,o,o,o,w,w,o,o,o,o,o,o,o,o,w,o,w,w,w,w,w,w], 
        [w,o,o,o,o,o,o,o,o,o,o,w,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,w], 
        [w,o,o,o,o,o,o,o,o,o,o,o,o,w,o,o,o,o,o,o,w,w,w,o,o,o,o,o,o,o,o,w], 
        [w,o,o,o,o,o,o,o,o,o,o,o,o,o,w,o,o,o,o,o,o,w,w,w,o,o,o,o,o,o,o,w], 
        [w,w,w,o,o,o,o,o,w,w,w,w,w,w,w,w,o,o,o,o,o,o,w,o,o,o,o,o,o,o,o,w], 
        [w,w,w,w,w,o,o,o,o,o,o,o,o,o,o,o,o,o,w,o,o,o,o,o,o,w,w,w,w,w,o,w], 
        [w,o,w,w,w,w,o,o,o,o,o,o,o,o,w,w,w,w,w,o,o,o,o,o,w,w,w,w,o,o,o,w], 
        [w,o,o,o,w,w,o,o,o,o,o,o,o,o,w,o,o,o,o,o,o,o,w,o,o,o,o,o,o,o,o,w], 
        [w,o,o,w,w,w,w,o,o,o,o,o,o,o,o,o,w,w,o,o,w,w,w,w,o,o,o,o,o,o,o,w], 
        [w,o,o,o,o,o,w,w,w,w,o,o,o,o,o,o,o,w,w,w,w,o,o,o,w,w,w,w,w,o,o,w], 
        [w,o,o,o,o,o,o,o,o,w,w,w,w,o,o,o,o,o,o,o,o,o,o,o,o,o,w,w,w,w,o,w], 
        [w,o,o,o,o,o,o,o,w,w,w,w,w,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,w], 
        [w,o,o,o,o,w,w,w,o,o,o,o,o,o,o,w,w,w,w,o,o,o,o,o,o,o,o,w,w,w,w,w], 
        [w,o,o,o,w,w,w,o,o,o,o,o,o,o,o,o,o,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w], 
        [w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w] ]). 

% random_state(-State) -- DO NOT USE THIS PREDICATE IN YOUR SOLUTION!
% Generates a random valid state using the world map
% (places the robot on any non-wall tile on the map)
random_state([W, X, Y]) :-
    world(W),
    world_size(SX, SY),
    repeat, 
    X is random(SX),
    Y is random(SY),
    not(wall(W,X,Y)), !.

% world_size(?X, ?Y)
% Unifies X and Y with the horizontal and vertical size of the world.
world_size(X, Y) :-
    world(W),
    length(W, Y),
    member(Row, W), !,
    length(Row, X).

% wall_tile(-atom)
% Defines which atoms are used for depicting wall tiles
wall_tile(w).

% wall(+World, +X, +Y) -- DO NOT USE THIS PREDICATE IN YOUR SOLUTION!
% Becomes true iff the tile at X,Y in the world is a wall. Upper left tile
% of the world map is at X=Y=0.
wall(World, X,Y) :-
    wall_tile(Tile),
    nth0(Y, World, Row),
    nth0(X, Row, Tile).
    

% scan(+State, ?Result)
% Gives us the result of a scan as a list of four integers, representing 
% the proximities to the upper, right, lower and left wall, respectively.
scan(State, [Up, Right, Down, Left]) :-
    scan_up(State, Up),
    scan_down(State, Down),
    scan_left(State, Left),
    scan_right(State, Right).

% scan_down(+State, -Discance)
% Unifies Distance with the distance to the closest wall below the robot
scan_down([World, X, Y], D) :-
    wall(World, X, POS),        % Look for walls in our row
    POS > Y, !,                 % Until we find one lower than our position
    D is POS - Y.               % Stop looking and calculate D.

% scan_right(+State, -Discance)
% Unifies Distance with the distance to the closest wall right to the robot
scan_right([World, X, Y], D) :-
    wall(World, POS, Y),        % Look for walls in our row
    POS > X, !,                 % Until we find one right to our position
    D is POS - X.               % Stop looking and calculate D.

% scan_left(+State, -Discance)
% Unifies Distance with the distance to the closest wall left to the robot
scan_left([World, X, Y], D) :-
    nth0(Y, World, Row),        % Get the right row
    append(Left, _, Row),       % Split it so that
    length(Left, X),            % We get everything left to X
    reverse(Left, LeftR),       % Reverse it
    wall_tile(Tile),            % And find the next wall tile
    nth1(D, LeftR, Tile), !.    % In the reversed list.

% scan_up(+State, -Discance)
% Unifies Distance with the distance to the closest wall above the robot
scan_up([World, X, Y], D) :-
    append(Upper, _, World),    % Split the world into two
    Y2 is Y + 1,                % Only consider upper half
    length(Upper, Y2),          % 
    reverse(Upper, UpperR),     % No philosophical connotation implied.
    wall(UpperR, X, D), !.      % Find our wall element at distance D.
    

% move_up(+OldState, -NewState)
% Moves the robot one square up and returns the new state.
% Will be false if the target square is a wall.
move_up([World, X, Y], [World, X, Y2]) :-
    Y2 is Y - 1,
    Y2 >= 0,
    not(wall(World, X, Y2)).

% move_down(+OldState, -NewState)
% Moves the robot one square down and returns the new state.
% Will be false if the target square is a wall.
move_down([World, X, Y], [World, X, Y2]) :-
    Y2 is Y + 1,
    world_size(_, SY),
    Y2 < SY,
    not(wall(World, X, Y2)).
 
% move_left(+OldState, -NewState)
% Moves the robot one square left and returns the new state.
% Will be false if the target square is a wall.
move_left([World, X, Y], [World, X2, Y]) :-
    X2 is X - 1,
    X2 >= 0,
    not(wall(World, X2, Y)).

% move_right(+OldState, -NewState)
% Moves the robot one square right and returns the new state.
% Will be false if the target square is a wall.
move_right([World, X2, Y], [World, X2, Y]) :-
    X2 is X2 + 1,
    world_size(SX, _),
    X2 < SX,
    not(wall(World, X2, Y)).

% evaluate/0 runs a few tests.
evaluate :-
    world(W),
    time(find_position([W, 16, 14], [X1, Y1])), % leave X1 and Y1 unbound
    X1 = 16,
    Y1 = 14,
    time(find_position([W, 9, 3], [X2, Y2])), % leave X1 and Y1 unbound
    X2 = 9,
    Y2 = 3,
    time(find_position([W, 19, 12], [X3, Y3])), % leave X1 and Y1 unbound
    X3 = 19,
    Y3 = 12,
    random_state([W, RX1, RY1]),
    time(find_position([W, RX1, RY1], [X4, Y4])),
    RX1 = X4,
    RY1 = Y4,
    random_state([W, RX2, RY2]),
    time(find_position([W, RX2, RY2], [X5, Y5])),
    RX2 = X5,
    RY2 = Y5.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DON'T MODIFY ANYTHING ABOVE THIS POINT.
% This is where your own solution should start.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find_position(+State, -Position)
% Performs a sequence of moves and scans until Position can be unified to
% the actual position in the State.
% find_position(State, Position) :- ...

