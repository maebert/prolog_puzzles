% The chocolate problem

% Ah, chocolate. The delicious blast of theobromine, caffeine, phenylethylamine and anandamide that will set off an uncanny firework in your brain has been used as treat, medicine and arguably aphrodisiac for more than three millennia since its first cultivation by Olmec and Maya cultures. My personal favourite is dark chocolate made from Caribbean Criollo beans with a hint of orange.

% Anyway, here is your task: suppose you have a bar of your favourite chocolate which counts 5 x 9 pieces (so 45 in total) and want to share it with your three best friends (stupid enough). Now being a cognitive scientist you want to split the bar optimally with only three straight breaks between the square parts. And being more best friends with some than with others you want to give each of your friends a different amount of chocolate.

% Example: After the first break you have a 5x2 piece and a 5x7 piece. Another break splits the larger chunk into a 1x7 and a 4x7 piece (you are not allowed to break more than one chunk at a time!). The third break cuts the 4x7 chunk into a chunk of 4x2 pieces and another of 4x5 pieces (check chocolate.png for an artistic impression of this):

% 0. #########   1. ## #######   2. ## #######   3. ## #######
%    #########      ## #######      ##              ##
%    #########      ## #######      ## #######      ## ## #####
%    #########      ## #######      ## #######      ## ## #####
%    #########      ## #######      ## #######      ## ## #####
%                                      #######         ## #####

% Now we end up with four chunks of chocolate with 7, 8, 10 and 20 pieces respectively. Note that we wouldn't be allowed to use our third break to break the 5x2 chunk on the left into two 1x5 bars since then two friends would have the same amount of chocolate. Even if you end with i.e. a 2x6 chunk and a 3x4 chunk two friends had the same amount (the number of pieces per chunk count, not the shape of the chunk).

% You've probably guessed the actual task by now:

% (a) How many different sets of chunks are there? This does not ask for the number of ways that you can break the bar into four chunks with the above constraints, but the actual number of different outcomes. I.e. the sets 5-10-6-24 and 10-6-5-24 are the same and only count once.

% (b) How many sets are there for four people for a n x m pieces large bar of chocolate?

% EXTRA CREDIT:

% (c) What are the minimal values for n and m if you want to share among p persons such that there is at least one solution?

% (d) How many sets are there for a n x m sized bar of chocolate if you want to share among p persons?
