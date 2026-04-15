# Codificador hamming fase transmisor, encargados: Alessandro Castillo Gutierrez, Jose Daniel Marchena

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Funcionamiento general de circuito y cada modulo
#### Descripcion del circuito
El circuito debera recibir a traves de la interaccion con interrumptores una palabra codificada de forma binaria  de 4 bits a la que debera aplicar un sistema de codificacion hamming (7,4) y a su vez ser enviada a codoficacion para despliegue en un 7 segmentos en formato hexadecimal.
La palabra que resulte de la codificacion en hamming  a una siguiente instancia donde se le invierte uno de los bits, esto en base a otro conjunto de interrumptores que han de señalar la posicion del error a inducir con rangos desde la posicion 0 a la posicion 6.
Una vez introducido este error debera interactuar con los pines de la FPGA colocando señal en alto o bajo segun corresponda  para describir esa señal externamente y que sea recogida y procesada por el equipo posterior


## 3. Explicacion de modulos
### 1. Modulo hamming 
Entradas y salidas
```SystemVerilog
module module_hamming (
    // Definiendo entradas y salidas

    input logic [3:0] Numero_binario,
    output logic [6:0] hamming 
);
```
El modulo recibe la entrada desde los conmutadores del dato principal que se almacenan en numero binario en el siguiente orden
Numero_binario[3]=D4(MSB)
Numero_binario[2]=D3
Numero_binario[1]=D2
Numero_binario[3]=D1
 Y ese numero se procesa para codificacion hamming con XOR y paridades, y este resultado sale a traves de hamming[6:0]
```SystemVerilog
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
```
El modulo ejecuta las operaciones XOR antes mencionadas y las almacena en vector hamming

#### Testbench
```SystemVerilog
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
```

Explicar que hace ese modulo 


#### 1.1 Criterios de

### 2. 7segmentos 
Entradas y salidas
```SystemVerilog
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
```
*Aclarar que se usa un modulo ya hecho*

#### Testbench
```SystemVerilog
`timescale 1ns/1ps

module top_tb;
    /*
    Observe que en esta seccion los logic no se definen como input o output, son propios del modulo
    como si fueran un nodo, por eso se conectan en el DUT. 
    */
    logic [3:0] sw;                         
    logic seg_o[6:0];
    logic [6:0] out;

    // DUT (Device Under Test)
    top dut (
        .sw(numero_binario),
        .segments(seg_o)
    );

    // Función que devuelve patrón esperado. Se utilizara para comparar 'segments' contra 'expected'
    function automatic [6:0] expected (input [3:0] val);
        case (val)
            4'd0: expected = 7'b1111110;
            4'd1: expected = 7'b0110000;
            4'd2: expected = 7'b1101101;
            4'd3: expected = 7'b1111001;
            4'd4: expected = 7'b0110011;
            4'd5: expected = 7'b1011011;
            4'd6: expected = 7'b1011111;
            4'd7: expected = 7'b1110000;
            4'd8: expected = 7'b1111111;
            4'd9: expected = 7'b1110011;
            4'd10: expected = 7'b1110111;
            4'd11: expected = 7'b0011111;
            4'd12: expected = 7'b1001110;
            4'd13: expected = 7'b0111101;
            4'd14: expected = 7'b1001111;
            4'd15: expected = 7'b1000111;
            
            // 10–15 → solo G
            default: expected = 7'b0000001;
        endcase
    endfunction

    initial begin
        $display("Starting exhaustive test...");

        for (int i = 0; i < 16; i++) begin
            sw = i;
            #1;
            out = {seg_o[6],seg_o[5],seg_o[4],seg_o[3],seg_o[2],seg_o[1],seg_o[0]};       

            if (out != expected(i)) begin
                $display("ERROR at %0d -> got %b expected %b",
                         i, out, expected(i));
            end
            else begin
                $display("OK %0d -> %b", i, out);
            end
        end

        $display("Test finished");
        $finish;
    end

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0,top_tb);
    end

endmodule
```

Explicar que hace ese modulo 


### 3. Generacion del error 
Entradas y salidas
```SystemVerilog

