//7'b0110011 R-type 
//7'b0000011 I-type (loads)
//7'b0100011 S-type (stores)
//7'b1100011 B-type (branches)
//7'b0010011 I-type ALU immediate (addi, andi, ...)
//7'b0110111 U-type (lui)
//7'b1101111 J-type (jal)

module maindeco (opcode,zero,alusrc,memtoreg,regwrite,memread,memwrite,pcsrc,aluop,immsrc);

input [6:0] opcode;
input zero;

output alusrc;
output memtoreg;
output regwrite;
output memread;
output memwrite;
output pcsrc;

output [1:0] immsrc,aluop;

wire branch;
wire jump;

assign alusrc = (((opcode == 7'b0000011) 
|| (opcode == 7'b0100011) 
|| (opcode == 7'b0110111) 
|| (opcode == 7'b0010011)
|| (opcode == 7'b1101111)) 
? 1'b1 : 1'b0);

assign memtoreg = ((opcode == 7'b0000011) ? 1'b1 : 1'b0);

assign regwrite = (((opcode == 7'b0110011) 
|| (opcode == 7'b0000011) 
|| (opcode == 7'b0110111) 
|| (opcode == 7'b0010011)
|| (opcode == 7'b1101111)) 
? 1'b1 : 1'b0);

assign memread = ((opcode == 7'b0000011) ? 1'b1 : 1'b0);

assign memwrite = ((opcode == 7'b0100011) ? 1'b1 : 1'b0);

assign branch = ((opcode == 7'b1100011) ? 1'b1 : 1'b0);

assign jump   = ((opcode == 7'b1101111) ? 1'b1 : 1'b0);

assign aluop = ((opcode == 7'b0110011) ? 2'b10 : 
(opcode == 7'b1100011) ? 2'b01 : 
(opcode == 7'b0110111)? 2'b11 : 
(opcode == 7'b0010011) ? 2'b10 : 2'b00);

assign immsrc = ((opcode == 7'b0100011) ? 2'b01 : 
(opcode == 7'b1100011) ? 2'b10 : 
(opcode == 7'b0110111) ? 2'b11 :
(opcode == 7'b1101111) ? 2'b11 : 2'b00);

assign pcsrc = (branch & zero) | jump;

endmodule