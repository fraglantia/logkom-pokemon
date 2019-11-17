% Gambaran Tugas Besar IF2121 Logika Komputasional
% Kelompok    :   09
% Kelas       :   03
% Anggota     :   - 13518018/Steve Bezalel Imam Gustaman
%                 - 13518057/Muhammad Daru Darmakusuma
%                 - 13518096/Naufal Arfananda Ghifari
%                 - 13518135/Gregorius Jovan Kresnadi



/* --- Deklarasi Fakta --- */
%% pemain(Nama,Inventory,Xpos,Ypos).
%% stat_tokemon(Id,Nama,Curr_Health,Level,Exp,ExpMax).
%% normal_attack(Nama_Attack,Base_Damage).
%% special_attack(Nama_Special,Base_Damage).
%% potion(Jumlah).
%% jenis_tokemon(Nama,Tipe,Base_Health,Nama_Attack,Nama_Special,Legend_or_normal).
%% tipeModifier(FromTipe, ToTipe, Modf).

jenis_tokemon(missingno,entah,999,att,spec,0).
jenis_tokemon(karma_nder,fire,60,duarr,nmax,0).
jenis_tokemon(kompor_gas,fire,60,bom,bitu,0).
jenis_tokemon(tukangair,water,60,ciprat,sebor,0).
jenis_tokemon(lumud,leaves,100,kepelesed,badmud,0).
jenis_tokemon(rerumputan,leaves,60,lambai,bergoyang,0).
jenis_tokemon(sugiono,water,69,genjot,crot,0).
jenis_tokemon(sesasasosa,leaves,125,sekali,tujuhkali,1).
jenis_tokemon(edukamon,leaves,135,startup,bukalepek,0).
jenis_tokemon(abhaigimon,water,182,warga,turun,0).
jenis_tokemon(martabak,earth,60,mamet,bowo,0).
jenis_tokemon(mumu,wind,60,badai,topan,0).
jenis_tokemon(gledek,lightning,60,halilintar,atta,0).
jenis_tokemon(hiring,lightning,120,sekip,debat,0).
jenis_tokemon(danus,earth,100,paid,promote,0).
jenis_tokemon(tubes,water,110,kelar,dong,1).


normal_attack(att,99).
normal_attack(duarr,30).
normal_attack(bom,30).
normal_attack(ciprat,20).
normal_attack(kepelesed,20).
normal_attack(lambai,20).
normal_attack(genjot,40).
normal_attack(sekali,40).
normal_attack(startup,40).
normal_attack(warga,50).
normal_attack(mamet,20).
normal_attack(badai,20).
normal_attack(halilintar,20).
normal_attack(sekip,40).
normal_attack(paid,30).
normal_attack(kelar,40).

special_attack(spec,-99).
special_attack(nmax,40).
special_attack(bitu,40).
special_attack(sebor,30).
special_attack(badmud,30).
special_attack(bergoyang,30).
special_attack(crot,30).
special_attack(tujuhkali,77).
special_attack(bukalepek,65).
special_attack(turun,200).
special_attack(bowo,60).
special_attack(topan,60).
special_attack(atta,70).
special_attack(debat,30).
special_attack(promote,69).
special_attack(dong,69).


%%fire<water<lightning<earth<leaves<wind<fire
%% from fire
tipeModifier(fire, fire, 1.0).
tipeModifier(fire, water, 0.5).
tipeModifier(fire, leaves, 1.5).
tipeModifier(fire, leaves, 1.0).
tipeModifier(fire, lightning, 1.0).
tipeModifier(fire, wind, 1.5).
tipeModifier(fire, earth, 1.0).
%% from water
tipeModifier(water, fire, 1.5).
tipeModifier(water, water, 1.0).
tipeModifier(water, leaves, 0.5).
%% from water
tipeModifier(leaves, fire, 0.5).
tipeModifier(leaves, water, 1.5).
tipeModifier(water, leaves, 1.0).
tipeModifier(water, lightning, 0.5).
tipeModifier(water, wind, 1.0).
tipeModifier(water, earth, 1.0).
%% from leaves
tipeModifier(leaves, fire, 1.0).
tipeModifier(leaves, water, 1.0).
tipeModifier(leaves, leaves, 1.0).
tipeModifier(leaves, lightning, 1.0).
tipeModifier(leaves, wind, 0.5).
tipeModifier(leaves, earth, 1.5).
%% from lightning
tipeModifier(lightning, fire, 1.0).
tipeModifier(lightning, water, 1.5).
tipeModifier(lightning, leaves, 1.0).
tipeModifier(lightning, lightning, 1.0).
tipeModifier(lightning, wind, 1.0).
tipeModifier(lightning, earth, 0.5).
%% from wind
tipeModifier(wind, fire, 0.5).
tipeModifier(wind, water, 1.0).
tipeModifier(wind, leaves, 1.5).
tipeModifier(wind, lightning, 1.0).
tipeModifier(wind, wind, 1.0).
tipeModifier(wind, earth, 1.0).
% %% from earth
tipeModifier(earth, fire, 1.0).
tipeModifier(earth, water, 1.0).
tipeModifier(earth, leaves, 0.5).
tipeModifier(earth, lightning, 1.5).
tipeModifier(earth, wind, 1.0).
tipeModifier(earth, earth, 1.0).