module error_gen (
    input  logic [6:0] hamming_in,
    input  logic [2:0] idx, 
    output logic [3:0] i,
    output logic [2:0] c
);
```


```SystemVerilog
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
```
*Explicacion*

#### Testbench
```SystemVerilog
`timescale 1ns/1ps

module error_gen_tb;

    logic [6:0] hamming_in;
    logic [2:0] idx;
    logic [3:0] i;
    logic [2:0] c;

    // DUT
    error_gen dut (.hamming_in(hamming_in),.idx(idx),.i(i),.c(c));

    initial begin
        // Base input (example Hamming word)
        hamming_in = 7'b1110011; 
        // hamming = [D4 D3 D2 P3 D1 P2 P1]
        // data bits (D4..D1): 1,1,1,0
        // parity bits (P3,P2,P1): 0,1,1
        // Case 0: No error (optional convention)
        idx = 3'd0;
        #10;
        $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);

        // Inject error in every possible bit
        for (int k = 1; k <= 7; k++) begin //
            idx = k;
            #10;
            $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);
        end

        $finish;
    end

endmodule
```
*Explicacion*

Para Marchena
*Meter los mapas y simplificacion a pesar de que no se uso*

### 3. Modulo Superior
Entradas y Salidas
```SystemVerilog
module top_hamming ( 

    input  logic [3:0] Numero_binario,
    input  logic [2:0] idx,

    output logic [6:0] seg_o,
    output logic an_o,
    output logic [3:0] i,
    output logic [2:0] c
);
    // Señales internas
    logic [6:0] hamming_out;
    
```
*Explicar*
```SystemVerilog
    
    module_hamming u_hamming (
        .Numero_binario(Numero_binario),
        .hamming(hamming_out)
    );

    error_gen u_error (
    .hamming_in(hamming_out),
    .idx(idx),
    .i(i),
    .c(c)
);
    sevenseg_display_single u_display (
        .numero_binario(Numero_binario),
        .seg_o(seg_o),
        .an_o(an_o)
    );

endmodule
```

*Explicacion*

#### Testbench
```SystemVerilog
`timescale 1ns/1ps

module error_gen_tb;

    logic [6:0] hamming_in;
    logic [2:0] idx;
    logic [3:0] i;
    logic [2:0] c;

    // DUT
    error_gen dut (.hamming_in(hamming_in),.idx(idx),.i(i),.c(c));

    initial begin
        // Base input (example Hamming word)
        hamming_in = 7'b1110011; 
        // hamming = [D4 D3 D2 P3 D1 P2 P1]
        // data bits (D4..D1): 1,1,1,0
        // parity bits (P3,P2,P1): 0,1,1
        // Case 0: No error (optional convention)
        idx = 3'd0;
        #10;
        $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);

        // Inject error in every possible bit
        for (int k = 1; k <= 7; k++) begin //
            idx = k;
            #10;
            $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);
        end

        $finish;
    end

endmodule
```
*Explicacion*








## 4. Consumo de recursos


- **Number of wires:** 180  
- **Number of wire bits:** 274  
- **Number of public wires:** 180  
- **Number of public wire bits:** 274  
- **Number of memories:** 0  
- **Number of memory bits:** 0  
- **Number of processes:** 0  

### Number of cells: 193

| Cell Type   | Count |
|------------|-------|
| ALU        | 4     |
| GND        | 1     |
| IBUF       | 7     |
| LUT1       | 45    |
| LUT2       | 2     |
| LUT3       | 9     |
| LUT4       | 37    |
| MUX2_LUT5  | 42    |
| MUX2_LUT6  | 20    |
| MUX2_LUT7  | 7     |
| MUX2_LUT8  | 3     |
| OBUF       | 15    |
| VCC        | 1     |

## 5. Problemas encontrados durante el proyecto
Manejo de la insercion del error mediante switches porque al ser en posicion y en base 2^n hay que hacer un ajuste por ser por dar un ejemplo 2^0=1 pero la posicion 1 del hamming no es LSB , son 7 bits, pero van del 0 al 6 indexados, entonces eso se ajusta.
Ajustes en el banco de pruebas que se hicieron para evidenciar el cambio de error en consola para confirmar sospechas de mal accionar en el waveform.
Para el top el problema mas relevante es cuidar las señales instanciadas en el parentesis sean las adecuadas pues son donde se declaran señales que interactuan con el entorno      


## Apendices:
### Apendice 1:
texto, imágen, etc
