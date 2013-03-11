# Prolog puzzles for fun and profit (mostly fun)

These are exercises I created back in 2007 while TAing "Introduction to Artificial Intelligence and Logic Programming" at the Institute of Cognitive Science in Osnabrück, Germany.

If you never hacked in Prolog before, [learn it](http://www.learnprolognow.org)! It's fun and it makes you a Better Person™.

### If you are a current CogSci student and some of these exercises are still in use:

Well, lucky you. Here is what you should do if you're awesome and want to live up to the excellent reputation you and your fellow students hold in the academic world:

1. Star this repository. It's the Github way if saying "Thank you for ruining dozens of hours of my life that I will never get back!"
2. Do your homework yourself and submit your own solution. Plagiarism is not cool.
3. After you're done, fork this repo, add your own improvements you the solutions and send me a pull request.

### I can't have enough of this!

Check [P-99: Ninety-Nine Prolog Problems](https://sites.google.com/site/prologsite/prolog-problems). If you have fun Prolog puzzles of your own, let me know and I'm happy to include them here!

## Overwiev:

### The Three Musketeers

 In one particular chapter of Dumas' novel three events happened simultaneously on spring evening in 1643:

 * Someone was cleaning his musket, another one met Constance Bonacieux and yet another one had a duel with Cardinal Richelieu. One of these events happened in the Hotel Treville, one in the Jardin du Luxembourg and one in Geroge Villier's estate.
 * If either Aramis or Athos was in the Jardin, then someone cleaned his musket in the hotel.
 * Neither was Pathos involved in a duel nor did the duel take place in the Jardin.
 * Aramis lost his musket some days ago, and he was certainly not in the hotel.
 * If Pathos cleaned his musket then Constance has not been to the Jardin.
 * Cardinal Richelieu has been seen in Villier's estate if and only if Pathos was in Villier's estate.
 * Women are not allowed in Treville's Hotel.

Implement a predicate who_did_what(Aramis, Athos, Pathos) that will instantiate each Person with a list containg his action and the place he happened to be at (e.g. Athos = [duel, jardin] etc.) according to the information given above.

* __Excercise:__ `musketeers.pro`
* __Solution:__ `solutions/musketeers_solution.pro`


### Sudoku++

![sudoku++](https://raw.github.com/maebert/prolog_puzzles/master/sudoku.png)

Write a prolog program that solves the following constraint satisfaction problem: write the words "one", "two", "three", "four", "five" and "six" into the boxes such that every word occurs only once per row, column and 2x3 grid. The number of letters of the words in the grids within a dotted box must be equal.

* __Excercise:__ `sudoku.pro`
* __Solution:__ `solutions/sudoku_solution.prro`
* __Supplementary materials:__ `solutions/sudokus_solution/`rocontains more problems like this.

### translation.pl

Nqblubh Mhboa. Nqrrroah Ukahama Nqblubh. Nqlhalha Ukahama Nqflua.

* __Excercise:__ `translation.pro`
* __Solution:__ `solutions/translation_solution.pro`

### The Worm

So there you are. Your academic career as a cognitive scientist took a wrong turn somewhere, and now you wrote a virus with the ultimate goal of infecting the desktop computer of your arch rival, Jill Yates.

However, security is rather tight these days, and most machines use firewalls, traces and other measures to keep out people like you. Fortunately you were able to acquire a reduced topology of the internet. Your task is to implement a feasible heuristic for the route through the internet from your own machine, `asimov`, to your rivals box, `jillyates`, gaining access to higher security systems with every new infection.

* __Excercise:__ `the_worm.pro`
* __Solution:__ `solutions/the_worm_solution.pro`
* __Supplementary materials:__ `supplementary/the_worm/` contains prolog code to generate internets. It also contains prolog code that generates matlab code that draws internets.

### The Matching Problem

Prolog programming can be so romantic! In this exercise you will help five men and women to find their one and true loves - well, maybe.

In our case, we've got five males and five females. All of them assigned ranks to all members of the opposite sex and should get married according to those ranks. Now someone is said to be living in a stable marriage if there is no member of the opposite sex such that both would rather have each other than their current partners (and the same condition holds for that someone's partner).

* __Excercise:__ `the_worm.pl`
* __Solution:__ Left as an exercise to the reader.

### Chocolate

Ah, chocolate. The delicious blast of theobromine, caffeine, phenylethylamine and anandamide that will set off an uncanny firework in your brain has been used as treat, medicine and arguably aphrodisiac for more than three millennia since its first cultivation by Olmec and Maya cultures. My personal favourite is dark chocolate made from Caribbean Criollo beans with a hint of orange.

![Yummie chocolate](https://raw.github.com/maebert/prolog_puzzles/master/chocolate.png)

Anyway, here is your task: suppose you have a bar of your favourite chocolate which counts 5 x 9 pieces (so 45 in total) and want to share it with your three best friends (stupid enough). Now being a cognitive scientist you want to split the bar optimally with only three straight breaks between the square parts. And being more best friends with some than with others you want to give each of your friends a different amount of chocolate.

* __Excercise:__ `chocolate.pl`
* __Solution:__ Left as an exercise to the reader.


### The Kidnapped Robot

You've just built a mobile robot, equipped it with four ultrasonic range finders to measure the distance to obstacles in the four principal directions and programmed it with a map of its environment. Now someone with questionable morale standards kidnapped your little robot and released it somewhere else on the map. Your robot wants to drive home, but to plan a route it must first localise itself on the map.

* __Excercise:__ `robot.pl`
* __Solution:__ Left as an exercise to the reader.
