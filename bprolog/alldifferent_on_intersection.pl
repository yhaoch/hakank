/*

  Global constraint alldifferent_on_intersection in B-Prolog.

  From Global Constraint Catalogue
  http://www.emn.fr/x-info/sdemasse/gccat/Calldifferent_on_intersection.html
  """
  The values that both occur in the VARIABLES1 and VARIABLES2 collections 
  have only one occurrence.
  
  Example
  (
   <5, 9, 1, 5>,
   <2, 1, 6, 9, 6, 2>
  )
  
  The alldifferent_on_intersection constraint holds since the values 9 and 1 
  that both occur in <5, 9, 1, 5> as well as in <2, 1, 6, 9, 6, 2> have 
  exactly one occurrence in each collection.
  """

  Model created by Hakan Kjellerstrand, hakank@gmail.com
  See also my B-Prolog page: http://www.hakank.org/bprolog/

*/




go :-
        M = 4,
        N = 6,

        length(X,M),
        X :: 1..9,

        length(Y,N),
        Y :: 1..9,

        % X = [5,9,1,5],
        X = [5,9,_,5],

        Y = [2,1,6,9,6,2], % constraint holds
        % Y = [2,1,6,9,6,1], % constraint do not hold since 
                            %  there are two 1's in 1 and one 1 in x

        alldifferent_on_intersection(X,Y),

        term_variables([X,Y],Vars),
        labeling(Vars),

        writeln(x:X),
        writeln(y:Y),
        nl,
        fail.


alldifferent_on_intersection(Xs,Ys) :-
        count_A_in_B(Xs,Ys),
        count_A_in_B(Ys,Xs).


count_A_in_B(As,Bs) :-
        foreach(A in As,
                sum([(A #= B) : B in Bs]) #=< 1
        ).