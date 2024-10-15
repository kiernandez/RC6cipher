module RC6keyReg(
	input		wire			 	inClk,
	input		wire			 	inReset,
	input 	wire			 	inExtWr,
	input 	wire			 	inIntWr,
	input		wire				inKeyRd,
	input 	wire 	[255:0] 	inExtKey,
	input		wire	[31:0]	inSvalue,
	input		wire	[31:0]	inLvalue,
	output	wire	[31:0]	outKey0,
	output	wire	[31:0]	outKey1,
	output	wire	[31:0]	outKey2,
	output	wire	[31:0]	outKey3,
	output	wire	[63:0]	outSubKeys,
	output 	wire 	[31:0] 	outLregValue,
	output	wire	[31:0]	outSregValue,
	output	wire	[31:0]	outAdata,
	output	wire	[31:0]	outBdata
	);

reg 	[255:0] 	regLarray 	= 256'b0;	// Tablica L skłądająca się z 8 32 bitowych segmentów klucza.
reg	[1407:0]	regSarray   = 1408'h4B32C376ACFB49BD0EC3D004708C564BD254DC92341D62D995E5E920F7AE6F675976F5AEBB3F7BF51D08023C7ED08883E0990ECA42619511A42A1B5805F2A19F67BB27E6C983AE2D2B4C34748D14BABBEEDD410250A5C749B26E4D901436D3D775FF5A1ED7C7E065399066AC9B58ECF3FD21733A5EE9F981C0B27FC8227B060F84438C56E60C129D47D498E4A99D1F2B0B65A5726D2E2BB9CEF6B20030BF38479287BE8EF45044D55618CB1CB7E15163;
reg	[31:0]	regAdata		= 32'b0;		// Rejestr A zainicjowany zerem przekazywany synchronicznie do rozszerzania klucza.
reg	[31:0]	regBdata		= 32'b0;		// Rejestr B zainicjowany zerem przekazywany synchronicznie do rozszerzania klucza.	



always @(posedge(inClk)) begin	// Blok przechowujący tablicę S[i]
	if(inReset == 1'b1) begin
		regSarray <= 1408'h4B32C376ACFB49BD0EC3D004708C564BD254DC92341D62D995E5E920F7AE6F675976F5AEBB3F7BF51D08023C7ED08883E0990ECA42619511A42A1B5805F2A19F67BB27E6C983AE2D2B4C34748D14BABBEEDD410250A5C749B26E4D901436D3D775FF5A1ED7C7E065399066AC9B58ECF3FD21733A5EE9F981C0B27FC8227B060F84438C56E60C129D47D498E4A99D1F2B0B65A5726D2E2BB9CEF6B20030BF38479287BE8EF45044D55618CB1CB7E15163;
		regLarray <= 256'b0;
		regAdata <= 32'b0;
		regBdata <= 32'b0;	
	end
	
	if(inExtWr == 1'b1) begin // Klucz np 40000000000000000000000000000000 przekonweetowany musi być na 00000000000000000000000000000040, inaczej obliczenia będą błędne, alternatywnie mozna podać od razu tak klucz
				regLarray[7:0]     <= inExtKey[255:248];
            regLarray[15:8]    <= inExtKey[247:240];
            regLarray[23:16]   <= inExtKey[239:232];
            regLarray[31:24]   <= inExtKey[231:224];
            regLarray[39:32]   <= inExtKey[223:216];
            regLarray[47:40]   <= inExtKey[215:208];
            regLarray[55:48]   <= inExtKey[207:200];
            regLarray[63:56]   <= inExtKey[199:192];
            regLarray[71:64]   <= inExtKey[191:184];
            regLarray[79:72]   <= inExtKey[183:176];
            regLarray[87:80]   <= inExtKey[175:168];
            regLarray[95:88]   <= inExtKey[167:160];
            regLarray[103:96]  <= inExtKey[159:152];
            regLarray[111:104] <= inExtKey[151:144];
            regLarray[119:112] <= inExtKey[143:136];
            regLarray[127:120] <= inExtKey[135:128];
            regLarray[135:128] <= inExtKey[127:120];
            regLarray[143:136] <= inExtKey[119:112];
            regLarray[151:144] <= inExtKey[111:104];
            regLarray[159:152] <= inExtKey[103:96];
            regLarray[167:160] <= inExtKey[95:88];
            regLarray[175:168] <= inExtKey[87:80];
            regLarray[183:176] <= inExtKey[79:72];
            regLarray[191:184] <= inExtKey[71:64];
            regLarray[199:192] <= inExtKey[63:56];
            regLarray[207:200] <= inExtKey[55:48];
            regLarray[215:208] <= inExtKey[47:40];
            regLarray[223:216] <= inExtKey[39:32];
            regLarray[231:224] <= inExtKey[31:24];
            regLarray[239:232] <= inExtKey[23:16];
            regLarray[247:240] <= inExtKey[15:8];
            regLarray[255:248] <= inExtKey[7:0];
	end
	
	if(inIntWr == 1'b1) begin
		regSarray <= {inSvalue, regSarray[1407:32]};	// Nadpisywany zostaje pierwszy podklucz S[i] wartością inSvalue
		regLarray <= {inLvalue,regLarray[255:32]}; // Nadpisywany zostaje pierwszy wykorzystany podklucz wartością inLvalue, podawany zostaje drugi podklucz
		regAdata <= inSvalue;
		regBdata <= inLvalue;
	end
	
	if(inKeyRd == 1'b1) begin // Przesunięcie 64 bitowe co parę kluczy, czyszczenie rejestru z wrażliwych danych
		regSarray <= {64'b0, regSarray[1407:64]};
	end
end


// Wyjścia podkluczy rejestru S[i], są wykorzystywane do wstępnego i końcowego mieszania bloku danych kluczami S[0], S[1], S[42] i S[43]
assign outKey0 = regSarray[31:0];		
assign outKey1 = regSarray[63:32];
assign outKey2 = regSarray[159:128];
assign outKey3 = regSarray[191:160];

// Wyjście dwóch podkluczy S[2i] i S[2i +1]
assign outSubKeys = regSarray[127:64];


assign outLregValue = regLarray[31:0];
assign outSregValue = regSarray[31:0];

// Rejestry A i B, które na początku były zainicjowane zerami, ale później przechowują pewne wartości obliczeń.
assign outAdata = regAdata;
assign outBdata = regBdata;


endmodule