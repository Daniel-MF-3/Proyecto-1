`timescale 1ns/1ps

module module_hamming_tb;

logic [3:0] Numero_binario;

logic [6:0] hamming;

int i;
module_hamming dut (
    .Numero_binario(Numero_binario),
    .hamming(hamming)
);

initial begin

    for (i = 0; i < 16; i = i + 1) begin
        Numero_binario = i;
        #10;
        $display("Entrada = %b, Salida = %b", Numero_binario, hamming);
    end

$finish;
end



endmodule