% Tugas Besar IF2121 Logika Komputasional
% Kelompok    :   09
% Kelas       :   03
% Anggota     :   - 13518018/Steve Bezalel Imam Gustaman
%                 - 13518057/Muhammad Daru Darmakusuma
%                 - 13518096/Naufal Arfananda Ghifari
%                 - 13518135/Gregorius Jovan Kresnadi


/* =============  INCLUDED FILES  ============= */
:- include('map_move.pl').
:- include('variables.pl').
:- include('combat.pl').

/* --- Deklarasi Fakta --- */
%% pemain(Nama,Inventory,Xpos,Ypos).
%% stat_tokemon(Id,Nama,Curr_Health,Level).
%% normal_attack(Nama_Attack,Base_Damage).
%% special_attack(Nama_Special,Base_Damage).
%% potion(Jumlah).
%% jenis_tokemon(Nama,Tipe,Base_Health,Nama_Attack,Nama_Special,Legend_or_normal).
%% tipeModifier(FromTipe, ToTipe, Modf).

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


%% pemain(Nama,Inventory,Xpos,Ypos,Map).
%% inFight(EnemyId, MyId, Can_Run, Can_Special). MyId if belom pick = -1, Can_Run 1/0, Can_Special 1/0
%% mayCapture(Yes/No, Id) 1/0
%% tokemonCount(Counter).
%% stat_tokemon(Id,Nama,Curr_Health,Level).


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
:- dynamic(legendKillCount/1).
:- dynamic(statLegend1/1).
:- dynamic(statLegend2/1).

%% pemain(Nama,Inventory,Xpos,Ypos,Map).
%% inFight(EnemyId, MyId, Can_Run, Can_Special). MyId if belom pick = -1, Can_Run 1/0, Can_Special 1/0
%% mayCapture(Yes/No, Id) 1/0
%% tokemonCount(Counter).
%% stat_tokemon(Id,Nama,Curr_Health,Level,Exp,ExpMax).
%% inLegend(X), X=0 -> NO, X=1 -> LEAVES, X=2 -> WATER

start :-
	retractall(pemain(_, _, _, _, _)),
	retractall(inFight(_, _, _, _)),
	retractall(mayCapture(_, _)),
	retractall(tokemonCount(_)),
	retractall(stat_tokemon(_, _, _, _, _, _)),
	retractall(donePlayer(_)),
	retractall(doneTokemon(_)),
	retractall(inGym(_)),
	retractall(tokemonExpUp(_, _)),
	retractall(inLegend(_)),
	retractall(legendKillCount(_)),
	retractall(statLegend1(_)),
	retractall(statLegend2(_)),
	asserta(donePlayer(0)),
	title,
	write('Siapa Anda?'), nl,
	write('choosePlayer/1: akill, jun-go, atau (Nama bebas).'),
	asserta(doneTokemon(0)),
	asserta(tokemonCount(0)),
	asserta(mayCapture(0, -1)),
	asserta(inGym(0)),
	asserta(inLegend(0)),
	asserta(legendKillCount(0)),
	asserta(statLegend1(0)),
	asserta(statLegend2(0)), !.

title :-
	open('assets/title.txt',read,Str), !,
	readMap(Str, CharT),
	atom_codes(T,CharT),
	close(Str),
	cls,
	write(T),  nl,
	!.
lose_msg :-
	open('assets/lose_msg.txt',read,Str), !,
	readMap(Str, CharT),
	atom_codes(T,CharT),
	close(Str),
	cls,
	write(T),  nl,
	!.
win_msg :-
	open('assets/win_msg.txt',read,Str), !,
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
tokemonInit(missingno).
choosePlayer(Name) :-
	atom_codes(Name, L),
	sumList(L, Seed),
	set_seed(Seed),
	addPemain(Name,3,9,tl),
	retract(donePlayer(_)),
	(write(Name), write(' pilih tokemon Anda terlebih dahulu!'), nl,
	write('chooseTokemon/1: karma_nder (Fire), tukangair (Water), atau lumud (Leaves)!')).