% PETA
getMap(tl,'assets/petaTL.txt').
getMap(tr,'assets/petaTR.txt').
getMap(bl,'assets/petaBL.txt').
getMap(br,'assets/petaBR.txt').

%% GYM LOCATION (X, Y)
gym_location(3,5).

%% RELATIVE LOC COORDINATE CHANGE (peta, X, Y)
relative_coor(tl, 0, 0).
relative_coor(tr, -19, 0).
relative_coor(bl, 0, -16).
relative_coor(br, -29, -13).

/* --- Deklarasi Rules --- */
%% start.
%% help.
%% quit.
%% w.
%% a.
%% s.
%% d. /* Untuk bergerak di map */
%% map. /* melihat map */
%% heal.	 hanya dapat dilakukan jika memiliki potion atau sedang di gym 
%% status.
%% pick(Nama).
%% attack.
%% specialAttack.
%% run.
%% drop(Nama).
%% Save(Namafile).
%% Load(Namafile).


%% START

:- dynamic(pemain/5).
:- dynamic(inFight/4).
:- dynamic(mayCapture/2).
:- dynamic(tokemonCount/1).
:- dynamic(stat_tokemon/6).
:- dynamic(donePlayer/1).
:- dynamic(doneTokemon/1).
:- dynamic(inGym/1).
:- dynamic(tokemonExpUp/2).
:- dynamic(inLegend/1).

%% pemain(Nama,Inventory,Xpos,Ypos,Map).
%% inFight(EnemyId, MyId, Can_Run, Can_Special). MyId if belom pick = -1, Can_Run 1/0, Can_Special 1/0
%% mayCapture(Yes/No, Id) 1/0
%% tokemonCount(Counter).
%% stat_tokemon(Id,Nama,Curr_Health,Level,Exp,ExpMax).
%% inLegend(X), X=0 -> NO, X=1 -> LEAVES, X=2 -> WATER

start :- 
	retractall(pemain(_, _, _, _,_)),
	retractall(stat_tokemon(_, _, _, _, _, _)),
	retractall(inFight(_, _, _, _)),
	retractall(mayCapture(_, _)),
	retractall(tokemonCount(_)),
	retractall(donePlayer(_)),
	retractall(doneTokemon(_)),
	retractall(inGym(_)),
	retractall(inLegend(_)),
	asserta(donePlayer(0)),
	title,
	write('Siapa Anda? choosePlayer/1: akill, jun-go, atau (Nama bebas).'),
	asserta(doneTokemon(0)),
	asserta(tokemonCount(0)),
	asserta(mayCapture(0, -1)),
	asserta(inGym(0)),
	asserta(inLegend(0)).

title :-
	open('assets/title.txt',read,Str), !,
	readMap(Str, CharT),
	atom_codes(T,CharT),
	close(Str),
	cls,
	write(T),  nl,
	!.


%% todo initialize tokemons
tokemonInit(karma_nder).
tokemonInit(tukangair).
tokemonInit(lumud).
choosePlayer(Name) :- 
	addPemain(Name,10,1,tl), 
	retract(donePlayer(_)), 
	(write(Name), write(' pilih tokemon Anda terlebih dahulu!'), nl,
	write('chooseTokemon/1: karma_nder (Fire), tukangair (Water), atau lumud (Leaf)!')).
