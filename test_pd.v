//author Mohd. Faizaan Qureshi

module test_processor(input clk, input reset);
    
    processor7 processor (clk, reset);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test_processor);
    end
endmodule