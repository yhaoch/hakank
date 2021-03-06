/*

  A Round of Golf puzzle (Dell Logic Puzzles) in B-Prolog.

  From http://brownbuffalo.sourceforge.net/RoundOfGolfClues.html
  """
  Title: A Round of Golf
  Author: Ellen K. Rodehorst
  Publication: Dell Favorite Logic Problems
  Issue: Summer, 2000
  Puzzle #: 9
  Stars: 1
 
  When the Sunny Hills Country Club golf course isn't in use by club members, 
  of course, it's open to the club's employees. Recently, Jack and three other 
  workers at the golf course got together on their day off to play a round of 
  eighteen holes of golf. 
  Afterward, all four, including Mr. Green, went to the clubhouse to total 
  their scorecards. Each man works at a different job (one is a short-order 
  cook), and each shot a different score in the game. No one scored below 
  70 or above 85 strokes. From the clues below, can you discover each man's 
  full name, job and golf score?
  
  1. Bill, who is not the maintenance man, plays golf often and had the lowest 
  score of the foursome.
  2. Mr. Clubb, who isn't Paul, hit several balls into the woods and scored ten 
  strokes more than the pro-shop clerk.
  3. In some order, Frank and the caddy scored four and seven more strokes than 
  Mr. Sands.
  4. Mr. Carter thought his score of 78 was one of his better games, even 
     though Frank's score  was lower.
  5. None of the four scored exactly 81 strokes.
  
  Determine: First Name - Last Name - Job - Score 
  """

  Compare with the F1 model: 
  http://www.f1compiler.com/samples/A 20Round 20of 20Golf.f1.html

  Solution:
             Jack, Bill, Paul, Frank
             Clubb Sands Carter Green
             maint cook  caddy clerk
             85    71    78    75
  first_name: [1, 2, 3, 4]
  last_name : [4, 1, 2, 3]
  job       : [2, 1, 4, 3]
  score     : [85, 71, 78, 75]


  Model created by Hakan Kjellerstrand, hakank@gmail.com
  See also my B-Prolog page: http://www.hakank.org/bprolog/

*/



go :-

        N = 4,

        Jack  = 1,
        Bill  = 2,
        Paul  = 3,
        Frank = 4,
        FirstName = [Jack, Bill, Paul, Frank],
        FirstNameS = ['Jack', 'Bill', 'Paul', 'Frank'],

        LastName = [_Green,Clubb,Sands,Carter],
        LastNameS = ['Green','Clubb','Sands','Carter'],
        LastName :: 1..N,

        Job = [_Cook,MaintenanceMan,Clerk,Caddy],
        JobS = ['Cook','Maintenance Man','Clerk','Caddy'],
        Job :: 1..N,

        length(Score,N),
        Score :: 70..85,
        Score = [ScoreJack,ScoreBill,ScorePaul,ScoreFrank],

        alldifferent(LastName),
        alldifferent(Job),
        alldifferent(Score),
        
        % 1. Bill, who is not the maintenance man, plays golf often and had 
        %    the lowest score of the foursome.
        Bill #\= MaintenanceMan,

        ScoreBill #< ScoreJack,
        ScoreBill #< ScorePaul,
        ScoreBill #< ScoreFrank,
        
        % 2. Mr. Clubb, who isn't Paul, hit several balls into the woods and 
        %    scored ten strokes more than the pro-shop clerk.
        Clubb #\= Paul,

        element(Clubb,Score,ScoreClubb),
        element(Clerk,Score,ScoreClerk),
        ScoreClubb #= ScoreClerk + 10,
       
        % 3. In some order, Frank and the caddy scored four and seven more 
        %    strokes than Mr. Sands.
        Frank #\= Caddy,
        Frank #\= Sands,
        Caddy #\= Sands,
        
        element(Sands,Score,ScoreSands),
        element(Caddy,Score,ScoreCaddy),
        element(Carter,Score,ScoreCarter),
        (
            ScoreFrank #= ScoreSands + 4,
            ScoreCaddy #= ScoreSands + 7
        ;
            ScoreFrank #= ScoreSands + 7,
            ScoreCaddy #= ScoreSands + 4
        ),

        % 4. Mr. Carter thought his score of 78 was one of his better games, even 
        % though Frank's score was lower.
        Frank #\= Carter,
        
        % Score[Carter] #= 78,
        ScoreCarter #= 78,
        ScoreFrank #< ScoreCarter,

        % 5. None of the four scored exactly 81 strokes.
        foreach(S in Score, S #\= 81),

        term_variables([Score,LastName,Job], Vars),

        labeling([ff],Vars),
        
        format("First names: ~w\n", [FirstName]),
        format("Last names : ~w\n", [LastName]),
        format("Jobs       : ~w\n", [Job]),
        format("Score      : ~w\n", [Score]),
        nl,

        % A nicer presentation.
        % Get the inverse of Last name and Jobs to present
        % the names/jobs
        assignment(LastName,LastNameInv),
        assignment(Job,JobInv),
        foreach((F,L,J,S) in (FirstName,LastNameInv,JobInv,Score),
                [F2,L2,J2],
                (nth(F,FirstNameS,F2),
                 nth(L,LastNameS,L2),
                 nth(J,JobS,J2),
                 format("~w\t~w\t~w: ~4d\n",[F2,L2,J2,S])
                )),

        nl.
   