chooseTokemon(_) :- donePlayer(_), write('Pilih player terlebih dahulu!'), !.
chooseTokemon(Tokemon) :- (\+ tokemonInit(Tokemon)), write('Tokemon tidak ada dalam pilihan!'), !.
chooseTokemon(Tokemon) :- addTokemon(Tokemon,1,0), add2InvTokemon(0), retract(doneTokemon(_)), addWildTokemon.

addWildTokemon :- 
	%% add legendaries at (FIX ID 1 AND 2)
	addTokemon(sesasasosa, 100, 0),
	addTokemon(tubes, 100, 0).
	%% addTokemon(martabak, 1, 0).

%% SAVE/LOAD 
%% note: filename harus pake kutip

savefile(Filename) :-
	open(Filename, write, Str),
	writeFacts(Str),
	close(Str).

writeFacts(Str) :-
	forall(donePlayer(X), (write(Str,'donePlayer('), write(Str,X), write(Str,').\n'))),
	forall(doneTokemon(X), (write(Str,'doneTokemon('), write(Str,X), write(Str,').\n'))),
	forall(inGym(X), (write(Str,'inGym('), write(Str,X), write(Str,').\n'))),
	forall(pemain(Name, L, X, Y, Map), (write(Str,'pemain('), write(Str,Name), write(Str,','), write(Str,L), write(Str,','), write(Str,X), write(Str,','), write(Str,Y), write(Str,','), write(Str,Map),write(Str,').\n'))),
	forall(mayCapture(YesNo, IdC), (write(Str,'mayCapture('), write(Str,YesNo), write(Str,','), write(Str,IdC), write(Str,').\n'))),
	forall(inFight(EnemyId, MyId, Can_Run, Can_Special), (write(Str,'inFight('), write(Str,EnemyId), write(Str,','), write(Str,MyId), write(Str,','), write(Str,Can_Run), write(Str,','), write(Str,Can_Special), write(Str,').\n'))),
	forall(tokemonCount(C), (write(Str,'tokemonCount('), write(Str,C), write(Str,').\n'))),
	forall(stat_tokemon(Id,Nama,Health,Lvl,Exp,ExpMax), (write(Str,'stat_tokemon('), write(Str,Id), write(Str,','), write(Str,Nama), write(Str,','), write(Str,Health), write(Str,','), write(Str,Lvl), write(Str,','), write(Str,Exp), write(Str,','), write(Str,ExpMax), write(Str,').\n'))).


loadfile(Filename) :-
	open(Filename, read, Str),
	retractall(donePlayer(_)),
	retractall(doneTokemon(_)),
	retractall(inGym(_)),
	retractall(pemain(_, _, _, _, _)),
	retractall(stat_tokemon(_, _, _, _, _, _)),
	retractall(inFight(_, _, _, _)),
	retractall(mayCapture(_, _)),
	retractall(tokemonCount(_)),
	readFacts(Str,Facts),
	close(Str),
	process(Facts), nl, !.

process([]) :- !.

process([H|T]) :- 
	H \= end_of_file,
	asserta(H),
	process(T).

readFacts(Str, []):-
	at_end_of_stream(Str), !.

readFacts(Str, [H|T]):-
	\+at_end_of_stream(Str),
	read(Str, H),
	readFacts(Str, T).

addPemain(Nama, X, Y, Map) :- asserta(pemain(Nama, [], X, Y, Map)).

%% ================= UTILITY =================
%% DEBUG PRINT LIST
printlist([]).
printlist([X|List]) :-
	write(X),nl,
	printlist(List).

%% COUNT N LIST
count([],0).
count([_|T],N) :-
	count(T, N1),
	N is N1+1, !.


%% REPLACE FOR MAP
replace([_|T], X, 0, [X|T]).
replace([H|T], X, Pos, [H|B]) :- Pos > 0, Posmin1 is Pos-1, replace(T, X, Posmin1, B).

%% GET CHAR FOR MAP
getChar([H|_], X, 0) :- X is H.
getChar([_|T], X, Pos) :- Pos > 0, Posmin1 is Pos-1, getChar(T, X, Posmin1).


%% ISLISTMEMBER
isMember(X, [X|_]) :- !.
isMember(X, [_|T]):- isMember(X, T).

%% RANDOM
randInterval(X, X, X) :- !.
randInterval(X, A, B) :- random(R), X is floor((B-A+1)*R)+A.

