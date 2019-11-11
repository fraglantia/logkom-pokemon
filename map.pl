%% pemain(Nama,Inventory,Xpos,Ypos).

:- dynamic pemain/4.

start :- addPemain(akill, 7, 5).
addPemain(Nama, X, Y) :- asserta(pemain(Nama, [], X, Y)).


w :- pemain(akill, L, X, Y), Ynew is (Y-1), retract(pemain(akill, _, _, _)), asserta(pemain(akill, L, X, Ynew)).
a :- pemain(akill, L, X, Y), Xnew is (X-1), retract(pemain(akill, _, _, _)), asserta(pemain(akill, L, Xnew, Y)).
s :- pemain(akill, L, X, Y), Ynew is (Y+1), retract(pemain(akill, _, _, _)), asserta(pemain(akill, L, X, Ynew)).
d :- pemain(akill, L, X, Y), Xnew is (X+1), retract(pemain(akill, _, _, _)), asserta(pemain(akill, L, Xnew, Y)).


printlist([]).

printlist([X|List]) :-
	write(X),nl,
	printlist(List).

readMap(InStream,Chars):-
	get_code(InStream,Char),
	checkChar(Char,Chars,InStream).

checkChar(-1,[],_):-  !.
checkChar(end_of_file,[],_):-  !.
checkChar(Char,[Char|Chars],InStream):-
	get_code(InStream,NextChar),
	checkChar(NextChar,Chars,InStream).


replace([_|T], X, 0, [X|T]).
replace([H|T], X, Pos, [H|B]) :- Pos > 0, Posmin1 is Pos-1, replace(T, X, Posmin1, B).

%% (X, Y) = 24*Y + 2*X
replaceCoor(Chars, X, Y, Symbol, Replaced) :- Pos is  (24*Y + 2*X), replace(Chars, Symbol, Pos, Replaced).

map :-
	open('peta.txt',read,Str),
	readMap(Str, Chars),
	pemain(akill, _, X, Y),
	%% 80 = charcode P
	replaceCoor(Chars, X, Y, 80, MapwithP),
	atom_codes(M,MapwithP),
	%% printlist(M),
	close(Str),
	write(M),  nl.




