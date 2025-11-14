`include "aludecoder.v"
`include "maindecoder.v"

module ctrlunit (opcode,zero,f3,f7,memtoreg,alusrc,regwrite,memread,memwrite,pcsrc,alucontrol,immsrc);

input [6:0] opcode;
input zero;
input [2:0] f3;
input [6:0] f7;

output alusrc;
output memtoreg;
output regwrite;
output memread;
output memwrite;
output pcsrc;
output [3:0] alucontrol;
output [1:0] immsrc;

wire [1:0] aluwire;

maindeco md (
    .opcode(opcode),
    .zero(zero),
    .alusrc(alusrc),
    .memtoreg(memtoreg),
    .regwrite(regwrite),
    .memread(memread),
    .memwrite(memwrite),
    .pcsrc(pcsrc),
    .aluop(aluwire),
    .immsrc(immsrc)
);

aludeco alu (
    .aluop(aluwire),
    .funct3(f3),
    .funct7(f7),
    .alucontrol(alucontrol)
);

endmodule
