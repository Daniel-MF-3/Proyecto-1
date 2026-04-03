`timescale 1ns/1ps

module error_gen_tb;

    logic [6:0] hamming_in;
    logic [2:0] idx;
    logic [3:0] i;
    logic [2:0] c;

    // DUT
    error_gen dut (.hamming_in(hamming_in),.idx(idx),.i(i),.c(c));

    initial begin
        // Entrega de valores de entrada
        hamming_in = 7'b1010110;

        // Caso base: no error)
        idx = 3'd0;
        #10;
        $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);

        //7 posibles  posiones para invertir el bit y meter errores (1 por cada bit)
        for (int k = 1; k < 7; k++) begin //
            idx = k;
            #10;
            $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);
        end

        $finish;
    end

endmodule