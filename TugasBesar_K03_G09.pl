% Gambaran Tugas Besar IF2121 Logika Komputasional
% Kelompok    :   09
% Kelas       :   03
% Anggota     :   - 13518018/Steve Bezalel Imam Gustaman
%                 - 13518057/Muhammad Daru Darmakusuma
%                 - 13518096/Naufal Arfananda Ghifari
%                 - 13518135/Gregorius Jovan Kresnadi



/* --- Deklarasi Fakta --- */
%% pemain(Nama,Inventory,Xpos,Ypos).
%% stat_tokemon(Id,Nama,Curr_Health,Max_Health,Level).
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
%% :- dynamic pemain/4.

start :- addPemain(akill, 7, 5).
addPemain(Nama, X, Y) :- asserta(pemain(Nama, [], X, Y)).

%% MOVE
w :- pemain(Name, L, X, Y), Ynew is (Y-1), retract(pemain(Name, _, _, _)), asserta(pemain(Name, L, X, Ynew)).
a :- pemain(Name, L, X, Y), Xnew is (X-1), retract(pemain(Name, _, _, _)), asserta(pemain(Name, L, Xnew, Y)).
s :- pemain(Name, L, X, Y), Ynew is (Y+1), retract(pemain(Name, _, _, _)), asserta(pemain(Name, L, X, Ynew)).
d :- pemain(Name, L, X, Y), Xnew is (X+1), retract(pemain(Name, _, _, _)), asserta(pemain(Name, L, Xnew, Y)).

AddString([], X) :-
%% DEBUG PRINT LIST
printlist([]).
printlist([X|List]) :-
	write(X),nl,
	printlist(List).

%% READ MAP FROM FILE
readMap(InStream,Chars):-
	get_code(InStream,Char),
	checkChar(Char,Chars,InStream).

checkChar(-1,[],_):-  !.
checkChar(end_of_file,[],_):-  !.
checkChar(Char,[Char|Chars],InStream):-
	get_code(InStream,NextChar),
	checkChar(NextChar,Chars,InStream).


replace([_|T], X, 0, [X|T]).
replace([H|T], X, Pos, [H|B]) :- Pos > 0, Posmin1 is Pos-1, replace(T, X, Posmin1, B).

%% (X, Y) = 24*Y + 2*X
replaceCoor(Chars, X, Y, Symbol, Replaced) :- Pos is  (24*Y + 2*X), replace(Chars, Symbol, Pos, Replaced).

map :-
	open('peta.txt',read,Str), !,
	readMap(Str, Chars),
	pemain(akill, _, X, Y),
	%% 80 = charcode P
	replaceCoor(Chars, X, Y, 80, MapwithP),
	atom_codes(M,MapwithP),
	close(Str),
	write(M),  nl.

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
	write('9. status : Melihat status diri.'),nl,
	write('10. quit : Keluar dari permainan.'),nl,
	/*write('9. take(object) : Mengambil object pada petak.'),nl,
	write('10. drop(object) : Membuang sebuah object dari inventory.'),nl,
	write('11. use(object) : Menggunakan sebuah object yang dalam inventori.'),nl,
	write('12. attack : Menyerang enemy dalam petak sama.'),nl,
	write('13. status : Melihat status diri.'),nl,
	write('14. save(filename) : Menyimpan permainan pemain.'),nl,
	write('15. loads(filename) : Membuka save-an pemain.'),nl,
	write('16. help : Menampilkan ini lagi.'),nl,
	write('Catatan : Semua command di atas diakhiri titik (Misal : "help.")'), nl, !.*/

status :-
	\+pemain(_,_,_,_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
status :-
	write('Your Tokemon            : '),healthpoint(Darah),write(Darah),nl,
	write('Armor              : '),armor(ArmorP),write(ArmorP),nl,
	statusWeapon,
	write('Kapasitas inventory: '),maxInventory(MaxInv),write(MaxInv),write(' barang'), nl,
	write('Isi inventory      : '),nl,
	inventory(_,_)->(
		forall(inventory(Obj,Atribut),
		(
			write('  -'),write(Obj),write(' : '),write(Atribut),
			(
				(isAmmo(Obj,_,_),write(' peluru'));
				(isSenjata(Obj,_),write(' damage'));
				(isArmor(Obj,_),write(' defense'));
				(isMedicine(Obj,_),write(' HP'));
				(isBag(Obj,_),write(' barang'))
			),nl
		))
	);(
		write(' Inventory kosong'),nl
	),
!.
