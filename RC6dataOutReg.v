module RC6dataOutReg(
	input		wire				inClk,
	input		wire				inRd,
	input		wire				inReset,
	input		wire	[127:0]	inData,
	output	wire	[127:0]	outData
	);

reg	[127:0]	regData = 128'b0;
	
always @(posedge(inClk)) begin	// Blok przechowujący obliczone w wyniku pierwszego taktu rejestry A i B.
	if(inReset == 1'b1) begin
		regData <= 128'b0;
	end
	
	if(inRd == 1'b1) begin			// Zmieniam kolejność bajtów, aby wynik końcowy był zgodny z wektorem testowym nessi (po prostu zapis danych inny)
		regData[127:120] <= inData[103:96]; 	// Bajt 15
		regData[119:112] <= inData[111:104]; 	// Bajt 14
		regData[111:104] <= inData[119:112]; 	// Bajt 13
		regData[103:96]  <= inData[127:120]; 	// Bajt 12

		regData[95:88]   <= inData[71:64]; 		// Bajt 11
		regData[87:80]   <= inData[79:72]; 		// Bajt 10
		regData[79:72]   <= inData[87:80]; 		// Bajt 9
		regData[71:64]   <= inData[95:88]; 		// Bajt 8

		regData[63:56]   <= inData[39:32]; 		// Bajt 7
		regData[55:48]   <= inData[47:40]; 		// Bajt 6
		regData[47:40]   <= inData[55:48]; 		// Bajt 5
		regData[39:32]   <= inData[63:56]; 		// Bajt 4

		regData[31:24]   <= inData[7:0]; 		// Bajt 3
		regData[23:16]   <= inData[15:8]; 		// Bajt 2
		regData[15:8]    <= inData[23:16]; 		// Bajt 1
		regData[7:0]     <= inData[31:24]; 		// Bajt 0
	end
end

assign outData = regData;			// I tu podanie danych wynikowych

endmodule