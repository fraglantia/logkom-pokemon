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
	write('Available Tokemons:'), nl,
	writeIndex(L, 1), nl, 
	write('pick/1 : Index Tokemon'), nl, !.

run :-
	\+inFight(_, _, _, _),
	write('Lari dari apa atuh :('), nl, !.
run :-
	inFight(_, _, 0, _),
	write('Gak bisa lari :('), nl, !.
run :-
	(inLegend(X), (X == 1; X==2)), 
	retract(inFight(_, _, _, _)),
	write('You ran from a Legendary Tokemon! A wise choice whether you\'re ready or not.'), nl, !.
run :-
	%% 50%
	randInterval(X, 1, 2),
	runRandom(X).

runRandom(X) :- X=1, retract(inFight(_, _, _, _)), write('You sucessfully escaped from the Tokemon!'), nl, !.
runRandom(X) :- X=2, write('You failed to run!'), nl, fight.

%% cari Name di Inventory ambil yg pertama if none Id = -1
inInventory(Name, Id, Ada) :-
	findall(X, (stat_tokemon(X, _, _, _, _, _), \+wildTokemon(X)), L),
	searchNameInList(Name, L, Id, Ada).


searchNameInList(_, [], _, -1) :- !.

searchNameInList(Name, [Id|_], Id, 1) :-
	stat_tokemon(Id, Name, _, _, _, _), !.

searchNameInList(Name, [_|T], Id, 1) :-
	searchNameInList(Name, T, Id, 1).

pick(_) :-
	\+inFight(_, _, _, _),
	write('Anda tidak dalam battle saat ini.'), nl, !.

pick(_) :-
	inFight(_, MyId, _, _),
	MyId \= -1,
	write('Anda sudah pick tokemon!'), nl, !.

pick(Idx) :-
	pemain(_, L, _, _, _),
	length(L, X), (Idx>X; Idx=<0), 
	write('Tidak ada Tokemon berindeks '),
	write(Idx), write('!'), nl, 
	writeIndex(L, 1), !.

pick(Idx) :-
	pemain(_, L, _, _, _),
	getIndex(L, Idx, Id),
	stat_tokemon(Id, Name, _, _, _, _),
	retract(inFight(EnemyId, _, _, Can_Special)),
	asserta(inFight(EnemyId, Id, 0, Can_Special)),
	write(Name), write(', I choose you!'), nl, nl,
	writeStat(Id),
	writeStat(EnemyId), !.


drop(Idx) :-
	pemain(_, L, _, _, _),
	length(L, X), (Idx>X; Idx=<0), 
	write('Tidak ada Tokemon berindeks '),
	write(Idx), write('!'), nl, 
	writeIndex(L, 1), !.

drop(Idx) :-
	pemain(_, L, _, _, _),
	getIndex(L, Idx, Id),
	stat_tokemon(Id, Name, _, _, _, _),
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
	(checkIfEnemyDead(EnemyId)); (randInterval(X, 1, 8), ((((\+ X==2), enemyAttack); (X==2, enemyspecialAttack)), (inFight(EnemyId, MyId, _, _), writeStat(MyId), writeStat(EnemyId)))),
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
	write('It\'s super effective!'), nl,
	(checkIfEnemyDead(EnemyId)); (randInterval(X, 1, 8), ((((\+ X==2), enemyAttack); (X==2, enemyspecialAttack)), (inFight(EnemyId, MyId, _, _), writeStat(MyId), writeStat(EnemyId)))),
	checkIfTokemonPemainDead(MyId), !.

enemyAttack :-
	inFight(EnemyId, MyId, _, _),
	stat_tokemon(EnemyId, EnemyName, _, Level, _, _),
	stat_tokemon(MyId, MyName, _, _, _, _),
	jenis_tokemon(EnemyName, EnemyTipe, _, AttackName, _, _),
	jenis_tokemon(MyName, MyTipe, _, _, _, _),
	tipeModifier(EnemyTipe, MyTipe, Modf),
	normal_attack(AttackName, Dmg),
	NewDmg is floor(Dmg*Modf*Level*0.4),
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
	NewDmg is floor(Dmg*Modf*Level*0.4),
	NewDmg1 is div(NewDmg,2),
	dealDmg(MyId, NewDmg1),
	nl, write('Musuh menggunakan special attack!'), nl, write(SpecialName), write('!!!'), nl,
	write('It dealt '), write(NewDmg1), write(' damage to '), write(MyName), write('!'), nl, nl, !.


dealDmg(Id, Dmg) :-
	retract(stat_tokemon(Id, EnemyName, Health, Lvl, Exp, ExpMax)),
	NewHealth is Health-Dmg,
	assertz(stat_tokemon(Id, EnemyName, NewHealth, Lvl, Exp, ExpMax)).

%% mengecek jika lawanya sudah mati :(
checkIfEnemyDead(Id) :-
	stat_tokemon(Id, Name, Health, _, _, _),
	Health =< 0,
	handleLegendDead(Id),
	write(Name),
	write(' faints! Do you want to capture '),
	write(Name),
	write('? (capture/0 to capture '),
	write(Name), write(', otherwise move away.)'), nl,
	retract(inFight(_, IdUp, _, _)),
	retract(stat_tokemon(Id, Name, Health, Level, Exp, ExpMax)),
	max_Health(Name, Level, Max_H),
	assertz(stat_tokemon(Id, Name, Max_H, Level, Exp, ExpMax)),
	makeCanCapture(Id), ExpUp is Level*20, asserta(tokemonExpUp(IdUp,ExpUp)),
	ExpUpEnemy is ExpUp//2,
	handleEnemyLvlUp(Id, ExpUpEnemy),
	fail, !.


handleEnemyLvlUp(Id, ExpUp) :-
	stat_tokemon(Id,Name,H,Level,Exp,ExpMax), ExpNew is (Exp + ExpUp), (\+ isLevelUp(ExpNew,ExpMax), 
	retract(stat_tokemon(Id,Name,H,Level,Exp,ExpMax)),
	asserta(stat_tokemon(Id,Name,H,Level,ExpNew,ExpMax))), !.

handleEnemyLvlUp(Id, ExpUp) :-
	retract(stat_tokemon(Id,Name,_,Level,Exp,ExpMax)),ExpTemp is (Exp + ExpUp),
	isLevelUp(ExpTemp,ExpMax), ExpNew is (ExpTemp-ExpMax), ExpMaxNew is (ExpMax + 50), LevelUp is (Level + 1), max_Health(Name,LevelUp, HNew),
	asserta(stat_tokemon(Id,Name,HNew,LevelUp,ExpNew,ExpMaxNew)), !.

handleLegendDead(Id) :-
	((Id = 1, retract(statLegend1(_)), asserta(statLegend1(1)));
	 (Id = 2, retract(statLegend2(_)), asserta(statLegend2(1)))),
	legendKillCount(X),
	Xnew is X+1,
	retract(legendKillCount(_)),
	asserta(legendKillCount(Xnew)),
	checkWin, !.

handleLegendDead(_) :- !.

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
