%!bp -g "['musketeers_solution.pro']"
%
% @author       Manuel Ebert
% @system       b-prolog


place(hotel).
place(jardin).
place(estate).

action(clean).
action(meet).
action(duel).


who_did_what([ArDo, ArWh], [PaDo, PaWh], [AthDo, AthWh]) :-
    All = [[ArDo, ArWh], [PaDo, PaWh], [AthDo, AthWh]],   % For simplicity
    action(ArDo), place(ArWh),                          % Aramis' stuff
    action(AthDo), place(AthWh),                        % Athos' stuff
    action(PaDo), place(PaWh),                          % Pathos' stuff
    not(ArDo=PaDo), not(ArDo=AthDo), not(PaDo=AthDo),   % Everyone is doing something different
    not(ArWh=PaWh), not(ArWh=AthWh), not(PaWh=AthWh),   % Everyone is at a different place
    % "If either Aramis or Athos was in the Jardin, then someone cleaned his musket in the hotel"
    % => Either Aramis was not in the Jardin or the cleaning happened in the hotel OR
    % Either Athos was not in the Jardin or the cleaning happened in the hotel
    (
        (not(ArWh=jardin) ;  member([clean, hotel], All)) ;
        (not(AthWh=jardin) ; member([clean, hotel], All))
    ),
    % "Pathos was not involved in a duel and the duel did not take place in the Jardin."
    not(PaDo=duel), not(member([duel, jardin], All)),
    % "Aramis lost his musket some days ago, and he was certainly not in the hotel."
    not(ArDo=clean), not(ArWh=hotel),
    % "If Pathos cleaned his musket then Constance has not been to the Jardin."
    % => Either Pathos wasn't cleaning or the meeting did not happen in the Jardin
    (
        not(PaDo=clean) ; not(member([meet, jardin], All))
    ),
    % "Cardinal Richelieu has been seen in Villier's estate if and only if Pathos was in Hotel."
    (
        (member([duel, estate], All) , PaWh=hotel) ;
        (not(member([duel, estate], All)) , not(PaWh=hotel))
    ),
    % "Women are not allowed in Treville's Hotel."
    not(member([meet, hotel], All)), !.

