// U-type (lui) and J-type (jal) dont use ALU so we will consider only R S T and I (the ones listed in maindeco)

module aludeco (aluop,funct3,funct7,alucontrol);

input [1:0] aluop;      // From main decoder (depends on instruction type)
input [2:0] funct3;     // bits [14:12] of instruction (defines operation type)
input [6:0] funct7; // funct7 = bits [31:25]; op = bits [6:0] (opcode)

output [3:0] alucontrol; // 4-bit control signal to ALU

wire f75 = funct7[5];

assign alucontrol = ((aluop == 2'b00) ? 4'b0000 : //lw/sw
((aluop == 2'b01) && (funct3 == 3'b000)) ? 4'b0001 : //beq
((aluop == 2'b10) && (funct3 == 3'b000) && (f75 == 1'b0)) ? 4'b0000 : //add 
((aluop == 2'b10) && (funct3 == 3'b000) && (f75 == 1'b1)) ? 4'b0001 : //sub 
((aluop == 2'b10) && (funct3 == 3'b111) && (f75 == 1'b0)) ? 4'b0010 : //and 
((aluop == 2'b10) && (funct3 == 3'b110) && (f75 == 1'b0)) ? 4'b0011 : //or
((aluop == 2'b10) && (funct3 == 3'b100) && (f75 == 1'b0)) ? 4'b0100 : //xor
4'b0000); 

// funct7[5] is used only when funct3 == 000 so for and or xor it doesnt matter as such

//ALUOp = 00 → Load/Store → Always ADD.
//ALUOp = 01 → Branch → SUB.
//ALUOp = 10 → R/I type arithmetic → Use funct3/funct7 to decide operation.

endmodule









