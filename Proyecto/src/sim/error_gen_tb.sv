`timescale 1ns/1ps
module error_gen_tb;
    logic i [3:0];
    logic c [2:0];
    logic sw_error [3:0];

    module error_gen dut (.i(i), .c(c), .sw_error(sw_error)); //Asignacion explicita de puertos
    initial begin
        // Caso 1: No error
        sw_error = 3'b000;
        #10;
        $display("Caso 1: No error");
        $display("i: %b, c: %b", i, c);

        // Caso 2: Error en bit 0
        sw_error = 4'b0001;
        #10;
        $display("Caso 2: Error en bit 0");
        $display("i: %b, c: %b", i, c);

        // Caso 3: Error en bit 1
        sw_error = 3'b010;
        #10;
        $display("Caso 3: Error en bit 1");
        $display("i: %b, c: %b", i, c);

        // Caso 4: Error en bit 2
        sw_error = 3'b100;
        #10;
        $display("Caso 4: Error en bit 2");
        $display("i: %b, c: %b", i, c);
        // Finish simulation
        $finish;
    end
    endmodule
endmodule