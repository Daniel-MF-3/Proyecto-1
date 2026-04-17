# Codificador hamming fase transmisor, encargados: Alessandro Castillo Gutierrez, Jose Daniel Marchena

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

[1] J. M. Rabaey, A. Chandrakasan and B. Nikolić, Digital Integrated Circuits: A Design Perspective, 2nd ed. Upper Saddle River, NJ, USA: Prentice Hall, 2003.

[2] Texas Instruments, “SN74LS04 Hex Inverters Datasheet”, 2016.

[3] J. M. Rabaey, A. Chandrakasan and B. Nikolić, Digital Integrated Circuits: A Design Perspective, 2nd ed. Upper Saddle River, NJ, USA: Prentice Hall, 2003.

[4] N. H. E. Weste and D. Harris, CMOS VLSI Design: A Circuits and Systems Perspective, 4th ed. Boston, MA, USA: Pearson, 2011.

[5] P. Horowitz and W. Hill, The Art of Electronics, 3rd ed. Cambridge, U.K.: Cambridge University Press, 2015.

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
Numero_binario[0]=D1
y ese numero se procesa para codificacion hamming con XOR y paridades psra finalmmente este resultado salir a traves de hamming[6:0]
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
El testbench que responde al diseño del modulo hamming lo que corresponde es generar vectores equivalentes a los que existen el diseño y reciben estimulos, en el caso del testbench son estimulos internos a traves de llamar la funcion module_hamming bajo device under test o DUT para entregarle esos estimulos virtuales y un for que tome esos estimulos de 0 hasta 16 resporte los resultados de manera visual en consola a traves de $diplay

### 2. 7segmentos 
Entradas y salidas
```SystemVerilog
module sevenseg_display_single (
    input  logic [3:0] numero_binario,  // número 0-15 a mostrar
    output logic [6:0] seg_o,           // segmentos a-g
    output logic an_o                    // control de transistor / pin FPGA
);

    wire A, B, C, D;
```
En el caso del modulo de 7segmentos se recibe el numero binario del estimulos externos que se almacenan en su vector correspondiente [3:0] numero binario.
Estos se codifican para responder a patrones que les seran utilizados para encender un led de 7 segmentos y salen al exterior a traves de seg_o colocado en pines del FPGA
En el caso del An_o es una variable requesito como consecuencia de las capacidades de la FPGA a la hora de entregar corriente.
El objetivo de la misma es enviar la señal en alto 3.3v que polaricen el NPN (2N3906) para permitir el paso de corriente de forma estable. El a_o estimula la base, el emisor se conecta a tierra, dado que el NPN es excelente para para atraer a GND y el colector estimula el 7 segemtnos anodo comun que como su nombre indica enciende con 0 en la patilla comun y cada segmento por tanto se activa con una señal en alto o de 1.

```SystemVerilog

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

*En esta parte del diseño no se profundiza ya que fue un diseño tomado del tutorial previo dentro de la carpeta open_source_fpga_environment

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
El testbench de igual forma fue tomado del tutorial, en concreto de la carpeta open_source_fpga_environment

## 2.1 Ecuación y mapa K para el uso en 7 segmentos 

Aquí hay un ejemplo uno de los mapas de Karnaugh que se hicieron para las ecuaciones del 7 segmentos del segmento e:

<img width="467" height="386" alt="Captura de pantalla 2026-04-17 115044" src="https://github.com/user-attachments/assets/d29f3b1e-3eaa-4ee8-8aee-3350bd5ba307" />

Su ecuación: $e = B'D' + CD' + AC + AB$

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
Este modulo recibe la palabra hamming previamente creada por modulos anteriores bajo el vector [6:0] hamming_in, asi tambien recibe [2:0] idx que es un vector con el proposito de almacenar entradas externas al fpga a traves de interrumptores y que segun sean alto o bajo revelen un numero base binaria que se usara para invertir un bit en( introducir un error). 

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
Resultado con error es un vector intermedio con el papel de tomar las salidas que resulten de de aplicar un condicional  de esta forma:
```
if (idx == 0) //
    resultado_con_error = hamming_in;
else
    resultado_con_error = hamming se entrega con un bit al reves en la posicion (idx - 1);
