// Interfejs koprocesora szyfru blokowego rc6, pracuje na 128 bitowym bloku danych i 256 bitowym kluczu
module RC6encryption(
	input		wire			  	inClk,
	input		wire				inReset,
	input		wire				inKeyWr,
	input		wire				inDataWr,
	input 	wire 	[127:0] 	inData,
	input		wire	[255:0] 	inKey,
	output 	wire 	[127:0] 	outData,
	output	wire				outBusy
	);

////////////////////////////// Out Control ////////

wire	wireOutControl_outKeyExtWr;
wire	wireOutControl_outKeyIntWr;
wire	wireOutControl_outDataExtWr;
wire	wireOutControl_outDataIntWr;
wire	wireOutControl_outMode1;
wire	wireOutControl_outMode2;

////////////////////////////// Out Key Reg ////////

wire	[63:0]	wireOutKeyReg_outSubKeys;
wire	[31:0]	wireOutKeyReg_outKey0;
wire	[31:0]	wireOutKeyReg_outKey1;
wire	[31:0]	wireOutKeyReg_outKey2;
wire	[31:0]	wireOutKeyReg_outKey3;
wire	[31:0]	wireOutKeyReg_outLvalue;
wire	[31:0]	wireOutKeyReg_outSvalue;
wire	[31:0]	wireOutKeyReg_outAdata;
wire	[31:0]	wireOutKeyReg_outBdata;

////////////////////////////// Out Key Expansion //

wire	[31:0]	wireOutKeyExpansion_outSvalue;
wire	[31:0]	wireOutKeyExpansion_outLvalue;

////////////////////////////// Out RC6 Round //////

wire	[127:0]	wireOutRC6round_outData;

////////////////////////////// Out Data Reg ///////

wire	[127:0]	wireOutDataReg_outData;


// Rejestr klucza	
RC6keyReg _RC6keyReg(
	.inClk(inClk),
	.inReset(inReset),
	.inExtWr(wireOutControl_outKeyExtWr),
	.inIntWr(wireOutControl_outKeyIntWr),
	.inKeyRd(wireOutControl_outDataIntWr),
	.inExtKey(inKey),
	.inSvalue(wireOutKeyExpansion_outSvalue),
	.inLvalue(wireOutKeyExpansion_outLvalue),
	.outKey0(wireOutKeyReg_outKey0),
	.outKey1(wireOutKeyReg_outKey1),
	.outKey2(wireOutKeyReg_outKey2),
	.outKey3(wireOutKeyReg_outKey3),
	.outSubKeys(wireOutKeyReg_outSubKeys),
	.outLregValue(wireOutKeyReg_outLvalue),
	.outSregValue(wireOutKeyReg_outSvalue),
	.outAdata(wireOutKeyReg_outAdata),
	.outBdata(wireOutKeyReg_outBdata)
	);

// Moduł rozszerzania tablicy L oraz S	
RC6keyExpansion _RC6keyExpansion(
	.inLregValue(wireOutKeyReg_outLvalue),
	.inSregValue(wireOutKeyReg_outSvalue),
	.inAdata(wireOutKeyReg_outAdata),
	.inBdata(wireOutKeyReg_outBdata),
	.outAdata(wireOutKeyExpansion_outSvalue),
	.outBdata(wireOutKeyExpansion_outLvalue)
	);

// Układ sterowania
RC6control _RC6control(
	.inClk(inClk),
	.inReset(inReset),
	.inKeyWr(inKeyWr),
	.inDataWr(inDataWr),
	.outKeyExtWr(wireOutControl_outKeyExtWr),
	.outKeyIntWr(wireOutControl_outKeyIntWr),
	.outDataExtWr(wireOutControl_outDataExtWr),
	.outDataIntWr(wireOutControl_outDataIntWr),
	.outMode1(wireOutControl_outMode1),
	.outMode2(wireOutControl_outMode2),
	.outBusy(outBusy)
	);

// Rejestr rundy	
RC6dataReg _RC6dataReg(
	.inClk(inClk),
	.inReset(inReset),
	.inExtWr(wireOutControl_outDataExtWr),
	.inIntWr(wireOutControl_outDataIntWr),
	.inExtData(inData),
	.inIntData(wireOutRC6round_outData),
	.outData(wireOutDataReg_outData)
	);

// Moduł obliczania rundy algorytmu
RC6round _RC6round(	
	.inMode1(wireOutControl_outMode1),
	.inMode2(wireOutControl_outMode2),
	.inKey0(wireOutKeyReg_outKey0),
	.inKey1(wireOutKeyReg_outKey1),
	.inKey2(wireOutKeyReg_outKey2),
	.inKey3(wireOutKeyReg_outKey3),
	.inData(wireOutDataReg_outData),
	.inSubKeys(wireOutKeyReg_outSubKeys),
	.outData(wireOutRC6round_outData)
	);

// Rejestr wyjściowy, ale on nie jest chyba jakiś konieczny, on tylko kolejność bajtów zmienia aby wynik był lepiej przedstawiony na wyjściu
RC6dataOutReg _RC6dataOutReg(
	.inClk(inClk),
	.inRd(wireOutControl_outMode2),
	.inReset(inReset),
	.inData(wireOutRC6round_outData),
	.outData(outData)
	);
	
endmodule