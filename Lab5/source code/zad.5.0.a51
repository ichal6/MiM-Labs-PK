beginTable EQU 20h ; komorka poczatku tablicy
sizeTable EQU 16 ; dlugosc tablicy

CSEG AT 0 
	ACALL INIT ; idz do poczatku programu
CSEG AT 23h             ; pod adres 23h umieszczamy instrukcje
	LJMP UART_INTERRUPT	; skoku do procedury obslugi przerwan dla UART
	
CSEG AT 0x100
	INIT:
		MOV SCON, #50h ; uart w trybie 1 (8 bit), REN=1
		MOV TMOD, #20h ; licznik 1 w trybie 2
		MOV TH1, #0FDh ; 9600 Bds at 11.0592MHz
		SETB TR1 ; uruchomienie licznika
		CLR TI ; wyzerowanie flagi wyslania
		SETB ES ; zezwolenie na przerwanie z portu szeregowego
		SETB EA ; globalne odblokowanie przerwan
		ACALL RESET_BUFFER ; wywolaj funkcje resetu bufora
		AJMP MAIN_LOOP ; skok do glownej petli
	
	RESET_BUFFER:
		MOV R0, #beginTable ; inicjalizacja R0 wartoscia 20h, wskazujaca komorke pamieci
		MOV R1, #sizeTable ; inicjalizacja ilosci znakow do konca bufora
		RET
		
	MAIN_LOOP:
		SJMP MAIN_LOOP ; oczekiwanie na znak

	UART_INTERRUPT:
		PUSH PSW ; zapamietanie waznych rejestrów na stosie PSW i ACC
		PUSH ACC
		
		JBC TI, END_INTERRUPT ; sprawdzenie powodu przerwania, jesli ustawiona flaga nadawania -
							  ; wyjdz z przerwania, jesli nie idz dalej
		CLR RI ; zerowanie bitu odbioru - RI
		MOV @R0, SBUF ; przenies dane z SBUF do adresu wskazywanego przez R0	
		INC R0 ; podnies o jeden wartosc R0, ktora wskazuje komorke pamieci
		DJNZ R1, END_INTERRUPT ; dekrementuj R1 i skacz jesli nie jest rowne 0 do konca przerwania,
							   ; jesli nie idz dalej
		ACALL RESET_BUFFER ; wywolaj funkcje resetu bufora
		
		END_INTERRUPT: ; wyslij, ze stosu, do ACC i PSW wartosci sprzed przerwania
		POP ACC
		POP PSW
		RETI
END