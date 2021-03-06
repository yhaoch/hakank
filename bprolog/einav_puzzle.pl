/*

  A programming puzzle from Einav in B-Prolog.

  From 
  "A programming puzzle from Einav"
  http://gcanyon.wordpress.com/2009/10/28/a-programming-puzzle-from-einav/
  """
  My friend Einav gave me this programming puzzle to work on. Given this array of positive and negative numbers:
  33   30  -10 -6  18   7  -11 -23   6
  ...
  -25   4  16  30  33 -23  -4   4 -23
 
  You can flip the sign of entire rows and columns, as many of them
  as you like. The goal is to make all the rows and columns sum to positive
  numbers (or zero), and then to find the solution (there are more than one)
  that has the smallest overall sum. So for example, for this array:
  33  30 -10
  -16  19   9
  -17 -12 -14
  You could flip the sign for the bottom row to get this array:
  33  30 -10
  -16  19   9
  17  12  14
  Now all the rows and columns have positive sums, and the overall total is 
  108.
  But you could instead flip the second and third columns, and the second 
  row, to get this array:
  33  -30  10
  16   19    9
  -17   12   14
  All the rows and columns still total positive, and the overall sum is just 
  66. So this solution is better (I don't know if it's the best)
  A pure brute force solution would have to try over 30 billion solutions. 
  I wrote code to solve this in J. I'll post that separately.
  """

  Model created by Hakan Kjellerstrand, hakank@gmail.com
  See also my B-Prolog page: http://www.hakank.org/bprolog/

*/

go :- 
        problem(Data),
        matrix(Data,[Rows,Cols]),
        
        matrix(X,[Rows,Cols]),
        term_variables(X, XList),
        XList :: -100..100,
        
        % row/column sums
        length(RowSums,Rows),
        length(ColSums,Cols),
        RowSums :: 0..300,
        ColSums :: 0..300,

        % the signs of rows and column
        length(RowSigns,Rows),
        RowSigns :: [-1,1],
        length(ColSigns,Cols),
        ColSigns :: [-1,1],

        % Assign X[I,J]
        foreach(I in 1..Rows,J in 1..Cols,
                [T],
                (
                    T #= Data[I,J]*RowSigns[I]*ColSigns[J],
                    matrix_element(X,I,J,T)
                )
               ),

        % total sum (to minimize)
        TotalSum #= sum([T : I in 1..Rows,J in 1..Cols, [T],
                         matrix_element(X,I,J,T)
                        ]),
        TotalSum :: 0..1000,

        % row sums
        foreach(I in 1..Rows,
                [T],
                (T #= sum([TT : J in 1..Cols, 
                           [TT,RS,CS], 
                           (element(I,RowSigns,RS),
                            element(J,ColSigns,CS),
                            TT #= RS*CS*Data[I,J]
                           )
                          ]),
                 element(I,RowSums,T)
                )
               ),

        % column sums
        foreach(J in 1..Cols,
                [T],
                (T #= sum([TT : I in 1..Rows, 
                           [TT,RS,CS], 
                           (element(I,RowSigns,RS),
                            element(J,ColSigns,CS),
                            TT #= RS*CS*Data[I,J]
                           )
                          ]),
                 element(J,ColSums,T)
                )
               ),

        term_variables([RowSums,ColSums,RowSigns,ColSigns,XList],Vars),
        minof(labeling([ffd],Vars),TotalSum,
              format("TotalSum: ~d\n",[TotalSum])),

        foreach(Row in X, 
                (foreach(V in Row, format("~3d ", [V])), nl)
               ),
        nl,
        writeln(total_sums:TotalSum),
        writeln(row_sums:RowSums),
        writeln(col_sums:ColSums),
        writeln(row_signs:RowSigns),
        writeln(col_signs:ColSigns),
        nl.


matrix_element(X, I, J, Val) :-
        nth1(I, X, Row),
        element(J, Row, Val).

% From Mats Carlsson.
matrix(_, []) :- !.
matrix(L, [Dim|Dims]) :-
        length(L, Dim),
        foreach(X in L, matrix(X, Dims)).


problem(
[[33,30,10,-6,18,-7,-11,23,-6],
 [16,-19,9,-26,-8,-19,-8,-21,-14],
 [17,12,-14,31,-30,13,-13,19,16],
 [-6,-11,1,17,-12,-4,-7,14,-21],
 [18,-31,34,-22,17,-19,20,24,6],
 [33,-18,17,-15,31,-5,3,27,-3],
 [-18,-20,-18,31,6,4,-2,-12,24],
 [27,14,4,-29,-3,5,-29,8,-12],
 [-15,-7,-23,23,-9,-8,6,8,-12],
 [33,-23,-19,-4,-8,-7,11,-12,31],
 [-20,19,-15,-30,11,32,7,14,-5],
 [-23,18,-32,-2,-31,-7,8,24,16],
 [32,-4,-10,-14,-6,-1,0,23,23],
 [25,0,-23,22,12,28,-27,15,4],
 [-30,-13,-16,-3,-3,-32,-3,27,-31],
 [22,1,26,4,-2,-13,26,17,14],
 [-9,-18,3,-20,-27,-32,-11,27,13],
 [-17,33,-7,19,-32,13,-31,-2,-24],
 [-31,27,-31,-29,15,2,29,-15,33],
 [-18,-23,15,28,0,30,-4,12,-32],
 [-3,34,27,-25,-18,26,1,34,26],
 [-21,-31,-10,-13,-30,-17,-12,-26,31],
 [23,-31,-19,21,-17,-10,2,-23,23],
 [-3,6,0,-3,-32,0,-10,-25,14],
 [-19,9,14,-27,20,15,-5,-27,18],
 [11,-6,24,7,-17,26,20,-31,-25],
 [-25,4,-16,30,33,23,-4,-4,23]]).
