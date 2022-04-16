MY_KILLING_COPY SEGMENT CODE ; definiujemy segment kodu
Zrodlo DATA 20h  ; zrodlo danych 
Cel DATA 30h ; miejsce zapisu danych 
IleDanych EQU 16 ; ilosc danych do skopiowania
	
	
CSEG AT 0
JMP start ; w chwili uruchomienia programu zaczynamy od etykiety start


RSEG MY_KILLING_COPY ; umiejscowienie programu w pamieci dokonuje automatycznie assembler
					 ; programista nie wskazuje recznie miejsca w pamieci
	start: ; inicjalizacja programu
		MOV R0,#Zrodlo ; przenies adres miejsca w pamieci do rejestru R0 dla zrodla
		MOV R1,#Cel ; przenies adres miejsca w pamieci do rejestru R1 dla celu
		MOV R3,#IleDanych ; przenies ilosc komorek pamieci do przekopiowania do R3
	Petla:
		MOV A,@R0 ; przenosi dane z komorki pamieci wskazywanej przez R0 do akumulatora
		MOV @R1,A ; przenosi dane z akumulatora do komorki pamieci wskazywanej przez R1
		INC R0 ; inkrementuje wartosc R0
		INC R1 ; inkrementuje wartosc R1
	DJNZ R3,Petla ; sprawdza wartosc R1 jest rozny od zera, jesli tak wykonuje skok do Petla, jesli nie idzie dalej
END