chooseTokemon(_) :- donePlayer(_), write('Pilih player terlebih dahulu!'), !.
chooseTokemon(Tokemon) :- (\+ tokemonInit(Tokemon)), write('Tokemon tidak ada dalam pilihan!'), !.
chooseTokemon(Tokemon) :- addTokemon(Tokemon,3,0), add2InvTokemon(0), retract(doneTokemon(_)), addWildTokemon.

addWildTokemon :-
	%% add legendaries at (FIX ID 1 AND 2)
	addTokemon(tubes, 25, 0),
	addTokemon(sesasasosa, 25, 0),
	addTokemon(karma_nder, 1, 0),
	addTokemon(karma_nder, 7,0),
	addTokemon(kompor_gas, 5, 0),
	addTokemon(lumud, 2, 0),
	addTokemon(lumud, 5, 0),
	addTokemon(tukangair, 2, 0),
	addTokemon(tukangair, 5, 0),
	addTokemon(tukangair, 10, 0),
	addTokemon(tukangair, 3, 0),
	addTokemon(rerumputan, 7, 0),
	addTokemon(rerumputan, 20, 0),
	addTokemon(rerumputan, 10, 0),
	addTokemon(sugiono, 1, 0),
	addTokemon(sugiono, 69, 0),
	addTokemon(edukamon, 5, 0),
	addTokemon(edukamon, 20, 0),
	addTokemon(abhaigimon, 16, 0),
	addTokemon(abhaigimon, 10, 0),
	addTokemon(martabak, 1, 0),
	addTokemon(martabak, 20, 0),
	addTokemon(mumu, 9, 0),
	addTokemon(mumu, 10, 0),
	addTokemon(mumu, 13,0),
	addTokemon(gledek, 1, 0),
	addTokemon(gledek, 7, 0),
	addTokemon(gledek, 10, 0),
	addTokemon(hiring, 3, 0),
	addTokemon(hiring, 6, 0),
	addTokemon(hiring, 10, 0),
	addTokemon(danus, 2, 0),
	addTokemon(danus, 10, 0).

%% SAVE/LOAD
%% note: filename harus pake kutip

savefile(Filename) :-
	open(Filename, write, Str),
	writeFacts(Str),
	close(Str).

writeFacts(Str) :-
	forall(pemain(Name, L, X, Y, Map), (write(Str,'pemain('), write(Str,Name), write(Str,','), write(Str,L), write(Str,','), write(Str,X), write(Str,','), write(Str,Y), write(Str,','), write(Str,Map),write(Str,').\n'))),
	forall(inFight(EnemyId, MyId, Can_Run, Can_Special), (write(Str,'inFight('), write(Str,EnemyId), write(Str,','), write(Str,MyId), write(Str,','), write(Str,Can_Run), write(Str,','), write(Str,Can_Special), write(Str,').\n'))),
	forall(mayCapture(YesNo, IdC), (write(Str,'mayCapture('), write(Str,YesNo), write(Str,','), write(Str,IdC), write(Str,').\n'))),
	forall(tokemonCount(C), (write(Str,'tokemonCount('), write(Str,C), write(Str,').\n'))),
	forall(stat_tokemon(Id,Nama,Health,Lvl,Exp,ExpMax), (write(Str,'stat_tokemon('), write(Str,Id), write(Str,','), write(Str,Nama), write(Str,','), write(Str,Health), write(Str,','), write(Str,Lvl), write(Str,','), write(Str,Exp), write(Str,','), write(Str,ExpMax), write(Str,').\n'))),
	forall(donePlayer(X), (write(Str,'donePlayer('), write(Str,X), write(Str,').\n'))),
	forall(doneTokemon(X), (write(Str,'doneTokemon('), write(Str,X), write(Str,').\n'))),
	forall(inGym(X), (write(Str,'inGym('), write(Str,X), write(Str,').\n'))),
	forall(tokemonExpUp(X, Y), (write(Str,'tokemonExpUp('), write(Str,X), write(Str,','), write(Str,Y), write(Str,').\n'))),
	forall(inLegend(X), (write(Str,'inLegend('), write(Str,X), write(Str,').\n'))),
	forall(legendKillCount(X), (write(Str,'legendKillCount('), write(Str,X), write(Str,').\n'))),
	forall(statLegend1(X), (write(Str,'statLegend1('), write(Str,X), write(Str,').\n'))),
	forall(statLegend2(X), (write(Str,'statLegend2('), write(Str,X), write(Str,').\n'))).


