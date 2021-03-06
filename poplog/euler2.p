/*
  Problem 2

  http://projecteuler.net/index.php?section=problems&id=2

  """
  Each new term in the Fibonacci sequence is generated by adding the previous 
  two terms. By starting with 1 and 2, the first 10 terms will be:

  1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...

  Find the sum of all the even-valued terms in the sequence which do not exceed four million.
  """

  Note: The sequence starts with 1 2, not 1 1 2.

  This Pop-11 program was created by Hakan Kjellerstrand (hakank@bonetmail.com).
  See also my Pop-11 / Poplog page: http://www.hakank.org/poplog/


*/
compile('/home/hakank/Poplib/init.p');

define sumlist(list) -> res;
   applist(0, list, nonop + ) -> res;
enddefine;

define even(num);
  if num mod 2 = 0 then 
      return(true);
  endif;
  return(false);
enddefine;

define odd(num);
  if num mod 2 = 1 then 
      return(true);
  endif;
  return(false);
enddefine;


define fib(num) -> res;
  if num <= 1 then 
     1 -> res;
     return();
  endif;

  fib(num - 1) + fib(num -2) -> res;

enddefine;

define select( L, pred ); 
    lvars L2, i;
    [%for i in L do if pred(i) then i endif endfor%]->L2;
    return(L2);
enddefine;



;;;
;;; memoised version of fib
;;; fibvec must be initialized (see problem2)
;;;
vars fibvec; ;;; GLOBAL!
define fib2(num) -> res;

    if num <= 1 then 
        fibvec(1) -> res;
        return();
    endif;

    ;;; not in fibvec?
    if fibvec(num) == 0 then
        fib2(num - 1) + fib2(num - 2) -> fibvec(num);
    endif;

    fibvec(num) ->  res;    

enddefine;

;;;
;;; note: this is not used any more. 
;;; But note the construction: we don't need any if's 
;;; or returns etc
;;;
define even_and_less_than_4000000(num) ;
    even(num) and num < 4000000
enddefine;

define problem2a();
    lvars n, f2, f_even, i;
    100 -> n;
    newarray([1 ^n], 0) -> fibvec; ;;; GLOBAL!
    1->fibvec(1);
    2->fibvec(2);
    ;;; npr(fib2(n));
    fib2(n)->xxx;

    ;;; get the values
    ;;; [%for i from 1 to fibvec.length do fibvec(i) endfor%]->f2;
    [%for i from 1 to fibvec.length do if fibvec(i) < 4000000 then fibvec(i) endif endfor%]->f2;
    ;;; npr(f2);
    ;;;select(f2, even_and_less_than_4000000)->f_even;
    select(f2, even)->f_even;
    ;;; npr(f_even);
    sumlist(f_even)=>
enddefine;


;;; Version b: uses dynamic lists
;;; note: problem() a the second time gives [] 0 as result
;;;
define problem2b()->sum;

    ;;; Alternative and much more elegant version using dynamis lists.
    ;;; (see dynamic_lists.p)
    ;;; Note: This is a kind of memoizing.
    ;;;
    ;;; Define the generator of the Fibonacci sequence
    define gen_fib() -> next;
        lconstant store = [1 1];
        ;;; but this is not very naturual
        lvars tmp = store(1);
        store(2) -> store(1);
        store(2) -> next;
        tmp + store(2) -> store(2);
    enddefine;

    ;;; convert to dynamic list
    lvars fib_list = pdtolist(gen_fib);
    lvars i = 1;
    lvars sum = 0;
    [% ;;; less than 4000000
      while fib_list(i) < 4000000 do
          ;;; and is even
          lvars t = fib_list(i);
          if t mod 2 = 0 then
              t + sum -> sum;
              t; ;;; put the value on the stack
          endif;
          i + 1 -> i
      endwhile
      %]; ;;;=>
    ;;; sum=>
    ;;; fib_list=>
enddefine;

;;;; testing without memo. Must be run before problem2()
;;;; since it memoizes fib.
define problem2_nomemo();
    ;;; newmemo(fib,200) -> fib;

    lvars i = 0;
    lvars t = 1;
    lvars sum = 0;
    lvars fib_list;
    [%
    while t < 4000000 do
        fib(i) -> t;
        if t mod 2 = 0 then
            t + sum -> sum;
            t;
        endif;
        i + 1 -> i
    endwhile
    %]->fib_list;
    sum=>
    fib_list=>
    
enddefine;


;;; And this version uses ~/Poplog/newmemo.p 
;;; From Popplestones Popbook (popbook.pdf), page 289
;;; Yes, it works very well. And it works the next time as well.
;;; Note: The following will give a MEMORY LIMIT after a while
;;;   uses time;
;;;   time problem2();
define problem2();
    newmemo(fib,200) -> fib;

    lvars i = 0;
    lvars t = 1;
    lvars sum = 0;
    lvars fib_list;
    [%
    while t < 4000000 do
        fib(i) -> t;
        if t mod 2 = 0 then
            t + sum -> sum;
            t;
        endif;
        i + 1 -> i
    endwhile
    %]->fib_list;
    sum=>
    fib_list=>
    
enddefine;

'problem2_nomemo'=>
problem2_nomemo()=>

'problem2()'=>
problem2()=>;

'problem2a()'=>
problem2a()=>;

'problem2b()'=>
problem2b()=>
