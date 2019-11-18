%% All map and move related functions are handled here


%% ================= MAP =================
readMap(InStream,Chars):-
	get_code(InStream,Char),
	checkChar(Char,Chars,InStream).

checkChar(-1,[],_):-  !.
checkChar(end_of_file,[],_):-  !.
checkChar(Char,[Char|Chars],InStream):-
	get_code(InStream,NextChar),
	checkChar(NextChar,Chars,InStream).

%% (X, Y) = 60*Y + 2*X
replaceCoor(Chars, X, Y, Symbol, Replaced) :- Pos is  (60*Y + 2*X), replace(Chars, Symbol, Pos, Replaced).

map :- donePlayer(_), write('Anda belum memilih player!'),!.
map :- doneTokemon(_), write('Anda belum memilih tokemon!'),!.
map :-
	pemain(_, _, X, Y, Map),
	getMap(Map,Mapname),
	open(Mapname,read,Str), !,
	readMap(Str, Chars),
	relative_coor(Map, Xoffs, Yoffs),
	Xrel is X+Xoffs, Yrel is Y+Yoffs,
	%% 80 = charcode P
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
	\+cekAscii(Symbol,124),
	\+cekAscii(Symbol,79),
	\+cekAscii(Symbol,111),
	Xnew is Xnext,
	Ynew is Ynext.

cekPeta(_, Xnext, Ynext, w, Xnew, Ynew) :-
	write('*thunk*'), nl,
	sleep(0.5),
	Xnew is Xnext,
	Ynew is (Ynext+1).

cekPeta(_, Xnext, Ynext, s, Xnew, Ynew) :-
	write('*thunk*'), nl,
	sleep(0.5),
	Xnew is Xnext,
	Ynew is (Ynext-1).

cekPeta(_, Xnext, Ynext, a, Xnew, Ynew) :-
	write('*thunk*'), nl,
	sleep(0.5),
	Xnew is (Xnext+1),
	Ynew is Ynext.

cekPeta(_, Xnext, Ynext, d, Xnew, Ynew) :-
	write('*thunk*'), nl,
	sleep(0.5),
	Xnew is (Xnext-1),
	Ynew is Ynext.

getCharMap(Chars, X, Y, Symbol) :- Pos is (60*Y + 2*X), getChar(Chars, Symbol, Pos).

isLevelUp(Exp,ExpMax) :- Exp > ExpMax.

w :- donePlayer(_), write('Anda belum memilih player!'),!.
w :- doneTokemon(_), write('Anda belum memilih tokemon!'),!.
w :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
w :- 
	tokemonExpUp(Id,ExpUp), stat_tokemon(Id,Name,H,Level,Exp,ExpMax), ExpNew is (Exp + ExpUp),((\+ isLevelUp(ExpNew,ExpMax)), 
	retract(stat_tokemon(Id,Name,H,Level,Exp,ExpMax)),
	write('Yeay Exp '), write(Name), write(' naik +'), write(ExpUp), write('!'), nl,
	asserta(stat_tokemon(Id,Name,H,Level,ExpNew,ExpMax)), retract(tokemonExpUp(Id,ExpUp))), !.
w :- 
	tokemonExpUp(Id,ExpUp),(retract(stat_tokemon(Id,Name,_,Level,Exp,ExpMax)), ExpTemp is (Exp + ExpUp),
	isLevelUp(ExpTemp,ExpMax), ExpNew is (ExpTemp-ExpMax), ExpMaxNew is (ExpMax + 50), LevelUp is (Level + 1), max_Health(Name,LevelUp, HNew),
	write('Tokemon '), write(Name), write(' naik level menjadi level '), write(LevelUp), write('!'),
	asserta(stat_tokemon(Id,Name,HNew,LevelUp,ExpNew,ExpMaxNew)), retract(tokemonExpUp(Id,ExpUp))), !.
w :-
	pemain(Name, L, X, Y, Map),
	Ynext is (Y-1),
	cekPeta(Map, X, Ynext, w, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)),
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
	handleMapChange,
	map, !,
	handleGym, handleLegend,
    (inGym(0), inLegend(0), randomWildTokemon(Id),
	meetWild(Id)).

s :- donePlayer(_), write('Anda belum memilih player!'),!.
s :- doneTokemon(_), write('Anda belum memilih tokemon!'),!.
s :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
s :- 
	tokemonExpUp(Id,ExpUp), stat_tokemon(Id,Name,H,Level,Exp,ExpMax), ExpNew is (Exp + ExpUp),((\+ isLevelUp(ExpNew,ExpMax)), 
	retract(stat_tokemon(Id,Name,H,Level,Exp,ExpMax)),
	write('Yeay Exp '), write(Name), write(' naik +'), write(ExpUp), write('!'), nl,
	asserta(stat_tokemon(Id,Name,H,Level,ExpNew,ExpMax)), retract(tokemonExpUp(Id,ExpUp))), !.
