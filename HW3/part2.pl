% CSE341 Programming Languages HW3 part2
% Ahmet Denizli 161044020


% knowledge base
flight(canakkale, erzincan, 6).

flight(erzincan, canakkale, 6).
flight(erzincan, antalya, 3).

flight(antalya, erzincan, 3).
flight(antalya, diyarbakir, 4).
flight(antalya, izmir, 2).

flight(diyarbakir, antalya, 4).
flight(diyarbakir, ankara, 8).

flight(izmir, antalya, 2).
flight(izmir, ankara, 6).
flight(izmir, istanbul, 2).

flight(istanbul, izmir, 2).
flight(istanbul, ankara, 1).
flight(istanbul, rize, 4).

flight(rize, istanbul, 4).
flight(rize, ankara, 5).

flight(ankara, diyarbakir, 8).
flight(ankara, izmir, 6).
flight(ankara, istanbul, 1).
flight(ankara, rize, 5).
flight(ankara, van, 4).

flight(van, ankara, 4).
flight(van, gaziantep, 3).

flight(gaziantep, van, 3).


% rules
route(X, Y, C) :- helper_route(X, Y, C, [X]).

helper_route(X, Y, C, Z) :- 
	find_flight(X, Y, C),
	not(member(Y, Z)).

helper_route(X, Y, C, Z) :- 
	find_flight(X, T, C1),
	not(member(T, Z)),
	append([T], Z, NZ),
	helper_route(T, Y, C2, NZ),
	C is C1 + C2.

find_flight(X, Y, C) :- flight(X, Y, C).