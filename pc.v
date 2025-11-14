module programcounter (pc,pcnext,rst_n,clk);

input [31:0] pcnext; // The next PC value ( pc + 4 )
input rst_n,clk; // rst_n - signal resets when it’s 0

output reg [31:0] pc;

 always @(posedge clk) //PC updates on the rising edge of clock 

    begin
        if(!rst_n) //if signal is 0
            pc <= {32{1'b0}};
        else // signal is 1
            pc <= pcnext; 
    end

// At clk 0 and rst 0 it shows pcnext to be x
// At clk 1 and rst 0 it shows pcnext to be 0 this is common for sync sys
// To avoid this set reset to low long enough to cover one rising edge

endmodule

