module RC6dynamicRotFun(
    input   wire    [4:0]   inRotValue,
    input   wire    [31:0]  inData,
    output  reg     [31:0]  outData
    );
    
    always @(*) begin
        case (inRotValue)
            5'd0:  outData = inData;
            5'd1:  outData = {inData[30:0], inData[31]};
            5'd2:  outData = {inData[29:0], inData[31:30]};
            5'd3:  outData = {inData[28:0], inData[31:29]};
            5'd4:  outData = {inData[27:0], inData[31:28]};
            5'd5:  outData = {inData[26:0], inData[31:27]};
            5'd6:  outData = {inData[25:0], inData[31:26]};
            5'd7:  outData = {inData[24:0], inData[31:25]};
            5'd8:  outData = {inData[23:0], inData[31:24]};
            5'd9:  outData = {inData[22:0], inData[31:23]};
            5'd10: outData = {inData[21:0], inData[31:22]};
            5'd11: outData = {inData[20:0], inData[31:21]};
            5'd12: outData = {inData[19:0], inData[31:20]};
            5'd13: outData = {inData[18:0], inData[31:19]};
            5'd14: outData = {inData[17:0], inData[31:18]};
            5'd15: outData = {inData[16:0], inData[31:17]};
            5'd16: outData = {inData[15:0], inData[31:16]};
            5'd17: outData = {inData[14:0], inData[31:15]};
            5'd18: outData = {inData[13:0], inData[31:14]};
            5'd19: outData = {inData[12:0], inData[31:13]};
            5'd20: outData = {inData[11:0], inData[31:12]};
            5'd21: outData = {inData[10:0], inData[31:11]};
            5'd22: outData = {inData[9:0],  inData[31:10]};
            5'd23: outData = {inData[8:0],  inData[31:9]};
            5'd24: outData = {inData[7:0],  inData[31:8]};
            5'd25: outData = {inData[6:0],  inData[31:7]};
            5'd26: outData = {inData[5:0],  inData[31:6]};
            5'd27: outData = {inData[4:0],  inData[31:5]};
            5'd28: outData = {inData[3:0],  inData[31:4]};
            5'd29: outData = {inData[2:0],  inData[31:3]};
            5'd30: outData = {inData[1:0],  inData[31:2]};
            5'd31: outData = {inData[0],    inData[31:1]};
        endcase
    end
    
endmodule