%% ================= STAT_TOKEMON =================
wildTokemon(Id) :- pemain(_, L, _, _, _), \+isMember(Id, L).
legendaryTokemon(Id) :- stat_tokemon(Id, Nama, _, _, _, _), jenis_tokemon(Nama, _, _, _, _, 1).

%% H adalah max health dari tokemon Nama pada level Level
max_Health(Nama, Level, H) :- 
	jenis_tokemon(Nama, _, Base, _, _, _), 
	H is ceiling((Level-1) * (Base*0.1) + Base).

%% todo : damage modifier dari base

%% menambahkan satu pada tokemonCount untuk id
incTokemonCount :- 
	tokemonCount(X), 
	Xnew is (X+1), 
	retract(tokemonCount(_)), 
	asserta(tokemonCount(Xnew)).

%% menambahkan tokemon Nama dengan level Level dengan id tokemoncount
addTokemon(Nama, Level, Exp) :- 
	tokemonCount(Id), 
	max_Health(Nama, Level, H),
	ExpMax is 100 + (50*(Level-1)),
	assertz(stat_tokemon(Id, Nama, H, Level, Exp, ExpMax)), 
	incTokemonCount.

%% menambahkan tokemon dengan id Id ke inventory pemain
add2InvTokemon(Id) :- 
	pemain(Name, L, X, Y, Map),
	append(L, [Id], Lnew),
	retract(pemain(_, _, _, _, _)),
	asserta(pemain(Name, Lnew, X, Y, Map)).

%$ ================= INVENTORY =================
notMaxInv :-
	pemain(_, L, _, _, _),
	count(L, N),
	%% maxinventory(X),
	N<6.

deleteFromInv(Id) :-
	pemain(Name, L, X, Y, Map),
	delete(L, Id, NewL),
	retract(pemain(_, _, _, _, _)),
	asserta(pemain(Name, NewL, X, Y, Map)).


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
    (inGym(0), inLegend(0), randomWildTokemon(Id),
	meetWild(Id)).

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


%% ================= GYM & HEAL =================

handleGym :- 
	pemain(_, _, X, Y, _),
	gym_location(A, B),
	(X \= A; Y \= B),
	retract(inGym(_)), 
	asserta(inGym(0)), !.

handleGym :-
	pemain(_, _, X, Y, _),
	gym_location(X, Y),
	retract(inGym(_)),
	write('Anda memasuki gym!'), nl,
	asserta(inGym(1)).

%askHeal

heal :- inGym(X), X = 0, write('Anda tidak sedang berada di gym!'), nl, !.
heal :- 
	inGym(X), X = 1,
	pemain(_, L, _, _, _),
	write('Nyawa tokemon anda kembali penuh!'),
	healList(L).


healList([]) :- !.
healList([Id|T]) :-
%% Id,Nama,Curr_Health,Level
	stat_tokemon(Id, Nama, _, Level,Exp,ExpMax),
	max_Health(Nama, Level, Max_H),
	retract(stat_tokemon(Id, _, _, _, _, _)),
	assertz(stat_tokemon(Id, Nama, Max_H, Level,Exp,ExpMax)),
	healList(T).


%% ================= GYM & HEAL =================


%% ================= LEGEND =================

handleLegend :-
	pemain(_, _, 43, 3, _),
	retract(inLegend(_)),
	write('Anda bertemu Legendary Leaves!'), nl,
	asserta(inLegend(1)), meetLegend(1), !.

handleLegend :-
	pemain(_, _, 44, 24, _),
	retract(inLegend(_)),
	write('Anda bertemu Legendary Water!'), nl,
	asserta(inLegend(2)), meetLegend(2), !.

handleLegend :- 
	pemain(_, _, X, Y, _),
	((X \= 43, Y \= 3); (X \= 44, Y \= 24)),
	retract(inLegend(_)), 
	asserta(inLegend(0)), !.

meetLegend(Id) :-
	asserta(inFight(Id, -1, 1, 1)),
	write('Fight or Run?'), nl.

%% ================= LEGEND =================


%% RANDOMLY MEET TOKEMON
%% random id from list of wild tokemons (not including legendary)
randomWildTokemon(Id) :-
	findall(X, (stat_tokemon(X, _, _, _, _, _), wildTokemon(X), \+legendaryTokemon(X)), L),
	count(L, Len),
	IdxMax is Len-1,
	randInterval(N, 0, IdxMax),
	nth0(N, L, Id).

