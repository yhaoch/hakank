%
% xkcd Knapsack (subset sum) problem in Minizinc.
%
%  http://xkcd.com/287/
%
% Some amount (or none) of each dish should be ordered to give a 
% total of exact 15.05.
%
% This was created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also http://www.hakank.org/answer_set_programming/
%


#const total = 1505.

#const n = 10.
amount(0..n).

food(mixed_fruit;french_fries;side_salad;host_wings;mozzarella_sticks;samples_place).

price(mixed_fruit,215).
price(french_fries,275).
price(side_salad,335).
price(host_wings,355).
price(mozzarella_sticks,420).
price(samples_place,580).

prices(P) :- price(_, P).

% each food has exactly one amount
1 { food_amount(Food, Amount) : amount(Amount) } 1 :- food(Food).
                                                      
% prices sums to total (1505).
% change total with
%     clingo -c total=1506 xkcd.lp    
%
total [ food_amount(F, Amount) : price(F, Price) : prices(Price) : amount(Amount) = Price*Amount ] total.

#hide.
#show food_amount(Food, Amount).