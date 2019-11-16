% Gambaran Tugas Besar IF2121 Logika Komputasional
% Kelompok    :   09
% Kelas       :   03
% Anggota     :   - 13518018/Steve Bezalel Imam Gustaman
%                 - 13518057/Muhammad Daru Darmakusuma
%                 - 13518096/Naufal Arfananda Ghifari
%                 - 13518135/Gregorius Jovan Kresnadi



/* --- Deklarasi Fakta --- */
%% pemain(Nama,Inventory,Xpos,Ypos).
%% stat_tokemon(Id,Nama,Curr_Health,Level).
%% normal_attack(Nama_Attack,Base_Damage).
%% special_attack(Nama_Special,Base_Damage).
%% potion(Jumlah).
%% jenis_tokemon(Nama,Tipe,Base_Health,Nama_Attack,Nama_Special,Legend_or_normal).
%% tipeModifier(FromTipe, ToTipe, Modf).

%% jenis_tokemon(missingno,entah,999,att,spec,0).
jenis_tokemon(karma-nder,fire,60,duarr,nmax,0).
jenis_tokemon(kompor_gas,fire,120,bom,bitu,0).
jenis_tokemon(tukangair,water,60,ciprat,sebor,0).
jenis_tokemon(rerumputan,leaves,60,lambai,bergoyang,1).
jenis_tokemon(sugiono,water,69,genjot,crot,1).
jenis_tokemon(sesasasosa,fire,125,sekali,tujuhkali,1).
jenis_tokemon(edukamon,leaves,135,startup,bukalepek,1).
jenis_tokemon(abhaigimon,water,182,warga,turun,1).
jenis_tokemon(martabak,earth,60,mamet,bowo,0).
jenis_tokemon(mumu,wind,60,badai,topan,0).
jenis_tokemon(gledek,lightning,60,halilintar,atta,0).
jenis_tokemon(hiring,lightning,120,sekip,debat,1).
jenis_tokemon(danus,earth,100,paid,promote,1).
jenis_tokemon(tubes,wind,110,kelar,dong,1).


normal_attack(duarr,20).
normal_attack(ciprat,20).
normal_attack(lambai,20).
normal_attack(mamet,20).
normal_attack(badai,20).
normal_attack(halilintar,20).
normal_attack(genjot,40).
normal_attack(sekali,40).
normal_attack(startup,40).
normal_attack(warga,50).
normal_attack(bom,30).
normal_attack(sekip,40).
normal_attack(paid,30).
normal_attack(kelar,40).


special_attack(nmax,30).
special_attack(sebor,30).
special_attack(bergoyang,30).
special_attack(bowo,30).
special_attack(topan,30).
special_attack(atta,30).
special_attack(crot,69).
special_attack(tujuhkali,77).
special_attack(bukalepek,65).
special_attack(turun,200).
special_attack(debat,60).
special_attack(promote,60).
special_attack(dong,70).

%%fire<water<lightning<earth<leaves<wind<fire
%% from fire
tipeModifier(fire, fire, 1.0).
tipeModifier(fire, water, 0.5).
tipeModifier(fire, leaves, 1.0).
tipeModifier(fire, lightning, 1.0).
tipeModifier(fire, wind, 1.5).
tipeModifier(fire, earth, 1.0).
%% from water
tipeModifier(water, fire, 1.5).
tipeModifier(water, water, 1.0).
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
getMap(tl,'petaTL.txt').
getMap(tr,'petaTR.txt').
getMap(bl,'petaBl.txt').
getMap(br,'petaBr.txt').


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

:- dynamic(pemain/4).
:- dynamic(inFight/4).
:- dynamic(mayCapture/2).
:- dynamic(tokemonCount/1).
:- dynamic(stat_tokemon/4).

%% pemain(Nama,Inventory,Xpos,Ypos).
%% inFight(EnemyId, MyId, Can_Run, Can_Special). MyId if belom pick = -1, Can_Run 1/0, Can_Special 1/0
%% mayCapture(Yes/No, Id) 1/0
%% tokemonCount(Counter).
%% stat_tokemon(Id,Nama,Curr_Health,Level).


