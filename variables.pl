% KUMPULAN VARIABEL

%% Dynamic Variables

:- dynamic(pemain/5).
:- dynamic(inFight/4).
:- dynamic(mayCapture/2).
:- dynamic(tokemonCount/1).
:- dynamic(stat_tokemon/4).
:- dynamic(donePlayer/1).
:- dynamic(doneTokemon/1).
:- dynamic(inGym/1).

%% Static Variables
%% jenis_tokemon(Nama, Tipe, Base_Health, Nama_Attack, Nama_Special, Legend_or_normal).
jenis_tokemon(missingno,fire,999,att,spec,0).
jenis_tokemon(karma_nder,fire,100,duarr,nmax,0).
jenis_tokemon(tukangair,water,100,ciprat,sebor,0).
jenis_tokemon(lumud,leaves,100,kepelesed,badmud,0).
jenis_tokemon(kompor_gas,fire,125,bom,bitu,0).
jenis_tokemon(rerumputan,leaves,125,lambai,bergoyang,0).
jenis_tokemon(sugiono,water,69,genjot,crot,0).
jenis_tokemon(edukamon,leaves,135,startup,bukalepek,0).
jenis_tokemon(abhaigimon,water,182,warga,turun,0).
jenis_tokemon(martabak,earth,135,mamet,bowo,0).
jenis_tokemon(mumu,wind,125,badai,topan,0).
jenis_tokemon(gledek,lightning,125,halilintar,atta,0).
jenis_tokemon(hiring,lightning,125,sekip,debat,0).
jenis_tokemon(danus,earth,130,paid,promote,0).
jenis_tokemon(sesasasosa,leaves,200,sekali,tujuhkali,1).
jenis_tokemon(tubes,water,200,kelar,dapetA,1).

%% normal_attack(Nama_Attack,Base_Damage).
normal_attack(att,99).
normal_attack(duarr,15).
normal_attack(ciprat,15).
normal_attack(kepelesed,15).
normal_attack(bom,20).
normal_attack(lambai,20).
normal_attack(genjot,25).
normal_attack(startup,20).
normal_attack(warga,22).
normal_attack(mamet,20).
normal_attack(badai,18).
normal_attack(halilintar,20).
normal_attack(sekip,18).
normal_attack(paid,18).
normal_attack(sekali,35).
normal_attack(kelar,35).

%% special_attack(Nama_Special,Base_Damage).
special_attack(spec,-99).
special_attack(nmax,70).
special_attack(sebor,70).
special_attack(badmud,70).
special_attack(bitu,90).
special_attack(bergoyang,90).
special_attack(crot,69).
special_attack(bukalepek,95).
special_attack(turun,100).
special_attack(bowo,90).
special_attack(topan,85).
special_attack(atta,85).
special_attack(debat,80).
special_attack(promote,80).
special_attack(tujuhkali,77).
special_attack(dapetA,100).

%% tipeModifier(FromTipe, ToTipe, Modf).
%%fire<water<lightning<earth<leaves<wind<fire
%% from fire
tipeModifier(fire, fire, 1.0).
tipeModifier(fire, water, 0.5).
tipeModifier(fire, leaves, 1.5).
tipeModifier(fire, lightning, 1.0).
tipeModifier(fire, earth, 1.0).
tipeModifier(fire, wind, 1.0).
%% from water
tipeModifier(water, fire, 1.5).
tipeModifier(water, water, 1.0).
tipeModifier(water, leaves, 0.5).
tipeModifier(water, lightning, 1.0).
tipeModifier(water, earth, 1.0).
tipeModifier(water, wind, 1.0).
%% from leaves
tipeModifier(leaves, fire, 0.5).
tipeModifier(leaves, water, 1.5).
tipeModifier(leaves, leaves, 1.0).
tipeModifier(leaves, lightning, 1.0).
tipeModifier(leaves, earth, 1.0).
tipeModifier(leaves, wind, 0.0).
%% from lightning
tipeModifier(lightning, fire, 1.0).
tipeModifier(lightning, water, 1.0).
tipeModifier(lightning, leaves, 1.0).
tipeModifier(lightning, lightning, 1.0).
tipeModifier(lightning, earth, 0.5).
tipeModifier(lightning, wind, 1.5).
%% from earth
tipeModifier(earth, fire, 1.0).
tipeModifier(earth, water, 1.0).
tipeModifier(earth, leaves, 1.0).
tipeModifier(earth, lightning, 1.5).
tipeModifier(earth, earth, 1.0).
tipeModifier(earth, wind, 0.5).
%% from wind
tipeModifier(wind, fire, 1.0).
tipeModifier(wind, water, 1.0).
tipeModifier(wind, lightning, 1.0).
tipeModifier(wind, earth, 0.5).
tipeModifier(wind, leaves, 1.5).
tipeModifier(wind, wind, 1.0).

% MAPS (Location, Filename)
getMap(tl,'assets/petaTL.txt').
getMap(tr,'assets/petaTR.txt').
getMap(bl,'assets/petaBL.txt').
getMap(br,'assets/petaBR.txt').

%% GYM LOCATION (X, Y, peta)
gym_location(3,5,tl).

%% RELATIVE LOC COORDINATE CHANGE (peta, X, Y)
relative_coor(tl, 0, 0).
relative_coor(tr, -19, 0).
relative_coor(bl, 0, -16).
relative_coor(br, -29, -13).
