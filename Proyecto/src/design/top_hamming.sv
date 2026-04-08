module top_hamming ( /*Las entradas y salidas que se instancian el parentesis son las que interactuan con el mundo exterior, sea que entren de el o salgan a el mundo exterior, como los switches, leds, displays, etc. */

    input  logic [3:0] Numero_binario,
    input  logic [2:0] idx,

    output logic [6:0] seg_o,
    output logic an_o,
    output logic [3:0] i,
    output logic [2:0] c
);

    // Señales internas
    logic [6:0] hamming_out;
    

    // =========================
    // Instancia: Generador Hamming
    // =========================
    module_hamming u_hamming (
        .Numero_binario(Numero_binario),
        .hamming(hamming_out)
    );

    // =========================
    // Instancia: Generador de error
    // =========================
    error_gen u_error (
    .hamming_in(hamming_out),
    .idx(idx),
    .i(i),
    .c(c)
);

    // =========================
    // Instancia: Display 7 segmentos
    // (mostrando los datos reconstruidos "i")
    // =========================
    sevenseg_display_single u_display (
        .numero_binario(i),
        .seg_o(seg_o),
        .an_o(an_o)
    );

endmodule