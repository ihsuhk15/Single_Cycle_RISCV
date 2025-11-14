// 0000: ADD
// 0001: SUB
// 0010: AND
// 0011: OR
// 0100: XOR
// 0101: NOT
// 0110: Shift Left Logical (SLL)
// 0111: Shift Right Logical (SRL)
// 1000: Shift Right Arithmetic (SRA)

module singlecyclealu (i1,i2,sel,out,zero_flag,negative_flag,carry_flag,overflow_flag);

input [31:0]i1;
input [31:0]i2;
input [3:0]sel;
output [31:0]out;

// Flags 
output zero_flag;
output negative_flag;
output carry_flag;
output overflow_flag;

// Concatenating a 0 at the MSB making it 33 bits to capture the overflow bit generated as carry or borrow
wire [32:0] add_ext = {1'b0, i1} + {1'b0, i2};
wire [32:0] sub_ext = {1'b0, i1} - {1'b0, i2};


// Replaced assign with wire 
wire [31:0] add1 = i1 + i2;
wire [31:0] sub1 = i1 - i2;
wire [31:0] and1 = i1 & i2;
wire [31:0] or1 = i1 | i2;
wire [31:0] xor1 = i1 ^ i2;
wire [31:0] not1 = ~i1;
wire [31:0] sll  = i1 << i2[4:0]; // i1 << n - Shifts bits of i1 to the left by n positions; zeros fill from the right.
wire [31:0] srl  = i1 >> i2[4:0]; // i1 >> n - Shifts bits to the right by n positions; zeros fill from the left.
wire [31:0] sra  = $signed(i1) >>> i2[4:0]; // Shifts right keeping the sign bit (MSB) constant; replicates the sign bit to preserve sign for signed numbers.

assign out = (sel == 4'b0000) ? add1 :
(sel == 4'b0001) ? sub1 :
(sel == 4'b0010) ? and1 :
(sel == 4'b0011) ? or1  :
(sel == 4'b0100) ? xor1 :
(sel == 4'b0101) ? not1 :
(sel == 4'b0110) ? sll  : // bits move toward MSB and fall off from the left
(sel == 4'b0111) ? srl  : // bits move toward LSB and fall off from the right
(sel == 4'b1000) ? sra  :
32'hDEAD_BEEF;

// Set Flags 
assign zero_flag = (out == 32'b0); //expression compares all 32 bits of out to 0 and assigns 1 or 0 as output acc.
assign negative_flag = out[31]; //1 if MSB of result = 1 (2’s complement negative).
assign carry_flag = 
// ADD: carry from 33rd bit
(sel == 4'b0000) ? add_ext[32] :

// SUB: borrow = inverse of carry out
(sel == 4'b0001) ? ~sub_ext[32] :

// SLL (Shift Left Logical): MSB shifted out
(sel == 4'b0110 && i2[4:0] != 0) ? i1[32 - i2[4:0]] :

// SRL (Shift Right Logical): LSB shifted out
(sel == 4'b0111 && i2[4:0] != 0) ? i1[i2[4:0] - 1] :

// SRA (Shift Right Arithmetic): same as SRL for carry
(sel == 4'b1000 && i2[4:0] != 0) ? i1[i2[4:0] - 1] :

// Default: no carry
1'b0;  //used for usigned operation, Shows that the result is too big (or too small) to fit in the available bits

assign overflow_flag = (sel == 4'b0000) ? 
// ADD overflow: when two positives give negative OR two negatives give positive
((~i1[31] & ~i2[31] &  add1[31]) | (i1[31] & i2[31] & ~add1[31])) : (sel == 4'b0001) ?
// SUB overflow: when positive - negative gives negative OR negative - positive gives positive
((~i1[31] &  i2[31] &  sub1[31]) | (i1[31] & ~i2[31] & ~sub1[31])) : 1'b0;

endmodule
