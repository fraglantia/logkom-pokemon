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

jenis_tokemon(missingno,entah,999,att,spec,0).
jenis_tokemon(karma-nder,fire,60,duarr,nmax,0).
jenis_tokemon(kompor_gas,fire,120,bom,bitu,0).
jenis_tokemon(tukangair,water,60,ciprat,sebor,0).
jenis_tokemon(rerumputan,grass,60,lambai,bergoyang,1).
jenis_tokemon(sugiono,water,69,genjot,crot,1).
jenis_tokemon(sesasasosa,fire,125,sekali,tujuhkali,1).
jenis_tokemon(edukamon,grass,135,startup,bukalepek,1).
jenis_tokemon(abhaigimon,water,182,warga,turun,1).

normal_attack(duarr,20).
normal_attack(ciprat,20).
normal_attack(lambai,20).
normal_attack(genjot,40).
normal_attack(sekali,40).
normal_attack(startup,40).
normal_attack(warga,50).
normal_attack(bom,30).

special_attack(nmax,30).
special_attack(sebor,30).
special_attack(bergoyang,30).
special_attack(crot,69).
special_attack(tujuhkali,77).
special_attack(bukalepek,65).
special_attack(turun,200).

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
:- dynamic(tokemonCount/1).
:- dynamic(stat_tokemon/4).

%% pemain(Nama,Inventory,Xpos,Ypos).
%% inFight(EnemyId, MyId, Can_Run, Can_Special). MyId if belom pick = -1, Can_Run 1/0, Can_Special 1/0
%% tokemonCount(Counter).
%% stat_tokemon(Id,Nama,Curr_Health,Level).


start :- 
	addPemain(akill, 7, 5),
	asserta(tokemonCount(0)),
	addTokemon(karma-nder, 1), addTokemon(karma-nder, 2), addTokemon(tukangair, 1), addTokemon(rerumputan, 1),
	add2InvTokemon(0), add2InvTokemon(1).


addPemain(Nama, X, Y) :- asserta(pemain(Nama, [], X, Y)).

%% ================= UTILITY =================
%% DEBUG PRINT LIST
printlist([]).
printlist([X|List]) :-
	write(X),nl,
	printlist(List).

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
%% notmaxinv :-
%% 	findall(I,inventory(I),L),
%% 	count(L,N),
%% 	maxinventory(X),
%% 	N<X.

count([],0).
count([_|T],N) :-
	count(T, N1),
	N is N1+1, !.


%% ================= MOVE =================
w :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
w :-
	pemain(Name, L, X, Y), Ynew is (Y-1),
	retract(pemain(_, _, _, _)),
	asserta(pemain(Name, L, X, Ynew)),
	randomWildTokemon(Id),
	meetWild(Id).

a :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
a :- 
	pemain(Name, L, X, Y),
	Xnew is (X-1), 
	retract(pemain(_, _, _, _)), 
	asserta(pemain(Name, L, Xnew, Y)),
	randomWildTokemon(Id),
	meetWild(Id).

s :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
s :- 
	pemain(Name, L, X, Y),
	Ynew is (Y+1), 
	retract(pemain(_, _, _, _)), 
	asserta(pemain(Name, L, X, Ynew)),
	randomWildTokemon(Id),
	meetWild(Id).

d :- inFight(_, _, _, _), write('Anda sedang melawan Tokemon!'), !.
d :- 
	pemain(Name, L, X, Y),
	Xnew is (X+1), 
	retract(pemain(_, _, _, _)), 
	asserta(pemain(Name, L, Xnew, Y)),
	randomWildTokemon(Id),
	meetWild(Id).

%% RANDOMLY MEET TOKEMON
%% random id from list of wild tokemons
randomWildTokemon(Id) :-
	findall(X, (stat_tokemon(X, _, _, _), wildTokemon(X)), L),
	length(L, Len),
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
	write(Name), write(', I choose you!'), nl,
	writeStat(Id),
	writeStat(EnemyId), !.


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
	jenis_tokemon(MyName, _, _, AttackName, _, _),
	normal_attack(AttackName, Dmg),
	dealDmg(EnemyId, Dmg), nl,
	write(AttackName), write('!!!'), nl,
	write('You dealt '), write(Dmg), write(' damage to '), write(EnemyName), nl, 
	writeStat(MyId),
	writeStat(EnemyId),
	checkIfEnemyDead(EnemyId), !.

specialAttack :- 
	inFight(_, _, _, Can_Special),
	Can_Special = 0,
	write('Sudah menggunakan special attack !!'), nl, !.

specialAttack :- 
	inFight(EnemyId, MyId, Can_Run, _),
	stat_tokemon(EnemyId, EnemyName, _, _),
	stat_tokemon(MyId, MyName, _, _),
	jenis_tokemon(MyName, _, _, _, SpecialName, _),
	special_attack(SpecialName, Dmg),
	dealDmg(EnemyId, Dmg), nl,
	retract(inFight(_, _, _, _)), 
	asserta(inFight(EnemyId, MyId, Can_Run, 0)),
	write(SpecialName), write('!!!'), nl,
	write('You dealt '), write(Dmg), write(' damage to '), write(EnemyName), nl, 
	writeStat(MyId),
	writeStat(EnemyId),
	checkIfEnemyDead(EnemyId), !.


dealDmg(Id, Dmg) :- 
	retract(stat_tokemon(Id, EnemyName, Health, Lvl)),
	NewHealth is Health-Dmg,
	assertz(stat_tokemon(Id, EnemyName, NewHealth, Lvl)).

checkIfEnemyDead(Id) :- 
	stat_tokemon(Id, Name, Health, _),
	Health =< 0,
	write('You defeated '), write(Name), write('!'), nl, 
	retract(inFight(_, _, _, _)), !.

%% check if enemy is defeated retract inFight


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
replaceCoor(Chars, X, Y, Symbol, Replaced) :- Pos is  (24*Y + 2*X), replace(Chars, Symbol, Pos, Replaced).

map :-
	open('peta.txt',read,Str), !,
	readMap(Str, Chars),
	pemain(_, _, X, Y),
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
	write('7. attack : Menyerang tokemon pada peta yang sama.'),nl,
	write('8. help : Menampilkan ini lagi.'),nl,
	write('9. status : Melihat status diri dan daftar pokemon yang dimiliki.'),nl,
	write('10. quit : Keluar dari permainan.'),nl.
	/*write('9. take(object) : Mengambil object pada petak.'),nl,
	write('10. drop(object) : Membuang sebuah object dari inventory.'),nl,
	write('11. use(object) : Menggunakan sebuah object yang dalam inventori.'),nl,
	write('12. attack : Menyerang enemy dalam petak sama.'),nl,
	write('13. status : Melihat status diri.'),nl,
	write('14. save(filename) : Menyimpan permainan pemain.'),nl,
	write('15. loads(filename) : Membuka save-an pemain.'),nl,
	write('16. help : Menampilkan ini lagi.'),nl,
	write('Catatan : Semua command di atas diakhiri titik (Misal : "help.")'), nl, !.*/


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
	pemain(X,Inventory,_,_),
	write('[ ***** '), write(X), write('\'s  tokemon  ***** ]'), nl,
	writeInventory(Inventory), !.
