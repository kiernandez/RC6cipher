module RC6dataReg(
	input		wire				inClk,
	input		wire				inReset,
	input		wire				inExtWr,
	input		wire				inIntWr,
	input		wire	[127:0]	inExtData,
	input		wire	[127:0]	inIntData,
	output	wire	[127:0]	outData
	);

reg	[127:0]	regData = 128'b0;

// Prosty rejestr rundy, na początku podaje plaintext, na czas rozszerzania klucza żaden sygnał nie jest aktywny.
// Po wygenerowaniu podkluczy tablicy S i wykonaniu pierwszej rundy dopiero inIntWr jest aktywne.
	
always @(posedge(inClk)) begin
	if(inReset == 1'b1) begin
		regData <= 128'b0;
	end
	
	if(inExtWr == 1'b1) begin
		regData <= inExtData;
	end
	
	if(inIntWr == 1'b1) begin
		regData <= inIntData;
	end
end

assign outData = regData;

endmodule