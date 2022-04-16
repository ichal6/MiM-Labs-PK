MY_KILLING_COPY SEGMENT CODE ; definiujemy segment kodu
Cel DATA 30h ; miejsce zapisu danych z etykiety do pamieci RAM
IleDanych EQU 5 ; definiujemy dlugosc etykiety
	
CSEG AT 0
JMP start ; w chwili uruchomienia programu zaczynamy od etykiety start

RSEG MY_KILLING_COPY ; umiejscowienie programu w pamieci dokonuje automatycznie assembler
					 ; programista nie wskazuje recznie miejsca w pamieci
start: ; inicjalizacja programu
	MOV DPTR, #etykieta ; przenies wartosc etykieta do data pointer(DPTR)
	MOV R0, #Cel ; przenies adres miejsca w pamieci do rejestru R0
	MOV R1, #IleDanych ; przenies rozmiar etykiety do rejestru R1
Petla:
	MOV A, #0h ; zeruj A po kazdym przejsciu petli
	MOVC A, @A+DPTR ; przenies dane z pamieci programu do akumulatora - wykorzystuje adresowanie posrednie
	INC DPTR ; inkrementacja wskaznika na dane z etykiety
	MOV @R0, A ; przenies dane z akumulatora do RO (adresowanie posrednie) 
	INC R0 ; inkrementuj RO 
	DJNZ R1, Petla ; sprawdza wartosc R1 jest rozny od zera, jesli tak wykonuje skok do Petla, jesli nie idzie dalej
	
etykieta: db 11,21,4,18,8 ; definicja etykiety
END
