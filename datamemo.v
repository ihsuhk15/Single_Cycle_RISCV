module datafile (addr,write_e,write,read,clk,rst_n);

input [31:0] write;
input [9:0] addr; // since we have 1024 locations and 2^10 is 1024 therfore 10 bit addr
input clk,write_e,rst_n;

output [31:0] read;

reg [31:0] memo [1023:0];

    always @ (posedge clk)
    begin
        if(write_e)
            memo[addr] <= write;
    end

    assign read =  (~rst_n) ? 32'd0 : memo[addr];

initial begin 
 memo[28] = 32'h00000020;
 memo[40] = 32'h00000002;
end 
// data memory (RAM) does not get cleared on reset therefore we can skip it
// When the CPU resets, only control logic and registers are reset — not the memory contents.
// The RAM keeps whatever values were last written (or is undefined at power-up).
// Software (the program itself) decides what to initialize later.
    
endmodule