meetWild(Id) :-
	%% 20%
	randInterval(X, 1, 5), X=1,
	stat_tokemon(Id, Nama, _, _, _, _),
	write('A wild '), write(Nama), write(' appears!'), nl,
	asserta(inFight(Id, -1, 1, 1)),
	write('Fight or Run?'), nl.


%% ================= FIGHT =================
fight :- 
	\+inFight(_, _, _, _),
	write('Tidak ada tokemon yang bisa anda lawan.'), nl, !.
fight :-
	inFight(_, MyId, _, _),
	MyId \= -1,
	write('Ini kan lagi berantem :('), nl, !.
fight :- 
	inFight(Id, _, _, Can_Special),
	retract(inFight(_, _, _, _)),
	asserta(inFight(Id, -1, 0, Can_Special)),
	stat_tokemon(Id, Nama, _, _, _, _),
	write('Anda melawan '), write(Nama), write('!!'), nl,
	pemain(_, L, _, _, _),
	write('Choose your Tokemon!'), nl,
	write('Available Tokemons: ['), writeAvailable(L), write(']'), nl, !.

run :- 
	\+inFight(_, _, _, _),
	write('Lari dari apa atuh :('), nl, !.
run :- 
	inFight(_, _, 0, _),
	write('Gak bisa lari :('), nl, !.
run :- 
	%% 50%
	randInterval(X, 1, 2),
	runRandom(X).

runRandom(X) :- X=1, retract(inFight(_, _, _, _)), write('You sucessfully escaped the Tokemon!'), nl.
runRandom(X) :- X=2, write('You failed to run!'), nl, fight.

%% cari Name di Inventory ambil yg pertama if none Id = -1
inInventory(Name, Id) :- 
	findall(X, (stat_tokemon(X, _, _, _, _, _), \+wildTokemon(X)), L),
	searchNameInList(Name, L, Id).


searchNameInList(_, [], -1) :- !.

searchNameInList(Name, [Id|_], Id) :-
	stat_tokemon(Id, Name, _, _, _, _), !.

searchNameInList(Name, [_|T], Id) :-
	searchNameInList(Name, T, Id).


pick(_) :-
	\+inFight(_, _, _, _),
	write('Anda tidak dalam battle saat ini.'), nl, !.

pick(_) :-
	inFight(_, MyId, _, _),
	MyId \= -1,
	write('Anda sudah pick tokemon!'), nl, !.

pick(Name) :-
	\+jenis_tokemon(Name, _, _, _, _, _),
	write('Tidak ada tokemon bernama '),
	write(Name), write('!'), nl, !.

pick(Name) :-
	inInventory(Name, Id),
	Id = -1,
	write('Anda tidak memiliki '),
	write(Name), write('!'), nl, !.

pick(Name) :-
	inInventory(Name, Id),
	Id \= -1,
	retract(inFight(EnemyId, _, _, Can_Special)),
	asserta(inFight(EnemyId, Id, 0, Can_Special)),
	write(Name), write(', I choose you!'), nl, nl,
	writeStat(Id),
	writeStat(EnemyId), !.

drop(Name) :-
	\+jenis_tokemon(Name, _, _, _, _, _),
	write('Tidak ada tokemon bernama '),
	write(Name), write('!'), nl, !.

drop(Name) :-
	inInventory(Name, Id),
	Id = -1,
	write('Anda tidak memiliki '),
	write(Name), write('!'), nl, !.

drop(Name) :-
	inInventory(Name, Id),
	Id \= -1,
	deleteFromInv(Id),
	retract(stat_tokemon(Id, _, _, _, _, _)),
	write('You have dropped '), write(Name), write('!'), nl, 
	checkLose, !.


%% todo : how to differ 2 same pokemons : list first?

attack :- 
	\+inFight(_, _, _, _),
	write('Anda tidak dalam battle saat ini.'), nl, !.

attack :-
	inFight(_, MyId, _, _),
	MyId = -1,
	write('Anda belum pick tokemon!'), nl, !.	