start :- 
	retractall(pemain(_, _, _, _)),
	retractall(stat_tokemon(_, _, _, _)),
	retractall(inFight(_, _, _, _)),
	retractall(mayCapture(_, _)),
	retractall(tokemonCount(_)),
	addPemain(akill, 10, 12),
	asserta(tokemonCount(0)),
	asserta(mayCapture(0, -1)),
	addTokemon(karma-nder, 1), addTokemon(karma-nder, 2), addTokemon(tukangair, 1), addTokemon(rerumputan, 1),
	addTokemon(sesasasosa, 1), addTokemon(abhaigimon, 2), addTokemon(tukangair, 5), addTokemon(rerumputan, 7),
	addTokemon(martabak, 1), addTokemon(mumu, 2), addTokemon(gledek, 1), addTokemon(hiring,3),
	addTokemon(danus, 1), addTokemon(tubes,5),
	add2InvTokemon(0), add2InvTokemon(1), add2InvTokemon(2), add2InvTokemon(3), add2InvTokemon(5).

%% todo initialize tokemons

%% SAVE/LOAD 
%% note: filename harus pake kutip

savefile(Filename) :-
	open(Filename, write, Str),
	writeFacts(Str),
	close(Str).

writeFacts(Str) :-
	forall(pemain(Name, L, X, Y), (write(Str,'pemain('), write(Str,Name), write(Str,','), write(Str,L), write(Str,','), write(Str,X), write(Str,','), write(Str,Y), write(Str,').\n'))),
	forall(mayCapture(YesNo, IdC), (write(Str,'mayCapture('), write(Str,YesNo), write(Str,','), write(Str,IdC), write(Str,').\n'))),
	forall(inFight(EnemyId, MyId, Can_Run, Can_Special), (write(Str,'inFight('), write(Str,EnemyId), write(Str,','), write(Str,MyId), write(Str,','), write(Str,Can_Run), write(Str,','), write(Str,Can_Special), write(Str,').\n'))),
	forall(tokemonCount(C), (write(Str,'tokemonCount('), write(Str,C), write(Str,').\n'))),
	forall(stat_tokemon(Id,Nama,Health,Lvl), (write(Str,'stat_tokemon('), write(Str,Id), write(Str,','), write(Str,Nama), write(Str,','), write(Str,Health), write(Str,','), write(Str,Lvl), write(Str,').\n'))).

loadfile(Filename) :-
	open(Filename, read, Str),
	retractall(pemain(_, _, _, _)),
	retractall(stat_tokemon(_, _, _, _)),
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

addPemain(Nama, X, Y) :- asserta(pemain(Nama, [], X, Y)).

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

%% ISLISTMEMBER
isMember(X, [X|_]) :- !.
isMember(X, [_|T]):- isMember(X, T).

%% RANDOM
randInterval(X, X, X) :- !.
randInterval(X, A, B) :- random(R), X is floor((B-A+1)*R)+A.

%% ================= STAT_TOKEMON =================
wildTokemon(Id) :- pemain(_, L, _, _), \+isMember(Id, L).

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
addTokemon(Nama, Level) :- 
	tokemonCount(Id), 
	max_Health(Nama, Level, H),
	assertz(stat_tokemon(Id, Nama, H, Level)), 
	incTokemonCount.

%% menambahkan tokemon dengan id Id ke inventory pemain
add2InvTokemon(Id) :- 
	pemain(Name, L, X, Y),
	append(L, [Id], Lnew),
	retract(pemain(_, _, _, _)),
	asserta(pemain(Name, Lnew, X, Y)).

%$ ================= INVENTORY =================
notMaxInv :-
	pemain(_, L, _, _),
	count(L, N),
	%% maxinventory(X),
	N<6.

deleteFromInv(Id) :-
	pemain(Name, L, X, Y),
	delete(L, Id, NewL),
	retract(pemain(_, _, _, _)),
	asserta(pemain(Name, NewL, X, Y)).


