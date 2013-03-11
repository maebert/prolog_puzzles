%!bp -g "['musketeers.pro']"
%
% @author       Manuel Ebert
% @system       b-prolog

% In one particular chapter of Dumas' novel three events happened simultaneously on spring evening in 1643:
% Someone was cleaning his musket, another one met Constance Bonacieux and yet another one had a duel with Cardinal Richelieu. One of these events happened in the Hotel Treville, one in the Jardin du Luxembourg and one in Geroge Villier's estate.
% If either Aramis or Athos was in the Jardin, then someone cleaned his musket in the hotel.
% Neither was Pathos involved in a duel nor did the duel take place in the Jardin.
% Aramis lost his musket some days ago, and he was certainly not in the hotel.
% If Pathos cleaned his musket then Constance has not been to the Jardin.
% Cardinal Richelieu has been seen in Villier's estate if and only if Pathos was in Villier's estate.
% Women are not allowed in Treville's Hotel.

% Implement a predicate who_did_what(Aramis, Athos, Pathos) that will instantiate each Person with a list containg his action and the place he happened to be at (e.g. Athos = [duel, jardin] etc.) according to the information given above.
% Hint: Use ; for or, negations and equations in the predicate. All the constraints should be mentioned in this predicate. Besides who_did_what(X, Y, Z), you will (at most) also need two predicates enumerating actions and places.

%who_did_what([AramisAction, AramisPlace], [PathosAction, PathosPlace], [AthosAction, AthosPlace]) :-