attack :- 
	inFight(EnemyId, MyId, _, _),
	stat_tokemon(EnemyId, EnemyName, _, _, _, _),
	stat_tokemon(MyId, MyName, _, Level, _, _),
	jenis_tokemon(MyName, MyTipe, _, AttackName, _, _),
	jenis_tokemon(EnemyName, EnemyTipe, _, _, _, _),
	tipeModifier(MyTipe, EnemyTipe, Modf),
	normal_attack(AttackName, Dmg),
	NewDmg is floor(Dmg*Modf*Level),
	dealDmg(EnemyId, NewDmg),
	nl, write(AttackName), write('!!!'), nl,
	write('You dealt '), write(NewDmg), write(' damage to '), write(EnemyName), write('!'), nl, 
	(checkIfEnemyDead(EnemyId); enemyAttack, (writeStat(MyId), writeStat(EnemyId))), 
	checkIfTokemonPemainDead(MyId), !.

specialAttack :- 
	\+inFight(_, _, _, _),
	write('Anda tidak dalam battle saat ini.'), nl, !.

specialAttack :- 
	inFight(_, _, _, Can_Special),
	Can_Special = 0,
	write('Sudah menggunakan special attack !!'), nl, !.

specialAttack :- 
	inFight(EnemyId, MyId, Can_Run, _),
	stat_tokemon(EnemyId, EnemyName, _, _, _, _),
	stat_tokemon(MyId, MyName, _, Level, _, _),
	jenis_tokemon(MyName, MyTipe, _, _, SpecialName, _),
	jenis_tokemon(EnemyName, EnemyTipe, _, _, _, _),
	tipeModifier(MyTipe, EnemyTipe, Modf),
	special_attack(SpecialName, Dmg),
	NewDmg is floor(Dmg*Modf*Level),
	dealDmg(EnemyId, NewDmg), nl,
	retract(inFight(_, _, _, _)), 
	asserta(inFight(EnemyId, MyId, Can_Run, 0)),
	write(SpecialName), write('!!!'), nl,
	write('You dealt '), write(NewDmg), write(' damage to '), write(EnemyName), write('!'), nl,
	(checkIfEnemyDead(EnemyId); enemyAttack, (writeStat(MyId), writeStat(EnemyId))), 
	checkIfTokemonPemainDead(MyId), !.

enemyAttack :- 
	inFight(EnemyId, MyId, _, _),
	stat_tokemon(EnemyId, EnemyName, _, Level, _, _),
	stat_tokemon(MyId, MyName, _, _, _, _),
	jenis_tokemon(EnemyName, EnemyTipe, _, AttackName, _, _),
	jenis_tokemon(MyName, MyTipe, _, _, _, _),
	tipeModifier(EnemyTipe, MyTipe, Modf),
	normal_attack(AttackName, Dmg),
	NewDmg is floor(Dmg*Modf*Level),
	NewDmg1 is div(NewDmg,2),
	dealDmg(MyId, NewDmg1),
	nl, write(AttackName), write('!!!'), nl,
	write('It dealt '), write(NewDmg1), write(' damage to '), write(MyName), write('!'), nl, nl, !.
%% todo: enemy special attack

dealDmg(Id, Dmg) :- 
	retract(stat_tokemon(Id, EnemyName, Health, Lvl, Exp, ExpMax)),
	NewHealth is Health-Dmg,
	assertz(stat_tokemon(Id, EnemyName, NewHealth, Lvl, Exp, ExpMax)).

