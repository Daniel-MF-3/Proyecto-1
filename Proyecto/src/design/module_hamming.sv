
module module_hamming (

// Definiendo entradas y salidas

    input logic [3:0] Numero_binario,

    output logic [6:0] hamming 
);

// Denominando que variables se van a utilizar
logic P1, P2, P3;
logic D1, D2, D3, D4;


// Asignando las variables que forman parte del swicht para codificar la palabra.
assign D1 = Numero_binario[0];
assign D2 = Numero_binario[1];
assign D3 = Numero_binario[2];
assign D4 = Numero_binario[3];

// Aplicando la paridad con XOR en la variables 
assign P1 = D1^D2^D4;
assign P2 = D1^D3^D4;
assign P3 = D2^D3^D4;


// Asingnando el hamming en las variables
assign hamming[0]=P1;
assign hamming[1]=P2;
assign hamming[2]=D1;
assign hamming[3]=P3;
assign hamming[4]=D2;
assign hamming[5]=D3;
assign hamming[6]=D4;
 
endmodule