loadfile(Filename) :-
	open(Filename, read, Str),
	retractall(pemain(_, _, _, _, _)),
	retractall(inFight(_, _, _, _)),
	retractall(mayCapture(_, _)),
	retractall(tokemonCount(_)),
	retractall(stat_tokemon(_, _, _, _, _, _)),
	retractall(donePlayer(_)),
	retractall(doneTokemon(_)),
	retractall(inGym(_)),
	retractall(tokemonExpUp(_, _)),
	retractall(inLegend(_)),
	retractall(legendKillCount(_)),
	retractall(statLegend1(_)),
	retractall(statLegend2(_)),
	readFacts(Str,Facts),
	close(Str),
	process(Facts), nl,
	!.

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

%% SUM LIST
sumList([], 0) :- !.
sumList([H|T], S) :-
	sumList(T, STail),
	S is H+STail.

%% ISLISTMEMBER
isMember(X, [X|_]) :- !.
isMember(X, [_|T]):- isMember(X, T).

%% RANDOM
randInterval(X, X, X) :- !.
randInterval(X, A, B) :- random(R), X is floor((B-A+1)*R)+A.

%% CLEAR SCREEN
cls :- (shell(clear);shell(cls)), !.

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

getLvlList([],[]) :- !.
getLvlList([Id|InvTail],[Lvl|LvlTail]) :-
	stat_tokemon(Id,_,_,Lvl,_,_),
	getLvlList(InvTail,LvlTail).

maxList([], 0) :- !.
maxList([H|T], X) :-
	maxList(T, Tmax),
	X is max(H, Tmax).

maxLvlInv(X) :-
	pemain(_, L, _, _, _),
	getLvlList(L, LvlList),
	maxList(LvlList, X).

%% ================= GYM & HEAL =================

handleGym :-
	pemain(_, _, X, Y, _),
	gym_location(A, B, Map),
	(X \= A; Y \= B, Map \= tl),
	retract(inGym(_)),
	asserta(inGym(0)), !.

handleGym :-
	pemain(_, _, X, Y, Map),
	gym_location(X, Y, Map),
	retract(inGym(_)),
	write('Anda memasuki gym!'), nl,
	write('Silakan gunakan heal/0 untuk mengembalikan nyawa tokemon Anda!'), nl,
	asserta(inGym(1)).


heal :- inGym(X), X = 0, write('Anda tidak sedang berada di gym!'), nl, !.
heal :-
	inGym(X), X = 1,
	pemain(_, L, _, _, _),
	write('Nyawa tokemon Anda kembali penuh!'),
	healList(L).


healList([]) :- !.
healList([Id|T]) :-
%% Id,Nama,Curr_Health,Level
	stat_tokemon(Id, Nama, _, Level,Exp,ExpMax),
	max_Health(Nama, Level, Max_H),
	retract(stat_tokemon(Id, _, _, _, _, _)),
	assertz(stat_tokemon(Id, Nama, Max_H, Level,Exp,ExpMax)),
	healList(T).


%% ================= LEGEND =================

handleLegend :-
	(pemain(_, _, 42, 3, _), statLegend1(0)),
	retract(inLegend(_)),
	write('Anda bertemu Legendary Tokemon tipe Leaves!'), nl,
	asserta(inLegend(1)), meetLegend(1), !.

handleLegend :-
	(pemain(_, _, 43, 24, _), statLegend2(0)),
	retract(inLegend(_)),
	write('Anda bertemu Legendary Tokemon tipe Water!'), nl,
	asserta(inLegend(2)), meetLegend(2), !.

handleLegend :-
	pemain(_, _, X, Y, _),
	((X \= 43, Y \= 3); (X \= 44, Y \= 24)),
	retract(inLegend(_)),
	asserta(inLegend(0)), !.

meetLegend(Id) :-
	asserta(inFight(Id, -1, 1, 1)),
	write('Fight or Run?'), nl.


%% ================= WILD POKEMON =================