%% mengecek jika lawanya sudah mati :(
checkIfEnemyDead(Id) :- 
	stat_tokemon(Id, Name, Health, _, _, _),
	Health =< 0,
	write(Name),
	write(' faints! Do you want to capture '),
	write(Name),
	write('? (capture/0 to capture '),
	write(Name), write(', otherwise move away.'), nl,
	retract(inFight(_, IdUp, _, _)), 
	retract(stat_tokemon(Id, Name, Health, Level, Exp, ExpMax)),
	max_Health(Name, Level, Max_H),
	assertz(stat_tokemon(Id, Name, Max_H, Level, Exp, ExpMax)), 
	makeCanCapture(Id), ExpUp is Level*20, asserta(tokemonExpUp(IdUp,ExpUp)), !.

%% mengecek jika tokemon yg dimiliki pemain mati
checkIfTokemonPemainDead(Id) :- 
	stat_tokemon(Id, Name, Health, _, _, _),
	Health =< 0,
	write('Yaaah, '), write(Name), write(' mati :(((('), nl,
	inFight(EnemyId, _, Can_Run, _),
	retract(inFight(_, _, _, _)), 
	asserta(inFight(EnemyId, -1, Can_Run, 1)),
	deleteFromInv(Id), retract(stat_tokemon(Id, _, _, _, _, _)), 
	checkLose,
	write('Please pick another tokemon!'), nl, !.

%% check if enemy is defeated retract inFight
%% as of now respawn, MUNGKIN GANTI!

%% ================= LOSE =================

checkLose :-
	pemain(_, [], _, _, _), 
	write('YOU LOSE!'), nl,
	halt, !.

checkLose :- 
	pemain(_, L, _, _, _),
	L \= [], !.



%% ================= CAPTURE =================
makeCanCapture(Id) :- retract(mayCapture(_, _)), asserta(mayCapture(1, Id)).
makeCannotCapture :- retract(mayCapture(_, _)), asserta(mayCapture(0, -1)).

capture :-
	mayCapture(X, _),
	X=0,
	write('Capture apaan atuh :('), nl, !.

capture :-
	mayCapture(X, _), X=1,
	\+notMaxInv,
	write('You cannot capture another Tokemon! You have to drop one first.'), nl, !.

capture :-
	mayCapture(X, Id), X=1,
	notMaxInv,
	stat_tokemon(Id, Name, _, _, _, _),
	makeCannotCapture,
	add2InvTokemon(Id), retract(tokemonExpUp(_,_)),
	write(Name), write(' is captured!'), nl, !.

%% todo : check if full, add random chance of success

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


%% MAKE ONE COMMENT
%% cls :- shell(cls).
cls :- shell(clear).

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

%% ================= HELP =================
help :-
	write('Daftar Command : '),nl,
	write('1. start : memulai permainan.'),nl,
	write('2. map : Menampilkan peta.'),nl,
	write('3. w : Bergerak kearah atas.'),nl,
	write('4. s : Bergerak kearah kanan.'),nl,
	write('5. a : Bergerak kearah kiri.'),nl,
	write('6. d : Bergerak kearah bawah.'),nl,
	write('7. status : Melihat status diri dan daftar pokemon yang dimiliki.'),nl,
	write('8. help : Menampilkan ini lagi.'),nl,
	write('9. fight :Melawan pokemon liar yang ditemukan.'),nl,
	write('10. attack : Menyerang tokemon yang sedang dilawan dengan normal attack.'),nl,
	write('11. specialAttack : Menyerang tokemon yang sedang dilawan dengan special attack.'),nl,
	write('12. pick(pokemon) : Menmanggil pokemon dari inventory.'),nl,
	write('13. drop(pokemon) : Melepas pokemon yang dimiliki.'),nl,
	write('14. capture : Menangkap pokemon yang sudah dikalahkan.'),nl,
	write('15. run : Lariiiii.'),nl,
	write('16. savefile(filename) : Menyimpan permainan pemain.'),nl,
	write('17. loadfile(filename) : Membuka save-an pemain.'),nl,
	write('18. quit : Keluar dari permainan.'),nl.

writeAvailable([]) :- !.
writeAvailable([A]) :- 
	writeName(A).
writeAvailable([H|T]) :- 
	writeName(H), write(', '),
	writeAvailable(T).

writeInventory([]) :- !.
writeInventory([H|T]) :- 
	writeStat(H), 
	writeInventory(T).

writeName(Id) :- 
	stat_tokemon(Id, Nama, _, _, _, _),
	write(Nama).

writeStat(Id) :-
	stat_tokemon(Id, Nama, Curr_H, Level,Exp,ExpMax),
	jenis_tokemon(Nama, Tipe, _, _, _, _),
	max_Health(Nama, Level, Max_H),
	write(Nama), nl,
	write('Level: '), write(Level), nl,
	write('Health: '), write(Curr_H), write('/'), write(Max_H), nl,
	write('Type: '), write(Tipe), nl,
	write('Exp: '), write(Exp), write('/'), write(ExpMax), nl, nl.


%% ================= STAT =================
status :-
	\+pemain(_,_,_,_,_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
status :-
	pemain(X,Inventory,_,_,_), nl,
	write('[ ***** '), write(X), write('\'s  tokemon  ***** ]'), nl,
	writeInventory(Inventory), !.



%% ================= QUIT =================
quit :- halt. 