```
Esto quiere deicr que si Idx es 000 el numero hamming que ha entrado se pasa a asignar a los vectores [2:0]c y [3:0]i sin cambios, por el contrario si idx es distinto se corrige la posicion que indique el numero binario de idx-1, esto porque con 3 bits se puede representar numeros del 0 al 7 pero las posiciones fisican existen de la 0 a la 6
[3:0] I almacena los datos inegrados a los que en el todo el transcurso de les ha mantenido ratro, [2:0]c almacena los bits de paridad.
En ambos casos son salidas, salidas que como se vera en el modulo top son declaradas en donde corresponden para que interactuen con el exterior, es decir sean entregadas a los pines de la FPGA.

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
        // Hamming estimulo
        hamming_in = 7'b1110011; 
        // hamming = [D4 D3 D2 P3 D1 P2 P1]
        // datos (D4..D1): 1,1,1,0
        // bits de paridad  (P3,P2,P1): 0,1,1
        // Case 0: No  hay error
        idx = 3'd0;
        #10;
        $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);

        // Estimular el error para cualquiera de las 6 posiciones 
        for (int k = 1; k <= 7; k++) begin //
            idx = k;
            #10;
            $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);
        end

        $finish;
    end

endmodule
```
El testbench del estimulo de error, al igual que el modulo hamming realiza un estimulo para cada posible posicion de error y despliega [3:0]i asi como [2:0]c en pantalla para poder como usuario percibir que el error segun la configuracion posicional previamente conocida de hamming saber que el error se almacena en el vector de salida adecuado  

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
Este modulo superior su papel es establecer la señales que interactuan con el exterior al declararlas en sus parametros, sean estas de salida o de entrada. y declarar la señal interna de hamming como medio transmisor de un modulo a otro


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

El desarrolo del modulo no es mas que declaraciones llamado de funciones a traves de la declaracion explicita de puertos por comodidad y prevencion de errores 

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
        // Case 0: No error 
        idx = 3'd0;
        #10;
        $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);

        // Estimular el error para cualquiera de las 6 posiciones 
        for (int k = 1; k <= 7; k++) begin //
            idx = k;
            #10;
            $display("idx=%0d | in=%b | i=%b c=%b", idx, hamming_in, i, c);
        end

        $finish;
    end

