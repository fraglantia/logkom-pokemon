%% All combat functions are handle here

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

