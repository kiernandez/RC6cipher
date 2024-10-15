module TbRC6encryption;

parameter inClkp = 10;
reg inClk = 1'b0;

always
begin
    #(inClkp/2) inClk = !inClk;
end

///////////////////////
reg				inReset  = 1'b0;
reg 				inKeyWr  = 1'b0;
reg				inDataWr = 1'b0;
reg 	[127:0] 	inData   = 128'b0;
reg	[255:0] 	inKey 	= 256'b0;
wire 	[127:0] 	outData;
wire				outBusy;
///////////////////////

RC6encryption _RC6encryption(
	.inClk(inClk),
	.inReset(inReset),
	.inKeyWr(inKeyWr),
	.inDataWr(inDataWr),
	.inData(inData),
	.inKey(inKey),
	.outData(outData),
	.outBusy(outBusy)					
	);
	
always
begin
#(inClkp);
inKeyWr = 1'b1; inDataWr = 1'b1; inData = 128'b0; inKey = 256'h2000000000000000000000000000000000000000000000000000000000000000;
#(inClkp);
inKeyWr = 1'b0; inDataWr = 1'b0; inData = 128'b0; inKey = 256'b0;
#(inClkp);
wait(outBusy == 1'b0 && inClk == 1'b0);
#(inClkp);
inReset = 1'b1;
#(inClkp);
inReset = 1'b0;
$stop;
end
endmodule