endmodule
```
El caso testbench del modulo top se podria decir que es una replica del generador de error pero con la diferencia de que sirve para comprobar que las instancias son correctas 



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
Para el top el problema mas relevante es cuidar las señales instanciadas en el parentesis sean las adecuadas pues son donde se declaran señales que interactuan con el entorno.

Con repecto al anillo, se tuvo las dificulates de obtener los resultados en el osciloscopio al tener ondas con cucho ruidos y valores no cercanos. La solución fue utilizar un logic analyzer para obtener mejores resultados y ondas con menos distorciones.

## 6. Oscilador de anillo

Un oscilador de anillo es un circuito que está compuesto por un número impar de inversores conectados en cascada que forman un lazo cerrado, por lo que cada salida del último inversor se retroalimenta a la entrada del primero [1]. Debido que el retardo de propagación finito de cada inversor, la señal no puede estabilizarse en un estado lógico fijo, lo que provoca una oscilación continua entre niveles alto y bajo [1].

En apartado se experimentara varios casos con 5 inversores, 3 inversores, 3 inversores con cable aproximadamente un 1 metro y 1 inversor. Primero se calcularán los valores teóricos para luego compararlo con los valores obtenidos en osciloscopio en laboratorio. En la siguiente imagen, se vera como se debe construir un oscilador de anillo:

<p align="center">
<img width="515" height="107" alt="image" src="https://github.com/user-attachments/assets/eb3dcf77-0a43-4b77-a648-a8087c9102f7" />
</p>
<p align="center">
Oscilador de anillo basado en 74LS04.
</p>


## Valores teoricos.

Se demostrarán los calculos del período y frecuencia. Según la hoja de datos, un el inversor **74LS04** tiene como $t_d \approx 10\mathrm{ns}$ [2]. Con este dato se puede aplicar la siguiente formula:

$$
T= 2\times n \times t_d 
$$

Donde:

$T$ = Período
$n$ = número de inversores 
$t_d$ = tiempo de retardo de un inversor
<

Al obtener el período se puede obtener la frecuencia : 

$$
f = \frac{1}{T}
$$ 

### Caso de 5 inversores

El período: 

$$
T= 2\times 5 \times 10\mathrm{ns}
$$

$$
T= 100\mathrm{ns}
$$ 

Frecuencia:

$$
f = \frac{1}{100\mathrm{ns}}
$$
$$
f = 10\mathrm{MHz}
$$

### Caso de 3 inversores

El período: 

$$
T= 2\times 3 \times 10\mathrm{ns}
$$
$$
T= 60\mathrm{ns}
$$


Frecuencia:

$$
f = \frac{1}{60\mathrm{ns}}
$$
$$
f = 16.7\mathrm{MHz}
$$

El caso de 1 metro de cable no cambia a ser estos valores ideales, por lo que sería lo mismo que el caso de 3 inversores.

### Caso de 1 inversor

El período: 

$$
T= 2\times 1 \times 10\mathrm{ns}
$$
$$
T= 20\mathrm{ns}
$$


Frecuencia:

$$
f = \frac{1}{20\mathrm{ns}}
$$
$$
f = 50\mathrm{MHz}
$$


## Experimentos

Está parte se mostraran las imagenes de las ondas y datos que se obtuvieron del osciloscopio en cada caso y comparalos con los valores teoricos.

### Caso de 5 inversores

Primero se mostrára la imagen del circuito en una protoboard y luego la onda que se consiguio en el osciloscopio:
<p align="center">
<img width="1599" height="899" alt="image" src="https://github.com/user-attachments/assets/06817f65-9fa0-49f1-a435-d3d8ae090568" />
</p>
<p align="center">
Fig. 2. Ensamblaje del oscilador de anillo de 5 inversores.
</p>



<p align="center">
<img width="800" height="503" alt="image" src="https://github.com/user-attachments/assets/945ee588-f068-416f-a128-beb131284762" />
</p>
<p align="center">
Fig. 3. Onda obtenida del osciloscopio del oscilador de anillo de 5 inversores.
</p>

Como se puede observar la onda es lo esperado y los datos como la frecuencia de $10.7\mathrm{MHz}$ y el período de $94\mathrm{ns}$ son similares a los teóricos. Una de la razones de porque los valores teóricos y los experimentales no son iguales se debe a las varaciones en las codiciones de carga, capacitancias parásitas y efectos de interconexión, lo cual puede afectar el tiempo de propagación efectivo [3]. Al final se queda con tiempo de retraso de $9.4\mathrm{ns}$

### Caso de 3 inversores
Primero se mostrára la imagen del circuito en una protoboard y luego la onda que se consiguio en el osciloscopio:

<p align="center">
<img width="1599" height="899" alt="image" src="https://github.com/user-attachments/assets/efeed98c-3ce8-46bb-8995-d4fa2ad2a9c2" />
</p>
<p align="center">
Fig. 4. Ensamblaje del oscilador de anillo de 3 inversores.
</p>


<p align="center">
<img width="800" height="503" alt="in3m" src="https://github.com/user-attachments/assets/09e18a67-7c96-4fc0-a18a-bf20551121fa" />
</p>
<p align="center">
Fig. 5. Onda obtenida del osciloscopio del oscilador de anillo de 3 inversores.
</p>

La onda se mantiene cuadrada, y los valores teóricos se acercan a lo esparado. La razón porque no son exactos, pasa lo mismo que el caso anterior. Sin embargo, se debe tomar en cuenta que al reducir el número de inversores, el período de oscilación baja proporcionalmente, ya que depende del número de inversores en uso y también aumenta la frecuencia [3]. Al final se queda con tiempo de retraso de $9.3\mathrm{ns}$

### Caso de 3 inversores con cable de un metro

Primero se mostrára la imagen del circuito en una protoboard y luego la onda que se consiguio en el osciloscopio:

<p align="center">
<img width="1599" height="741" alt="image" src="https://github.com/user-attachments/assets/d944e342-f436-4312-9dbd-0b61c478e580" />
<p align="center">
Fig. 6. Ensamblaje del oscilador de anillo de 3 inversores con un cable un metro.
</p>


<p align="center">
<img width="800" height="503" alt="in3ma" src="https://github.com/user-attachments/assets/372317cf-fbd1-48be-ab70-ae83ef59d950" />
</p>
<p align="center">
Fig. 7. Onda obtenida del osciloscopio del oscilador de anillo de 3 inversores con cable un metro.
</p>

Curiosamente con el cable de un metro da mejores resultados que uno normal, sin embargo es no quiere decir que con cable se soluciona los errores del caso anterior. Se debe que el cable proporciona un retardo adicional que reduce la frecuencia de oscilación y también afecta la estabilidad [4].

### Caso de 1 inversor

Primero se mostrára la imagen del circuito en una protoboard y luego la onda que se consiguio en el osciloscopio:

<p align="center">
<img width="1599" height="899" alt="image" src="https://github.com/user-attachments/assets/04d68d36-890f-4f1c-952c-c5847670702d" />
Fig. 8. Ensamblaje del oscilador de anillo de 3 inversores con un cable un metro.
</p>


<p align="center">
<img width="800" height="503" alt="image" src="https://github.com/user-attachments/assets/f1e2bad2-f828-443f-9272-d83b7a63ac71" />

<p align="center">
Fig. 9. Onda obtenida del osciloscopio del oscilador de anillo de 3 inversores con cable un metro.
</p>

Resultados simalares a los teóricos y una onda cuadrada. Sin embargo un oscilador de anillo requiere un número impar mayor que uno de inversores para oscilar. Con un solo inversor, el sistema debería estabilizarse en un estado lógico fijo [3]. Estas oscilaciones no son estables ni confiables y suelen presentar frecuencias elevadas, como la observada experimentalmente [5].




## Apendices:
### Apendice 1:
texto, imágen, etc
