module error_gen (
    input  logic [6:0] hamming_in,
    input  logic [2:0] idx, /*Idx hay que cambiarlo por el sw o como sea que se llame las entradas que indican donde poner el erorr idx=0 no error, idx=1 error en bit 0, idx=2 error en bit 1, ..., idx=6 error en bit 6 */
    output logic [3:0] i,
    output logic [2:0] c
);

    logic [6:0] resultado_con_error;

    // Flip selected bit
    assign resultado_con_error = (idx == 3'd0) ? 
                             hamming_in :
                             (hamming_in ^ (7'b1 << (idx - 1)));

    //Extraccion y entrega segun formato solicitado
    assign i[3] = resultado_con_error[6];
    assign i[2] = resultado_con_error[5];
    assign i[1] = resultado_con_error[4];
    assign i[0] = resultado_con_error[2];

    assign c[2] = resultado_con_error[3];
    assign c[1] = resultado_con_error[1];
    assign c[0] = resultado_con_error[0];

endmodule

/*? es un if else compacto: con la forma: condition ? value_if_true : value_if_false; lo que hace es verificar 
la condición (en este caso, si idx es igual a 0) y si es verdadera, asigna hamming_in a 
resultado_con_error. Si la condición es falsa (es decir, si idx no es 0), entonces se realiza una operación XOR entre hamming_in 
y un valor que tiene un solo bit encendido en la posición correspondiente a idx-1. Esto efectivamente "flips" el 
bit en esa posición, introduciendo un error en el código Hamming.

if (idx == 0)
    resultado_con_error = hamming_in;
else
    resultado_con_error = hamming_in with one bit flipped at position (idx - 1);
*/

