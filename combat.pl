%% All combat functions are handled here

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
	randInterval(X, 1, 4),
	NewDmg is floor(Dmg*Modf*Level),
	dealDmg(EnemyId, NewDmg),
	nl, write(AttackName), write('!!!'), nl,
	write('You dealt '), write(NewDmg), write(' damage to '), write(EnemyName), write('!'), nl, 
	(checkIfEnemyDead(EnemyId)); (((\+ X=2, enemyAttack); (X=2, enemyspecialAttack)), (writeStat(MyId), writeStat(EnemyId))), 
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
	randInterval(X, 1, 4),
	NewDmg is floor(Dmg*Modf*Level),
	dealDmg(EnemyId, NewDmg), nl,
	retract(inFight(_, _, _, _)), 
	asserta(inFight(EnemyId, MyId, Can_Run, 0)),
	write(SpecialName), write('!!!'), nl,
	write('You dealt '), write(NewDmg), write(' damage to '), write(EnemyName), write('!'), nl,
	(checkIfEnemyDead(EnemyId)); (((\+ X=2, enemyAttack); (X=2, enemyspecialAttack)), (writeStat(MyId), writeStat(EnemyId))), 
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
enemyspecialAttack :-
	inFight(EnemyId, MyId, _, _),
	stat_tokemon(EnemyId, EnemyName, _, Level, _, _),
	stat_tokemon(MyId, MyName, _, _, _, _),
	jenis_tokemon(EnemyName, EnemyTipe, _, _, SpecialName, _),
	jenis_tokemon(MyName, MyTipe, _, _, _, _),
	tipeModifier(EnemyTipe, MyTipe, Modf),
	special_attack(SpecialName, Dmg),
	NewDmg is floor(Dmg*Modf*Level),
	NewDmg1 is div(NewDmg,2),
	dealDmg(MyId, NewDmg1),
	nl, write(SpecialName), write('!!!'), nl,
	write('It dealt '), write(NewDmg1), write(' damage to '), write(MyName), write('!'), nl, nl, !.


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
