not_prime(1).

add_map_min_div(X, Min_div) :-
	mpa_min_div(X, Y), !.
	
add_map_min_div(X, Min_div) :-
	assert(map_min_div(X, Min_div)), !.

for_one_prime(X, I, N, Shift) :-
	I < N,
	assert(not_prime(I)),
	add_map_min_div(I, X),
	Shifted_I is I + Shift,
	for_one_prime(X, Shifted_I, N, Shift).

% :NOTE: Передавать индекс явно
erat_sieve(I, N) :-
	not not_prime(I),
	add_map_min_div(I, I),
	Next_I is I * I,
	for_one_prime(I, Next_I, N, I).
                     
erat_sieve(I, N) :-
	I < N,
	Next_I is I + 1,
	erat_sieve(Next_I, N).

init(MAX_N) :-
	Fin is MAX_N + 1,
	erat_sieve(2, Fin), !.

prime(X) :- not not_prime(X).

composite(X) :- X > 3, not_prime(X).

find_ans_num(Num, I, [], Num) :- !.

find_ans_num(Cur, I, [H | T], Num) :- 
	prime(H),
	I =< H,
	Next_cur is Cur * H,
	find_ans_num(Next_cur, H, T, Num), !.

find_ans_div(1, []) :- !.

find_ans_div(N, Div) :-
	map_min_div(N, Min_div),
	New_N is N / Min_div,
	find_ans_div(New_N, New_Div),
	append([Min_div], New_Div, Div).
	
prime_divisors(N, Div) :- 
	list(Div),
	find_ans_num(1, 1, Div, N), !.
	
prime_divisors(N, Div) :- 
	number(N),
	find_ans_div(N, Div), !.

prime_check(P, N, N, P) :- true, !.

prime_count(P, N, I, A) :- 
	prime(A), 
	New_I is I + 1,
	prime_check(P, N, New_I, A), !.

prime_count(P, N, I, A) :- 
	prime(A), 
	New_I is I + 1,
	New_A is A + 1,
	not prime_check(P, N, New_I, A),
	prime_count(P, N, New_I, New_A), !.

prime_count(P, N, I, A) :- 
	not_prime(A),
	number(P), !, A < P,
	New_A is A + 1,
	prime_count(P, N, I, New_A).

prime_count(P, N, I, A) :- 
	not_prime(A),
	New_A is A + 1,
	prime_count(P, N, I, New_A).
	
prime_index(P, N) :- prime_count(P, N, 0, 1).