%% ================= MOVE =================
getAscii(Symbol,X,Y,Map) :-
	getMap(Map,Mapname),
	open(Mapname,read,Str), !,
	readMap(Str,Chars),
	getCharMap(Chars, X, Y, Symbol).

cekAscii(Symbol,X) :- Symbol == X.

cekPeta(Map, Xnext, Ynext, _, Xnew, Ynew) :-
	getAscii(Symbol,Xnext,Ynext,Map),
	\+cekAscii(Symbol,88),
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

getCharMap(Chars, X, Y, Symbol) :- Pos is (36*Y + 2*X), getChar(Chars, Symbol, Pos).


w :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
w :-
	pemain(Name, L, X, Y, Map),
	Ynext is (Y-1),
	cekPeta(Map, X, Ynext, w, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)),
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
    randomWildTokemon(Id),
	meetWild(Id).

s :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
s :- 
	pemain(Name, L, X, Y, Map),
	Ynext is (Y+1), 
	cekPeta(Map, X, Ynext, s, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)), 
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
	map,
    randomWildTokemon(Id),
	meetWild(Id).

a :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
a :- 
	pemain(Name, L, X, Y, Map),
	Xnext is (X-1), 
	cekPeta(Map, Xnext, Y, a, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)), 
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
	map,
    randomWildTokemon(Id),
	meetWild(Id).

d :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
d :- 
	pemain(Name, L, X, Y, Map),
	Xnext is (X+1), 
	cekPeta(Map, Xnext, Y, d, Xnew, Ynew),
	retract(pemain(_, _, _, _, _)), 
	asserta(pemain(Name, L, Xnew, Ynew, Map)),
	makeCannotCapture,
	map, !.
    randomWildTokemon(Id),
	meetWild(Id).

%% RANDOMLY MEET TOKEMON
%% random id from list of wild tokemons
randomWildTokemon(Id) :-
	findall(X, (stat_tokemon(X, _, _, _), wildTokemon(X)), L),
	count(L, Len),
	IdxMax is Len-1,
	randInterval(N, 0, IdxMax),
	nth0(N, L, Id).

meetWild(Id) :-
	%% 25%
	randInterval(X, 1, 4), X=1,
	stat_tokemon(Id, Nama, _, _),
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
	stat_tokemon(Id, Nama, _, _),
	write('Anda melawan '), write(Nama), write('!!'), nl,
	pemain(_, L, _, _),
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
	findall(X, (stat_tokemon(X, _, _, _), \+wildTokemon(X)), L),
	searchNameInList(Name, L, Id).


searchNameInList(_, [], -1) :- !.

searchNameInList(Name, [Id|_], Id) :-
	stat_tokemon(Id, Name, _, _), !.

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
	retract(stat_tokemon(Id, _, _, _)),
	write('You have dropped '), write(Name), write('!'), nl, !.


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
	stat_tokemon(EnemyId, EnemyName, _, _),
	stat_tokemon(MyId, MyName, _, _),
	jenis_tokemon(MyName, MyTipe, _, AttackName, _, _),
	jenis_tokemon(EnemyName, EnemyTipe, _, _, _, _),
	tipeModifier(MyTipe, EnemyTipe, Modf),
	normal_attack(AttackName, Dmg),
	NewDmg is floor(Dmg*Modf),
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
	stat_tokemon(EnemyId, EnemyName, _, _),
	stat_tokemon(MyId, MyName, _, _),
	jenis_tokemon(MyName, MyTipe, _, _, SpecialName, _),
	jenis_tokemon(EnemyName, EnemyTipe, _, _, _, _),
	tipeModifier(MyTipe, EnemyTipe, Modf),
	special_attack(SpecialName, Dmg),
	NewDmg is floor(Dmg*Modf),
	dealDmg(EnemyId, NewDmg), nl,
	retract(inFight(_, _, _, _)), 
	asserta(inFight(EnemyId, MyId, Can_Run, 0)),
	write(SpecialName), write('!!!'), nl,
	write('You dealt '), write(NewDmg), write(' damage to '), write(EnemyName), write('!'), nl,
	(checkIfEnemyDead(EnemyId); enemyAttack, (writeStat(MyId), writeStat(EnemyId))), 
	checkIfTokemonPemainDead(MyId), !.

