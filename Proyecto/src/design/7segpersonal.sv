module sevenseg_display_single (
    input  logic [3:0] numero_binario,  // número 0-15 a mostrar
    output logic [6:0] seg_o,           // segmentos a-g
    output logic an_o                    // control de transistor / pin FPGA
);

    wire A, B, C, D;

    // Mapear bits del número a variables para claridad
    assign A = numero_binario[3];
    assign B = numero_binario[2];
    assign C = numero_binario[1];
    assign D = numero_binario[0];

    // Lógica para cada segmento (a-g)
    assign seg_o[0] = (~A & B & D) |               // segmento A
                    (~A & C) |
                    (A & ~B & ~C) |
                    (A & ~D) |
                    (~B & ~D) |
                    (B & C);  

assign seg_o[1] = (~B & ~D) |     // segmento B
                    (~B  & ~C) |
                    (~A & ~C & ~D) |
                    (A & ~C & D) |
                    (~A & C & D); 

assign seg_o[2] = (~B & ~C) |     // segmento C
                    (~C & D) |
                    (~A & B) |
                    (A & ~B) |
                    (~B & D);        

assign seg_o[3] = (~B & ~C & ~D) |     // segmento D
                    (A & B & ~D) |
                    (B & ~C & D) |
                    (~B & C & D) |
                    (~A & C & ~D);

assign seg_o[4] = (~B & ~D) |          // segmento E
                    (A & B) |
                    (A & C) |
                    (C & ~D);

assign seg_o[5] = (~C & ~D) |         // segmento F
                    (~A & B & ~C) |
                    (A & ~B ) |
                    (B & ~D) |
                    (A & C); 

assign seg_o[6] = (~B & C) |         // segmento G
                    (C & ~D) |
                    (A & ~B) |
                    (A & D)|
                    (~A & B & ~C);       

                  
    
    // Siempre habilitado para un solo display
    assign an_o = 1'b1;

endmodule