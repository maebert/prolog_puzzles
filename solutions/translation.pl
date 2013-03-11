

% Solution:

% Part 1:

fish --> ['the shark'].
fish --> ['the goldfish'].
bird --> ['the eagle'].
bird --> ['the finch'].
mammal --> ['the boy'].
carnivore --> ['the shark'].
carnivore --> ['the eagle'].
carnivore --> ['the boy'].
thing --> fish.
thing --> bird.
thing --> mammal.
drownable --> bird.
drownable --> mammal.
flying --> bird.
swimming --> fish.
swimming --> mammal.

s --> swimming, ['swims'].
s --> flying, ['flies'].
s --> carnivore, ['eats'], thing.
s --> thing, ['eats'].
s --> thing, ['drowns'], drownable.
s --> drownable, ['drowns'].

% Part 2:

english_words(['the shark', 'the goldfish', 'the eagle', 'the finch', 'the boy', 'eats', 'swims', 'flies', 'drowns']).

meaningful(L) :-
    s(L, []).

translation(Nqrrroah, Nqblubh, Nqflua, Nqdwingi, Nqlhalha, Ukahama, Mhboa, Sharabrab, Falup) :-
    english_words(E),
    permutation([Nqrrroah, Nqblubh, Nqflua, Nqdwingi, Nqlhalha, Ukahama, Mhboa, Sharabrab, Falup], E),
    meaningful([Nqblubh,Mhboa]),
    meaningful([Nqrrroah,Ukahama,Nqblubh]),
    meaningful([Nqlhalha,Falup]),
    meaningful([Nqlhalha,Ukahama]),
    meaningful([Nqlhalha,Ukahama,Nqflua]),
    meaningful([Nqflua,Sharabrab]),
    meaningful([Nqblubh,Falup,Nqdwingi]),
    meaningful([Nqflua,Ukahama,Nqdwingi]),
    meaningful([Nqdwingi,Falup,Nqflua]).


% permutation (if not built in)
permutation(List,[H|Perm]):-
    delete(H,List,Rest),
    permutation(Rest,Perm).
permutation([],[]).

delete(X,[X|T],T).
delete(X,[H|T],[H|NT]):-
    delete(X,T,NT).
