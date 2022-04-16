CSEG AT 0
AJMP reset
CSEG AT 30h
reset:
MOV SCON,#50h ; uart w trybie 1 (8 bit), REN=1
MOV TMOD,#20h ; licznik 1 w trybie 2
MOV TH1,#0FDh ; 9600 Bds at 11.0592MHz
SETB TR1 ; uruchomienie licznika
CLR TI ; wyzerowanie flagi wyslania
loop:
JNB RI,$ ; sprawdzenie flagi odbioru
MOV A,SBUF ; czytanie z uarta
CLR RI ; zerowanie flagi odbioru
CLR P2.0
INC A
MOV SBUF,A ; zapis do uarta
JNB TI,$ ; czekanie na opróznienie bufora nadajnika
CLR TI ; wyzerowanie flagi wyslania
SETB P2.0
AJMP loop
END