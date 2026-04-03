module error_gen (
    input  logic [6:0] hamming_in,
    input  logic [2:0] idx,
    output logic [3:0] i,
    output logic [2:0] c
);

    logic [6:0] result;

    // Flip selected bit
    assign result = hamming_in ^ (7'b1 << idx);

    //Extraccion y entrega segun formato solicitado
    assign i[3] = result[6];
    assign i[2] = result[5];
    assign i[1] = result[4];
    assign i[0] = result[2];

    assign c[2] = result[3];
    assign c[1] = result[1];
    assign c[0] = result[0];

endmodule



