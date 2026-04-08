`timescale 1ns/1ps

module tb_top_hamming;

    // Señales de prueba
    logic [3:0] Numero_binario;
    logic [2:0] idx;
    logic [3:0] i;
    logic [2:0] c;
    logic [6:0] seg_o;
    logic an_o;

    // Instancia del DUT (Device Under Test)
    top_hamming dut (
        .Numero_binario(Numero_binario),
        .idx(idx),
        .seg_o(seg_o),
        .an_o(an_o),
        .i(i),
        .c(c)
    );
    initial begin
        $dumpfile("top_hamming_tb.vcd"); 
        $dumpvars(0, tb_top_hamming);
    end
    // Proceso de estímulos
    initial begin
        // Inicialización
        Numero_binario = 4'b0000;
        idx = 3'd0;

        // Espera inicial
        #10;
        $display("t=%0t | Num=%b | idx=%d | i=%b | c=%b", $time, Numero_binario, idx, i, c);
        // =========================
        // Prueba sin error
        // =========================
        Numero_binario = 4'b0101; // 5
        idx = 3'd0;               // sin error
        #20;
        $display("t=%0t | Num=%b | idx=%d | i=%b | c=%b", $time, Numero_binario, idx, i, c);

        // =========================
        // Prueba con errores en distintos bits
        // =========================
        idx = 3'd1; // error en bit 0
        #20;
        $display("t=%0t | Num=%b | idx=%d | i=%b | c=%b", $time, Numero_binario, idx, i, c);


        idx = 3'd2; // error en bit 1
        #20;
        $display("t=%0t | Num=%b | idx=%d | i=%b | c=%b", $time, Numero_binario, idx, i, c);


        idx = 3'd3; // error en bit 2
        #20;
        $display("t=%0t | Num=%b | idx=%d | i=%b | c=%b", $time, Numero_binario, idx, i, c);


        idx = 3'd4; // error en bit 3
        #20;
        $display("t=%0t | Num=%b | idx=%d | i=%b | c=%b", $time, Numero_binario, idx, i, c);


        idx = 3'd5; // error en bit 4
        #20;
        $display("t=%0t | Num=%b | idx=%d | i=%b | c=%b", $time, Numero_binario, idx, i, c);


        idx = 3'd6; // error en bit 5
        #20;
        $display("t=%0t | Num=%b | idx=%d | i=%b | c=%b", $time, Numero_binario, idx, i, c);


        idx = 3'd7; // error en bit 6
        #20;
        $display("t=%0t | Num=%b | idx=%d | i=%b | c=%b", $time, Numero_binario, idx, i, c);


        // =========================
        // Cambiar dato de entrada
        // =========================
        Numero_binario = 4'b1010; // 10
        idx = 3'd0;
        #20;
        $display("t=%0t | Num=%b | idx=%d | i=%b | c=%b", $time, Numero_binario, idx, i, c);


        idx = 3'd3;
        #20;
        $display("t=%0t | Num=%b | idx=%d | i=%b | c=%b", $time, Numero_binario, idx, i, c);
        
        // =========================
        // Finalizar simulación
        // =========================
        $finish;
    end

endmodule