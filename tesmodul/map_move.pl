%% ================= MAP =================
readMap(InStream,Chars):-
	get_code(InStream,Char),
	checkChar(Char,Chars,InStream).

checkChar(-1,[],_):-  !.
checkChar(end_of_file,[],_):-  !.
checkChar(Char,[Char|Chars],InStream):-
	get_code(InStream,NextChar),
	checkChar(NextChar,Chars,InStream).

%% (X, Y) = 24*Y + 2*X
replaceCoor(Chars, X, Y, Symbol, Replaced) :- Pos is  (60*Y + 2*X), replace(Chars, Symbol, Pos, Replaced).

cls :- shell(cls).

map :- donePlayer(_), write('Anda belum memilih player!'),!.
map :- doneTokemon(_), write('Anda belum memilih tokemon!'),!.
map :-
	pemain(_, _, X, Y, Map),
	getMap(Map,Mapname),
	open(Mapname,read,Str), !,
	readMap(Str, Chars),
	%% 80 = charcode P
	relative_coor(Map, Xoffs, Yoffs),
	Xrel is X+Xoffs, Yrel is Y+Yoffs,
	replaceCoor(Chars, Xrel, Yrel, 80, MapwithP),
	atom_codes(M,MapwithP),
	close(Str),
	cls,
	write(M),  nl,
	!.

handleMapChange :-
	pemain(_, _, X, Y, _),
	X>=0, X=<19, Y>=0, Y=<16,
	retract(pemain(Nama, Inv, X, Y, _)), 
	asserta(pemain(Nama, Inv, X, Y, tl)), !.

handleMapChange :-
	pemain(_, _, X, Y, _),
	X>=20, X=<50, Y>=0, Y=<13,
	retract(pemain(Nama, Inv, X, Y, _)), 
	asserta(pemain(Nama, Inv, X, Y, tr)), !.

handleMapChange :-
	pemain(_, _, X, Y, _),
	X>=0, X=<28, Y>=17, Y=<30,
	retract(pemain(Nama, Inv, X, Y, _)), 
	asserta(pemain(Nama, Inv, X, Y, bl)), !.

handleMapChange :-
	pemain(_, _, X, Y, _),
	X>=29, X=<50, Y>=14, Y=<30,
	retract(pemain(Nama, Inv, X, Y, _)), 
	asserta(pemain(Nama, Inv, X, Y, br)), !.

mn :- 
	pemain(_, _, X, Y, Map), !,
	Map = bl, X=18, Y=20,
	assertz(stat_tokemon(999,missingno,999,999)),
	%retract(inFight(_, _, _, _)),
	asserta(inFight(999, -1, 0, 1)),
	nl, write('Anda melawan ############!'), nl,
	sleep(1), write('.'), sleep(1), write('.'), sleep(1), write('.'), sleep(1), nl, nl,
	write('. you cannot run from ############ .'), nl,
	sleep(3),
	write('. death is inevitable .'), nl, nl,
	sleep(3),
	pemain(_, L, _, _, _),
	write('Choose your Tokemon!'), nl,
	write('Available Tokemons: ['), writeAvailable(L), write(']'), nl, !.
	

%% ================= MOVE =================
getAscii(Symbol,X,Y,Map) :-
	getMap(Map,Mapname),
	open(Mapname,read,Str), !,
	readMap(Str,Chars),
	getCharMap(Chars, X, Y, Symbol).

cekAscii(Symbol,X) :- Symbol == X.

cekPeta(Map, Xnext, Ynext, _, Xnew, Ynew) :-
	%% relative offsets
	relative_coor(Map, Xoffs, Yoffs),
	Xrel is Xnext+Xoffs, Yrel is Ynext+Yoffs,
	getAscii(Symbol,Xrel,Yrel,Map),
	\+cekAscii(Symbol,88),
	\+cekAscii(Symbol,61),
	\+cekAscii(Symbol,64),
	\+cekAscii(Symbol,47),
	\+cekAscii(Symbol,92),
	Xnew is Xnext,
	Ynew is Ynext.

cekPeta(_, Xnext, Ynext, w, Xnew, Ynew) :-
	write('*thunk*'), nl,
	Xnew is Xnext,
	Ynew is (Ynext+1).

cekPeta(_, Xnext, Ynext, s, Xnew, Ynew) :-
	write('*thunk*'), nl,
	Xnew is Xnext,
	Ynew is (Ynext-1).

cekPeta(_, Xnext, Ynext, a, Xnew, Ynew) :-
	write('*thunk*'), nl,
	Xnew is (Xnext+1),
	Ynew is Ynext.

cekPeta(_, Xnext, Ynext, d, Xnew, Ynew) :-
	write('*thunk*'), nl,
	Xnew is (Xnext-1),
	Ynew is Ynext.

getCharMap(Chars, X, Y, Symbol) :- Pos is (60*Y + 2*X), getChar(Chars, Symbol, Pos).

w :- donePlayer(_), write('Anda belum memilih player!'),!.
w :- doneTokemon(_), write('Anda belum memilih tokemon!'),!.
w :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
w :-
	pemain(Name, L, X, Y, Map),
	Ynext is (Y-1),
	cekPeta(Map, X, Ynext, w, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)),
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
	handleMapChange,
	map, !,
	handleGym,
    (randomWildTokemon(Id),
	meetWild(Id)).

s :- donePlayer(_), write('Anda belum memilih player!'),!.
s :- doneTokemon(_), write('Anda belum memilih tokemon!'),!.
s :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
s :- 
	pemain(Name, L, X, Y, Map),
	Ynext is (Y+1), 
	cekPeta(Map, X, Ynext, s, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)), 
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
	handleMapChange,
	map, !,
	handleGym,
	mn, !,
    (randomWildTokemon(Id),
	meetWild(Id)).

a :- donePlayer(_), write('Anda belum memilih player!'),!.
a :- doneTokemon(_), write('Anda belum memilih tokemon!'),!.
a :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
a :- 
	pemain(Name, L, X, Y, Map),
	Xnext is (X-1), 
	cekPeta(Map, Xnext, Y, a, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)), 
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
	handleMapChange,
	map, !,
	handleGym,
    (randomWildTokemon(Id),
	meetWild(Id)).

d :- donePlayer(_), write('Anda belum memilih player!'),!.
d :- doneTokemon(_), write('Anda belum memilih tokemon!'),!.
d :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
d :- 
	pemain(Name, L, X, Y, Map),
	Xnext is (X+1), 
	cekPeta(Map, Xnext, Y, d, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)), 
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
	handleMapChange,
	map, !,
	handleGym,
    (randomWildTokemon(Id),
	meetWild(Id)).
