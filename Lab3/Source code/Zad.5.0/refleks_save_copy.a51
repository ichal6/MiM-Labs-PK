rand8reg equ 20h	;one byte
startWaitingTime EQU 0x20 ; startowy czas swiecenia diody

waitTime DATA 60h ; aktulualny czas swiecenia

CSEG AT 0
	JMP INIT_REFLEX

CSEG AT 100h
	INIT_REFLEX:
		MOV waitTime, #startWaitingTime ; laduj do pamieci domyslna wartosc czasu swiecenia diody

	GENERATE_RANDOM_NUMBER_OF_DIODE:
		ACALL rand8
		ACALL rand8
	
	INIT_PROGRAM:
		MOV A, #255
		SUBB A, rand8reg
		MOV R3, waitTime
		MOV R4, A
		
	SWITCH_DIODE: ; funkcja sluzaca do wlaczania diod
		MOV A, R4 ; przenies wartosc z R4 do akumulatora
		XRL A, #0FFh ; wykonaj alternatywe wykluczajaca, by zapalic konkretne diody
		MOV P2, A ; wpisz wartosc akumulatora do linii P2
		
	SET_TIMER:
		MOV TMOD, #01h ; ustawia licznik w tryb 16-bitowy
		SETB TR0 ; wlacz licznik 0
		JNB TF0, $ ; oczekiwanie na przepelnienie licznika
		CLR TF0 ; wyzeruj bit przepelnienia
		DEC R3 ; zmniejsz R3
		MOV A, R3 ; kopiuj wartosc R3 do A
		JNZ SET_TIMER ; jesli A = 0 idz dalej, jesli nie wroc do SET_TIMER
		SJMP CHECK_ANSWER ; skok do CHECK_ANSWER	
		
	CLEAR_TIMER: ; zeruje i ustawia TIMER0
		CLR TF0 ; zeruje bit przepelnienia
		MOV TL0, #0 ; zeruje TL0
		MOV TH0, #0 ; zeruje TH0

	CHECK_ANSWER:
		; ACALL CZEKAJ2 ; wywolaj funkcje czekaj, czas na odpowiedz uzytkownika
		MOV A, P3 ; zczytaj wartosc klawiszy z linii P3
		XRL A, #0FFh ; wykonaj XOR by sprawdzic, czy jakis klawisz jest wcisniety

		MOV R2, A ; wczytaj wartosc wcisinietego klawisza do rjestru R2
		MOV A, R4 ; wczytaj wartosc wylosowanej diody do rejestru R4
		ANL A, R2 ; wykonaj iloczyn logiczny zapalonej diody oraz wcisnietego klawisza, wynik zapisz do A
	
		JNZ WIN ; jesli wynik rozny od 0 idz do funkcji WIN, jesli nie idz dalej
		
	WRONG_ANSWER:
		; ACALL ADD_MORE_TIME ; dodaj wiecej czasu na reakcje
		; JB TF0, LOSE ; sprawdz czy doszlo do przpelnienia timera0, jesli tak idz do CLEAR_TIMER
		ACALL ADD_MORE_TIME
		AJMP GENERATE_RANDOM_NUMBER_OF_DIODE ; wylosuj nowa diode do zaswiecenia
		; MOV A, #0h ; zeruje akumulator
		; MOV ACC.0, C ; sprawdz czy wystapilo przepelnienie (Jesli carry flag ustawione na 1, ustaw A na 1)
		; AJMP SET_TIMER ; jesli tak zakoncz gre, jesli nie kontynuuj, idz do SET_TIMER

	LOSE: ; do usuniecia???
		MOV P2, #0 ; sekwencja porazki
		JMP END_PROGRAM

	WIN:
		MOV P2, #010101010b ; zapal sekwencje zwyciestwa
	
	END_PROGRAM: ; Zakoncz program
		CLR TR0 ; zatrzymaj timer0
		JMP END_PROGRAM

	CZEKAJ2:
		; ACALL CLEAR_TIMER ; zeruj licznik
		LOOP:
			MOV A, TH0 ; prznies wartosc z TL0 do A
			CJNE A, #0xFF, LOOP
		ACALL ADD_MORE_TIME
		RET ; powrot z funkcji

	ADD_MORE_TIME: ; funkcja dodajaca wiecej czasu na reakcje
		MOV A, waitTime ; prznies wartosc waittime do akumulatora
		ADD A, #20h ; dodaj 20h do akumulatora
		MOV waitTime, A ; zapisz wartosc z akumulatora do waitTime (RAM)
		RET ; powrot z funkcji
		
	CZEKAJ: ; funkcja czekaj
		MOV R5, waitTime
		
		L1: NOP
			MOV R6, waitTime
			
			L2: NOP 
				MOV R7, waitTime
				; Petla L3 zuzyje 255*3 cykli maszynowych
				L3: NOP			; instrukcja 1-cyklowa
		
				DJNZ R7, L3 ; instrukcja 2-cyklowa   
			DJNZ R6, L2
		DJNZ R5, L1
		
		RET ; powrot z funkcji

	rand8:	mov	a, rand8reg
		jnz	rand8b
		cpl	a
		mov	rand8reg, a
	rand8b:	anl	a, #10111000b
		mov	c, p
		mov	a, rand8reg
		rlc	a
		mov	rand8reg, a
		;ACALL CZEKAJ
		ret
	
END