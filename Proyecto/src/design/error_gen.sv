module error_gen (output logic i, c, input sw_error,);
    sw_error [3:0];
    logic [6:0] hamming_code;
    logic [3:0] sw_error;
    logic [2:0] = c;
    logic [3:0] = i;

    logic [6:0] result;

    assign result = data ^ (7'b1 << idx);
    i[3] = result[3];
    i[2] = result[2];
    i[1] = result[1];
    i[0] = result[0];
    c[2] = result[3];
    c[1] = result[6];
    c[0] = result[7];
endmodule



