module RC6control(
	input 	wire 			inClk,
	input 	wire 			inReset,
	input 	wire 			inKeyWr,
	input		wire 			inDataWr,
	output	wire			outKeyExtWr,
	output	wire			outKeyIntWr,
	output	wire			outDataExtWr,
	output	wire			outDataIntWr,
	output	wire			outMode1,
	output	wire			outMode2,
	output	wire			outBusy
	);
	
reg	[8:0]	regCounter = 9'b0;

always @(posedge(inClk)) begin
	if (inReset == 1'b1 || regCounter == 8'd152) begin
		regCounter <= 9'b0;
	end else
	
	if ((inKeyWr == 1'b1 && inDataWr == 1'b1) || regCounter != 9'b0) begin
		regCounter <= regCounter + 9'd1;
	end
end


// Sygnały przeznaczone dla rejestru klucza:

assign outKeyExtWr 		= (regCounter == 9'b0) ? inKeyWr : 1'b0;

assign outKeyIntWr 		= (regCounter == 9'b0 || regCounter > 9'd132) ? 1'b0 : 1'b1;

assign outDataIntWr 		= (regCounter > 9'd132) ? 1'b1 : 1'b0;

// Sygnały przeznaczone dla rejestru rundy danych:

assign outDataExtWr 		= (regCounter == 9'b0) ? inDataWr : 1'b0;

assign outMode1	 		= (regCounter == 9'd133) ? 1'b1 : 1'b0;

assign outMode2	 		= (regCounter == 9'd152) ? 1'b1 : 1'b0;

// Sygnały przekazywane do interfejsu zewnętrznego:

assign outBusy  			= (regCounter == 9'b0) ? 1'b0 : 1'b1;

endmodule