enemyAttack :- 
	inFight(EnemyId, MyId, _, _),
	stat_tokemon(EnemyId, EnemyName, _, _),
	stat_tokemon(MyId, MyName, _, _),
	jenis_tokemon(EnemyName, EnemyTipe, _, AttackName, _, _),
	jenis_tokemon(MyName, MyTipe, _, _, _, _),
	tipeModifier(EnemyTipe, MyTipe, Modf),
	normal_attack(AttackName, Dmg),
	NewDmg is floor(Dmg*Modf),
	dealDmg(MyId, NewDmg),
	nl, write(AttackName), write('!!!'), nl,
	write('It dealt '), write(NewDmg), write(' damage to '), write(MyName), write('!'), nl, nl, !.
%% todo: enemy special attack

dealDmg(Id, Dmg) :- 
	retract(stat_tokemon(Id, EnemyName, Health, Lvl)),
	NewHealth is Health-Dmg,
	assertz(stat_tokemon(Id, EnemyName, NewHealth, Lvl)).

%% mengecek jika lawanya sudah mati :(
checkIfEnemyDead(Id) :- 
	stat_tokemon(Id, Name, Health, _),
	Health =< 0,
	write(Name),
	write(' faints! Do you want to capture '),
	write(Name),
	write('? (capture/0 to capture '),
	write(Name), write(', otherwise move away.'), nl,
	retract(inFight(_, _, _, _)), 
	retract(stat_tokemon(Id, Name, Health, Level)),
	max_Health(Name, Level, Max_H),
	assertz(stat_tokemon(Id, Name, Max_H, Level)), 
	makeCanCapture(Id), !.

%% mengecek jika tokemon yg dimiliki pemain mati
checkIfTokemonPemainDead(Id) :- 
	stat_tokemon(Id, Name, Health, _),
	Health =< 0,
	write('Yaaah, '), write(Name), write(' mati :(((('), nl,
	write('Please pick another tokemon!'), nl,
	inFight(EnemyId, _, Can_Run, _),
	retract(inFight(_, _, _, _)), 
	asserta(inFight(EnemyId, -1, Can_Run, 1)),
	deleteFromInv(Id), retract(stat_tokemon(Id, _, _, _)), !.

%% check if enemy is defeated retract inFight
%% as of now respawn, MUNGKIN GANTI!

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
	stat_tokemon(Id, Name, _, _),
	makeCannotCapture,
	add2InvTokemon(Id),
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
replaceCoor(Chars, X, Y, Symbol, Replaced) :- Pos is  (36*Y + 2*X), replace(Chars, Symbol, Pos, Replaced).

map :-
	pemain(_, _, X, Y, Map),
	getMap(Map,Mapname)
	open(Mapname,read,Str), !,
	readMap(Str, Chars),
	%% 80 = charcode P
	replaceCoor(Chars, X, Y, 80, MapwithP),
	atom_codes(M,MapwithP),
	close(Str),
	write(M),  nl,
	!.


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
	stat_tokemon(Id, Nama, _, _),
	write(Nama).

writeStat(Id) :-
	stat_tokemon(Id, Nama, Curr_H, Level),
	jenis_tokemon(Nama, Tipe, _, _, _, _),
	max_Health(Nama, Level, Max_H),
	write(Nama), nl,
	write('Level: '), write(Level), nl,
	write('Health: '), write(Curr_H), write('/'), write(Max_H), nl,
	write('Type: '), write(Tipe), nl, nl.


%% ================= STAT =================
status :-
	\+pemain(_,_,_,_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
status :-
	pemain(X,Inventory,_,_), nl,
	write('[ ***** '), write(X), write('\'s  tokemon  ***** ]'), nl,
	writeInventory(Inventory), !.


%% ================= QUIT =================
quit :- halt.