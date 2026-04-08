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
    assign segments[0] = (~A & B & D) |               // segmento A
                    (~A & C) |
                    (A & ~B & ~C) |
                    (A & ~D) |
                    (~B & ~D) |
                    (B & C);  

assign segments[1] = (~B & ~D) |     // segmento B
                    (~B  & ~C) |
                    (~A & ~C & ~D) |
                    (A & ~C & D) |
                    (~A & C & D); 

assign segments[2] = (~B & ~C) |     // segmento C
                    (~C & D) |
                    (~A & B) |
                    (A & ~B) |
                    (~B & D);        

assign segments[3] = (~B & ~C & ~D) |     // segmento D
                    (A & B & ~D) |
                    (B & ~C & D) |
                    (~B & C & D) |
                    (~A & C & ~D);

assign segments[4] = (~B & ~D) |          // segmento E
                    (A & B) |
                    (A & C) |
                    (C & ~D);

assign segments[5] = (~C & ~D) |         // segmento F
                    (~A & B & ~C) |
                    (A & ~B ) |
                    (B & ~D) |
                    (A & C); 

assign segments[6] = (~B & C) |         // segmento G
                    (C & ~D) |
                    (A & ~B) |
                    (A & D)|
                    (~A & B & ~C);       

                  
    
    // Siempre habilitado para un solo display
    assign an_o = 1'b1;

endmodule