%% RANDOMLY MEET TOKEMON
%% random id from list of wild tokemons (not including legendary)
randomWildTokemon(Id) :-
	findall(X, (stat_tokemon(X, _, _, Lvl, _, _), wildTokemon(X), \+legendaryTokemon(X), (maxLvlInv(MaxLvl), Lvl < MaxLvl+5) ), L),
	count(L, Len),
	IdxMax is Len-1,
	randInterval(N, 0, IdxMax),
	nth0(N, L, Id).

meetWild(Id) :-
	%% 20%
	randInterval(X, 1, 8), X=1,
	stat_tokemon(Id, Nama, _, Level, _, _),
	write('A wild '), write(Nama), write(' (lv.'), write(Level), write(') appears!'), nl,
	asserta(inFight(Id, -1, 1, 1)),
	write('Fight or Run?'), nl.


%% ================= HELP =================
help :-
	write('Daftar Command : '),nl,
	write(' 1. start : Memulai permainan.'),nl,
	write(' 2. map   : Menampilkan peta.'),nl,
	write(' 3. w : Bergerak kearah atas.'),nl,
	write(' 4. s : Bergerak kearah kanan.'),nl,
	write(' 5. a : Bergerak kearah kiri.'),nl,
	write(' 6. d : Bergerak kearah bawah.'),nl,
	write(' 7. status : Melihat status diri dan daftar pokemon yang dimiliki.'),nl,
	write(' 8. help   : Menampilkan daftar command yang dapat digunakan.'),nl,
	write(' 9. fight  : Melawan pokemon liar yang ditemukan.'),nl,
	write('10. attack : Menyerang tokemon yang sedang dilawan dengan normal attack.'),nl,
	write('11. specialAttack : Menyerang tokemon yang sedang dilawan dengan special attack.'),nl,
	write('12. pick(id,nama_tokemon) : Memanggil tokemon dari inventory.'),nl,
	write('13. drop(id,tokemon) : Melepas pokemon yang dimiliki.'),nl,
	write('14. capture : Menangkap pokemon yang sudah dikalahkan.'),nl,
	write('15. run     : Lariiiii.'),nl,
	write('16. savefile(filename) : Menyimpan permainan pemain.'),nl,
	write('17. loadfile(filename) : Membuka save-an pemain.'),nl,
	write('18. heal : Mengobati seluruh pokemon pada inventory pada petak gym.'),nl,
	write('19. quit : Keluar dari permainan.'),nl.

%% USAGE: writeIndex(Inv, 1)
writeIndex([], _) :- !.
writeIndex([Id|T], S) :- 
	stat_tokemon(Id, Nama, _, Level, _, _),
	write(S), write('. '), write(Nama), write(' (Lv. '), write(Level), write(')'), nl,
	Snew is S+1,
	writeIndex(T, Snew).

getIndex([Id|_], 1, Id) :- !.
getIndex([_|T], X, R) :-
	Xnew is X-1,
	getIndex(T, Xnew, R).


writeAvailable([]) :- !.
writeAvailable([A]) :-
	write('ID:'),write(A),write(' - '),
	writeName(A).
writeAvailable([H|T]) :-
	write('ID:'),write(H),write(' - '),
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
	write('Nama   : '), write(Nama), nl,
	write('Level  : '), write(Level), nl,
	write('Health : '), write(Curr_H), write('/'), write(Max_H), nl,
	write('Type   : '), write(Tipe), nl,
	write('Exp    : '), write(Exp), write('/'), write(ExpMax), nl, nl.


%% ================= STAT =================
status :-
	\+pemain(_,_,_,_,_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
status :-
	pemain(X,Inventory,_,_,_), nl,
	write('[ ***** '), write(X), write('\'s  tokemon  ***** ]'), nl,
	writeInventory(Inventory),
	((statLegend1(1), write('You have defeated the Legendary Tokemon, tubes!'), nl);
	 (statLegend2(1), write('You have defeated the Legendary Tokemon, sesasasosa!'), nl)),
	!.


%% ================= QUIT =================
quit :- halt.


%% ================= END CONDITION =================

%% ================= LOSE =================

checkLose :-
	pemain(_, [], _, _, _),
	lose_msg,
	halt, !.

checkLose :-
	pemain(_, L, _, _, _),
	L \= [], !.

%% ================= WIN =================

checkWin :-
	legendKillCount(X),
	X >= 2,
	win_msg,
	halt, !.

checkWin :- !.