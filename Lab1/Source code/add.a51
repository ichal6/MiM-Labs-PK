Stala EQU 1000 ; nadanie nazwy stalej numerycznej
DanaL DATA 20h
DanaH DATA 21h
WynikL DATA 30h
WynikH DATA 31h

CSEG AT 0
	JMP start

CSEG AT 100h

; Instrukcja cel, zrodlo
;pod adres 20h wpisac wartosc 09h
;pod ardes 21h wpisac wartosc 0Ah

start:
	MOV A,DanaL ; Przenies DanaL do A - akumulator 
	ADD A,#low(Stala) ; Odczytaj wartosc mlodszego bitu stalej stala i dodaj ta wartosc do akumulatora 
	MOV WynikL,A ; wczytaj wartosc z akumulatora do zmiennej WynikL
	MOV A,DanaH ; Przenies DanaH do A - akumulator 
	ADDC A,#high(Stala) ; Odczytaj wartosc starszego bitu stalej stala i dodaj ta wartosc do akumulatora 
	MOV WynikH,A ; wczytaj wartosc z akumulatora do zmiennej WynikH
END