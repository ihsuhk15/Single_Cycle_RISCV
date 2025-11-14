module risctop ();
    
    reg clk = 1'b1, rst_n = 1'b0;

    singletop sct (
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        $dumpfile("Single Cycle2.vcd");
        $dumpvars(0);
    end

    initial begin
        clk = 1'b0;          // start at 0 → rising edge at 50 ns
        forever #50 clk = ~clk;
    end
    
    initial
    begin
        rst_n <= 1'b0;
        #100; //creates racearound 

        rst_n <=1'b1;
        #300;

        $finish;
    end

endmodule