s :- 
	tokemonExpUp(Id,ExpUp),(retract(stat_tokemon(Id,Name,_,Level,Exp,ExpMax)), ExpTemp is (Exp + ExpUp),
	isLevelUp(ExpTemp,ExpMax), ExpNew is (ExpTemp-ExpMax), ExpMaxNew is (ExpMax + 50), LevelUp is (Level + 1), max_Health(Name,LevelUp, HNew),
	write('Tokemon '), write(Name), write(' naik level menjadi level '), write(LevelUp), write('!'),
	asserta(stat_tokemon(Id,Name,HNew,LevelUp,ExpNew,ExpMaxNew)), retract(tokemonExpUp(Id,ExpUp))), !.
s :- 
	pemain(Name, L, X, Y, Map),
	Ynext is (Y+1), 
	cekPeta(Map, X, Ynext, s, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)), 
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
	handleMapChange,
	map, !,
	handleGym, handleLegend,
    (inGym(0), inLegend(0), (mn; (randomWildTokemon(Id),
	meetWild(Id)))),
	!.

a :- donePlayer(_), write('Anda belum memilih player!'),!.
a :- doneTokemon(_), write('Anda belum memilih tokemon!'),!.
a :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
a :- 
	tokemonExpUp(Id,ExpUp), stat_tokemon(Id,Name,H,Level,Exp,ExpMax), ExpNew is (Exp + ExpUp),((\+ isLevelUp(ExpNew,ExpMax)), 
	retract(stat_tokemon(Id,Name,H,Level,Exp,ExpMax)),
	write('Yeay Exp '), write(Name), write(' naik +'), write(ExpUp), write('!'), nl,
	asserta(stat_tokemon(Id,Name,H,Level,ExpNew,ExpMax)), retract(tokemonExpUp(Id,ExpUp))), !.
a :- 
	tokemonExpUp(Id,ExpUp),(retract(stat_tokemon(Id,Name,_,Level,Exp,ExpMax)), ExpTemp is (Exp + ExpUp),
	isLevelUp(ExpTemp,ExpMax), ExpNew is (ExpTemp-ExpMax), ExpMaxNew is (ExpMax + 50), LevelUp is (Level + 1), max_Health(Name,LevelUp, HNew),
	write('Tokemon '), write(Name), write(' naik level menjadi level '), write(LevelUp), write('!'),
	asserta(stat_tokemon(Id,Name,HNew,LevelUp,ExpNew,ExpMaxNew)), retract(tokemonExpUp(Id,ExpUp))), !.
a :- 
	pemain(Name, L, X, Y, Map),
	Xnext is (X-1), 
	cekPeta(Map, Xnext, Y, a, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)), 
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
	handleMapChange,
	map, !,
	handleGym, handleLegend,
    (inGym(0), inLegend(0), randomWildTokemon(Id),
	meetWild(Id)).

d :- donePlayer(_), write('Anda belum memilih player!'),!.
d :- doneTokemon(_), write('Anda belum memilih tokemon!'),!.
d :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
d :- 
	tokemonExpUp(Id,ExpUp), stat_tokemon(Id,Name,H,Level,Exp,ExpMax), ExpNew is (Exp + ExpUp),((\+ isLevelUp(ExpNew,ExpMax)), 
	retract(stat_tokemon(Id,Name,H,Level,Exp,ExpMax)),
	write('Yeay Exp '), write(Name), write(' naik +'), write(ExpUp), write('!'), nl,
	asserta(stat_tokemon(Id,Name,H,Level,ExpNew,ExpMax)), retract(tokemonExpUp(Id,ExpUp))), !.
d :- 
	tokemonExpUp(Id,ExpUp),(retract(stat_tokemon(Id,Name,_,Level,Exp,ExpMax)), ExpTemp is (Exp + ExpUp),
	isLevelUp(ExpTemp,ExpMax), ExpNew is (ExpTemp-ExpMax), ExpMaxNew is (ExpMax + 50), LevelUp is (Level + 1), max_Health(Name,LevelUp, HNew),
	write('Tokemon '), write(Name), write(' naik level menjadi level '), write(LevelUp), write('!'),
	asserta(stat_tokemon(Id,Name,HNew,LevelUp,ExpNew,ExpMaxNew)), retract(tokemonExpUp(Id,ExpUp))), !.
d :- 
	pemain(Name, L, X, Y, Map),
	Xnext is (X+1), 
	cekPeta(Map, Xnext, Y, d, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)), 
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
	handleMapChange,
	map, !,
	handleGym, handleLegend,
    (inGym(0), inLegend(0), randomWildTokemon(Id),
	meetWild(Id)).





%% =================  ga penting  =================
mn :- 
	pemain(_, _, X, Y, Map), !,
	Map = bl, X=18, Y=20,
	assertz(stat_tokemon(999,missingno,999,999,999,999)),
	asserta(inFight(999, -1, 0, 1)),
	nl, write('Anda melawan ############!'), nl,
	sleep(1), write('.'), sleep(1), write('.'), sleep(1), write('.'), sleep(1), nl, nl,
	write('. you cannot run from ############ .'), nl,
	sleep(1), nl, sleep(1), nl, sleep(1), nl,
	write('. death is inevitable .'), nl,
	sleep(1), nl, sleep(1), nl, sleep(1), nl,
	pemain(_, L, _, _, _),
	write('Choose your Tokemon!'), nl,
	write('Available Tokemons: ['), writeAvailable(L), write(']'), nl, 
	write('pick/2 : ID,NamaTokemon'), nl, !.
