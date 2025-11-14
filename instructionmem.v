module instruction_memory (address,readdata,rst_n);

input [31:0] address;
output [31:0] readdata;
input rst_n;

// creating a memory 
reg [31:0] memo [1023:0]; //1024 registers each 32 bit
// data stored at specified address in the memory will be mapped to readdata

assign readdata = (~rst_n) ? 32'd0 : memo[address[31:2]]; 
// assign readdata = memo[address[31:2]] // this address would help to choose the memory location 
// why the [31:2] ; Because each instruction is 4 bytes (32 bits) and Memory is word-addressed (not byte-addressed).

initial begin
    //memo[0] = 32'hFFC4A303;
    //memo[1] = 32'h00832383;
    //memo[0] = 32'h0064A423;
    memo[0] = 32'h0062E233;
end

endmodule
