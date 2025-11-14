module extender (inp,out,immsrc);

input [31:0] inp;
input [1:0] immsrc; // Chooses bw I and S type, if 01 S type

output [31:0] out;

assign out = (immsrc == 01) ? {{20{inp[31]}},inp[31:25],inp[11:7]} : 
{{20{inp[31]}},inp[31:20]};
// This is for S and I type 
// depending on what is the MSB (31st bit) prepend 0s or 1s 
// 1 is signed 0 is unsigned
// The aim to form a 32 bit immediate value

//00 → I-type
//01 → S-type
//10 → B-type
//11 → U/J-type (sometimes split)
    
endmodule