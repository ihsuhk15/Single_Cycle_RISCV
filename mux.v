module multiplexer (i1,i2,sel,out);

input [31:0] i1,i2;
output [31:0] out; 
input sel;

assign out = (!sel) ? i1 : i2;

endmodule

