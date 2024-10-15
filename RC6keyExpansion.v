module RC6keyExpansion(
    input   wire    [31:0]  inLregValue,
    input   wire    [31:0]  inSregValue,
    input   wire    [31:0]  inAdata,
    input   wire    [31:0]  inBdata,
    output  wire    [31:0]  outAdata,
    output  wire    [31:0]  outBdata
    );

/////////////////////

wire    [4:0]   RotationValue;
wire    [31:0]  temp1;
wire    [31:0]  temp2;

/////////////////////


assign temp1 = inSregValue + inAdata + inBdata;

assign outAdata = {temp1[28:0], temp1[31:29]};

assign RotationValue = outAdata + inBdata;

assign temp2 = inLregValue + outAdata + inBdata;

RC6dynamicRotFun _RC6dynamicRotFun1(.inRotValue(RotationValue), .inData(temp2), .outData(outBdata));

endmodule
