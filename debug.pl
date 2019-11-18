% Tugas Besar IF2121 Logika Komputasional
% Kelompok    :   09
% Kelas       :   03
% Anggota     :   - 13518018/Steve Bezalel Imam Gustaman
%                 - 13518057/Muhammad Daru Darmakusuma
%                 - 13518096/Naufal Arfananda Ghifari
%                 - 13518135/Gregorius Jovan Kresnadi


/* =============  INCLUDED FILES  ============= */
:- include('main.pl').


start(d) :-
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
	title,
	write('######## DEBUG MODE ########'), nl,
	write('Anda adalah akill, pokemon Anda adalah lumud level 100'), nl,
	%addPemain(akill,10,9,tl),
	addPemain(akill,18,21,bl),
	%addPemain(akill,44,24,br),
	asserta(tokemonCount(0)),
	asserta(mayCapture(0, -1)),
	asserta(inGym(0)),
	asserta(inLegend(0)),
    addTokemon(lumud,100,0), add2InvTokemon(0), addWildTokemon,
	asserta(legendKillCount(0)),
	asserta(statLegend1(0)),
	asserta(statLegend2(0)), !.
