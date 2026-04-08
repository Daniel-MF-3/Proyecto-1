module error_gen (
    input  logic [6:0] hamming_in,
    input  logic [2:0] idx, /*Idx hay que cambiarlo por el sw o como sea que se llame las entradas que indican donde poner el erorr idx=0 no error, idx=1 error en bit 0, idx=2 error en bit 1, ..., idx=6 error en bit 6 */
    output logic [3:0] i,
    output logic [2:0] c
);

    logic [6:0] resultado_con_error;

    // Flip selected bit
    assign resultado_con_error = (idx == 0) ? 
                             hamming_in :
                             (hamming_in ^ (7'b1 << (idx-1)));

    //Extraccion y entrega segun formato solicitado
    assign i[3] = resultado_con_error[6];
    assign i[2] = resultado_con_error[5];
    assign i[1] = resultado_con_error[4];
    assign i[0] = resultado_con_error[2];

    assign c[2] = resultado_con_error[3];
    assign c[1] = resultado_con_error[1];
    assign c[0] = resultado_con_error[0];

endmodule



