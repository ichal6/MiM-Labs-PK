CSEG AT 0
	AJMP INIT

CSEG AT 0Bh ; przepelnienie Timera 0
	AJMP INTERRUPT_OVERFLOW ; idz do instrukcji przerwania

CSEG AT 30h
	
INIT:
	SETB EA ; globalne odblokowanie przerwan
	SETB ET0 ; odblokowanie przerwan na Timerze 0

	MOV TMOD, #00000001b ; Ustaw Timer 1 w tryb 16-bitowy
	SETB TR0 ; Start Timera 0

LICZ_CZAS:
	CJNE R0, #14, $ ; Czekaj az R0 równe 14, czyli uplynie 1 sekunda
	INC R2 ; inkrementuj rejestr R2 sluzacy do wyswietlania diod

	MOV A, R2 ; prznies wartosc rejestru R2 do A
	XRL A, #0FFh ; wykonaj alternatywe rozlaczna (funkcja XOR) miedzy A oraz wartoscia FF
	MOV P2, A ; zapal diody

	MOV R0, #0 ; Zeruj rejestr R0
	SJMP LICZ_CZAS ; uplynieciu sekundy wroc do LICZ_CZAS

INTERRUPT_OVERFLOW: ; Po przpelnieniu licznika wykonaj:
	INC R0 ; inkrementuj R0 - wykoano jeden cykl Timera
	RETI ; powrot z przerwania

END