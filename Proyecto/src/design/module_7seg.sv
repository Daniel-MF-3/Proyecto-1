module top (
    input logic [3:0] sw,           // A (MSB), B,C,D.. Del 0 al 3 hay 4 bits
    output logic [6:0] segments    
);

    /* Esta seccion de codigo no representa nada funcional, solo se asigna un nombre a 
    cada bit para escribir las ecuaciones boooleanas con mayor facilidad.
    Como renombrar un nodo.     */
assign A = sw[3];
assign B = sw[2];
assign C = sw[1];
assign D = sw[0];
    //

    /*Esta seccion de codigo presenta la logica booleana necesaria para las salidas del sistema, 
    las cuales se deben conectar a un respectivo segmento del display.*/

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

                  
    
endmodule