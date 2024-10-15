module RC6round(
    input  wire           inMode1,	// Sygnał aktywny podczas pierwszej rundy, umożliwia dodanie kluczy S[0]  i S[1]
    input  wire           inMode2,	// Sygnał aktywny podczas ostatniej rundy, umożliwia dodanie kluczy S[42] i S[43]
    input  wire  [31:0]   inKey0,	// Klucz [S0], będzie zmieniał się co rundę, bo rejestr S[i] jest przesuwny, ale interesuje nas tylko to, co przechowywane jest tu w pierwszej rundzie, czyli S[0]
    input  wire  [31:0]   inKey1,	// Klucz	[S1], podawany do obliczeń tylko w pierwszej rundzie algorytmu
    input  wire  [31:0]   inKey2,	// Klucz [S42], podawany w ostatniej rundzie do rejestru A po permutacji bloków
    input  wire  [31:0]   inKey3,	// Klucz	[S43], podawany w ostatniej rundzie do rejestru C po permutacji bloków
    input  wire  [127:0]  inData,	// Dane wejściowe rejestru rundy, blok 128 bitowy
    input  wire  [63:0]   inSubKeys,// Podklucze S[2i] oraz S[2i+1] do obliczeń rundowych
    output wire  [127:0]  outData	// Wyjście 128 bitowe wyniku obliczeń rundy
    );
	 
wire [31:0] Adata;	 
wire [31:0] Bdata;
wire [31:0] Cdata;
wire [31:0] Ddata;

//////////////////

wire [31:0] B_final;
wire [31:0] D_final;

//////////////////
	 
wire [31:0] tVariable;
wire [31:0] uVariable;

//////////////////

wire [4:0] t_shift;
wire [4:0] u_shift;

//////////////////
	 
wire [63:0] temp0_full;
wire [63:0] temp1_full;
	
//////////////////
	
wire [31:0] temp0;
wire [31:0] temp1;
wire [31:0] temp3;
wire [31:0] temp4;
wire [31:0] temp5;
wire [31:0] temp6;
	 	 
// Początkowe dodawanie kluczy S[0] i S[1] (tylko w pierwszej rundzie, gdy inMode1 jest aktywne)
assign Bdata = (inMode1) ? (inData[95:64] + inKey0) : inData[95:64];
assign Ddata = (inMode1) ? (inData[31:0] + inKey1)  : inData[31:0];

// Obliczenia zmiennych tVariable i uVariable
assign temp0_full = Bdata * ({Bdata[30:0], 1'b0} + 1); // Zamiana operacji mnożenia, mnożenie * 2 to przesunięcie ciągu bitowego o bit w lewo
assign temp0 = temp0_full[31:0]; // Dolne 32 bity
assign tVariable = {temp0[26:0],temp0[31:27]};

assign temp1_full = Ddata * ({Ddata[30:0], 1'b0} + 1); // Zamiana operacji mnożenia, mnożenie * 2 to przesunięcie ciągu bitowego o bit w lewo
assign temp1 = temp1_full[31:0]; // Dolne 32 bity	 
assign uVariable = {temp1[26:0],temp1[31:27]};

// Ograniczenie przesunięcia do 5 bitów, bo max przesunięcie będzie o 31 bitów. 32 bity to brak przesunięcia.
assign t_shift = tVariable[4:0];
assign u_shift = uVariable[4:0];

// Obliczanie Adata i Cdata
assign temp3 = inData[127:96] ^ tVariable;
	 
RC6dynamicRotFun _RC6dynamicRotFun2(.inRotValue(u_shift), .inData(temp3), .outData(temp4));

assign temp5 = inData[63:32] ^ uVariable;
	 
RC6dynamicRotFun _RC6dynamicRotFun3(.inRotValue(t_shift), .inData(temp5), .outData(temp6));

assign Adata = (temp4 + inSubKeys[31:0]);
assign Cdata = (temp6 + inSubKeys[63:32]);

// Dodanie końcowych kluczy, jeśli inMode2 jest aktywne
assign B_final = (Bdata + inKey2);
assign D_final = (Ddata + inKey3);

// Permutacja bloków danych
assign outData = (inMode2 == 1'b1) ? {B_final, Cdata, D_final, Adata} : {Bdata, Cdata, Ddata, Adata};

endmodule
