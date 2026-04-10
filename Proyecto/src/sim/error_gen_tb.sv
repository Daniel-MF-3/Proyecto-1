`timescale 1ns/1ps

module error_gen_tb;

    logic [6:0] hamming_in;
    logic [2:0] idx;
    logic [3:0] i;
    logic [2:0] c;

    // DUT
    error_gen dut (.hamming_in(hamming_in),.idx(idx),.i(i),.c(c));

    initial begin
        // Base input (example Hamming word)
        hamming_in = 7'b1110011; 
        // hamming = [D4 D3 D2 P3 D1 P2 P1]
        // data bits (D4..D1): 1,1,1,0
        // parity bits (P3,P2,P1): 0,1,1
        // Case 0: No error (optional convention)
        idx = 3'd0;
        #10;
        $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);

        // Inject error in every possible bit
        for (int k = 1; k <= 7; k++) begin //
            idx = k;
            #10;
            $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);
        end

        $finish;
    end

endmodule