// the register file has 32 registers, 32 bits each
//addr_r1 is for read1
//addr_r2 is for read2
//addr_w1 is for write

module regfile (addr_r1,addr_r2,addr_w1,write,write_enable,read1,read2,clk,rst_n);

input rst_n,clk,write_enable; //// rst is always active low 
input [4:0] addr_r1,addr_r2,addr_w1; //5 bits 
input [31:0] write;

output [31:0] read1,read2;

integer i;

//creating a memory
reg [31:0] registerarray [31:0]; // 1st - number, 2nd - bits

// Writes happen only on the positive clock edge and only if write_enable = 1.
// Reads happen instantly (no clock delay)
// if any addr is 0 then You can read it — it always returns 0, You cannot write to it, any attempt to write is ignored.

assign read1 = (~rst_n) ? 32'd0 : (addr_r1 == 5'd0) ? 32'd0 : registerarray [addr_r1];
assign read2 = (~rst_n) ? 32'd0 : (addr_r2 == 5'd0) ? 32'd0 : registerarray [addr_r2];

always @(posedge clk) 

begin 

if(write_enable)
    registerarray[addr_w1] <= write;

end  

initial begin 
registerarray[9] = 32'h00000020;
registerarray[6] = 32'h00000040;
end 

//Use non-blocking (<=) in clocked always blocks (sequential logic).
// Use blocking (=) in combinational always blocks.
// registerarray [0:31] or registerarray [31:0] both work
// two types of resets sync and async ; we are using syn since only on posedge and async happens for both neg and pos

endmodule

