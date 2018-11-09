% program for solving Cracker Barrel Peg Jump puzzle
% CSCE 4430

% special thanks to http://sandbox.mc.edu/~bennet/cs404/doc/jump2_pl.html

% Legal jumps along a line.
linjmp([x, x, o | T], [o, o, x | T]). % right jump
linjmp([o, x, x | T], [x, o, o | T]). % left jump
linjmp([H|T1], [H|T2]) :- linjmp(T1,T2).

% Rotate the board: treats diagonal jumps as horizontal jumps
rotate([ [A], [B, C], [D, E, F], [G, H, I, J], [K, L, M, N, O]],
        [ [K], [L, G], [M, H, D], [N, I, E, B], [O, J, F, C, A]]).

% A jump on some line.
horizjmp([A|T],[B|T]) :- linjmp(A,B).
horizjmp([H|T1],[H|T2]) :- horizjmp(T1,T2).

% One legal jump.
jump(B,A) :- horizjmp(B,A).
jump(B,A) :- rotate(B,BR), horizjmp(BR,BRJ), rotate(A,BRJ).
jump(B,A) :- rotate(BR,B), horizjmp(BR,BRJ), rotate(BRJ,A).

% Series of legal boards.
series(From, To, [From, To]) :- jump(From, To).
series(From, To, [From, By | Rest])
        :- jump(From, By), 
           series(By, To, [By | Rest]).

% Print a series of boards.
print_series_r([]) :- 
    write_ln(' ').
print_series_r([X|Y]) :- write_ln(X), print_series_r(Y).
print_series(Z) :- 
    write_ln('\n========='),
    print_series_r(Z).

% A solution.
solution(L) :- series([[o], [x, x], [x, x, x], [x, x, x, x], [x, x, x, x, x]],
                   [[x], [o, o], [o, o, o], [o, o, o, o], [o, o, o, o, o]], L).

% Find a print the first solution.  
solve :- solution(X), print_series(X).

% Find all the solutions.
solveall :- solve, fail.

% Find first five solutions.
go :- foreach(between(1,5,_),solve).

% This finds each solution with stepping.
solvestep(Z) :- Z = next, solution(X), print_series(X).