`include "pc.v"
`include "instructionmem.v"
`include "registerfile.v"
`include "immediate_extender.v"
`include "alu.v"
`include "controlunittop.v"
`include "datamemo.v"
`include "pcadder.v"
`include "mux.v"

module singletop (clk,rst_n);

input clk,rst_n;

wire [31:0] pctoaddr; // connects op of PC to ip of instruction memory
wire [31:0] imtoreg; // connects op of instructionmem to ip of registers 
wire [31:0] regtoalu1,regtoalu2; // connects op of reg to ip of alu
wire [31:0] imexttoalu; // connects op of extender to ip of alu
wire [3:0] cutoalu; // connects op of cu to ip of alu
wire [31:0] aluresult; // connects op of alu to ip of datamemo
wire regw; // connect op regwrite of CU to write_e of registers
wire [31:0] dmtoreg; // connects op of dm to write port of reg
wire [31:0] pc4;
wire [1:0] immsrcwire;
wire memwr;
wire alusrcwire;
wire [31:0] muxop;
wire resultsrc;
wire [31:0] dmmuxop;

programcounter pc (
    .pc(pctoaddr),
    .pcnext(pc4),
    .rst_n(rst_n),
    .clk(clk)
);

instruction_memory im(
    .address(pctoaddr),
    .readdata(imtoreg),
    .rst_n(rst_n)
);

multiplexer mxregtoalu (
    .i1(regtoalu2),
    .i2(imexttoalu),
    .sel(alusrcwire),
    .out(muxop)
);

regfile rg (
    .addr_r1(imtoreg[19:15]),
    .addr_r2(imtoreg[24:20]),
    .addr_w1(imtoreg[11:7]),
    .write(dmmuxop),
    .write_enable(regw),
    .read1(regtoalu1),
    .read2(regtoalu2),
    .clk(clk),
    .rst_n(rst_n)
);

extender immex (
    .inp(imtoreg),
    .out(imexttoalu),
    .immsrc(immsrcwire)
);

ctrlunit cu (
    .opcode(imtoreg[6:0]),
    .zero(),
    .f3(imtoreg[14:12]),
    .f7(),
    .memtoreg(resultsrc),
    .alusrc(alusrcwire),
    .regwrite(regw),
    .memread(),
    .memwrite(memwr),
    .pcsrc(),
    .alucontrol(cutoalu),
    .immsrc(immsrcwire)
);

singlecyclealu alu (
    .i1(regtoalu1),
    .i2(muxop),
    .sel(cutoalu),
    .out(aluresult),
    .zero_flag(),
    .negative_flag(),
    .carry_flag(),
    .overflow_flag()
);

datafile dm (
    .addr(aluresult[9:0]),
    .write_e(memwr),
    .write(regtoalu2),
    .read(dmtoreg),
    .clk(clk),
    .rst_n(rst_n)
);

pcadder pa (
    .i1(pctoaddr),
    .i2(32'd4),
    .sum(pc4)
);

multiplexer mxdmtorg (
    .i1(aluresult),
    .i2(dmtoreg),
    .sel(resultsrc),
    .out(dmmuxop)
);

endmodule