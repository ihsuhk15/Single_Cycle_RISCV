module pcadder (i1,i2,sum);

input [31:0] i1,i2;
output [31:0] sum;
assign sum = i1 + i2;

endmodule