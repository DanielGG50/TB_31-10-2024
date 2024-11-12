`timescale 1ns / 1ps

module adder_tb;
 
  parameter ADDER_WIDTH = 8;
 
/*
  logic [(WIDTH - 1): 0] result;
  bit [(WIDTH - 1): 0] a;
  bit [(WIDTH - 1): 0] b;
*/
  adder_intf #(ADDER_WIDTH) adder_intf_i(); // Creamos la instancia de la interface
 
  adder #(ADDER_WIDTH /* Pre-synthesis */) DUT (
      .result(adder_intf_i.result), // conectamos el puerto result del DUT con la variable result de la instancia de la interface
      .a(adder_intf_i.a),
      .b(adder_intf_i.b)
  );
   //`define TEST1
   //`define TEST2
   //`define TEST3
   //`define TEST4
   `define TEST5
 
  `ifdef TEST1
    // Prueba 1 - 
    //////////////////////////////////////////////
    // 1. Generar una suma de valores máximos   //
    // 2. Generar suma de 255                   //
    // 3. Generar una suma overflow             //
    //////////////////////////////////////////////
    initial begin
      adder_intf_i.add_a_b_max();
      #1;
      $display("Result: %0d", adder_intf_i.result);
      adder_intf_i.add_a_b_255();
      #1;
      $display("Result: %0d", adder_intf_i.result);
      adder_intf_i.add_a_b_overflow();
      $display("Result: %0d", adder_intf_i.result);
      #1;
      $finish;
    end
  `endif
 
  `ifdef TEST2 
    // Prueba 2 - 
    //////////////////////////////////////////////
    // 1. Generar suma                  //
    // 2. Generar 10 sumas con valores random //
    // 3. Generar una suma de 0                 //
    //////////////////////////////////////////////
    initial begin
      adder_intf_i.add_b_zero_a_random();    
      #1;
      $display("Result: %0d", adder_intf_i.result);
      repeat(10) begin
      adder_intf_i.add_a_b_random();   
      #1;
      $display("Result: %0d", adder_intf_i.result);
      end
      adder_intf_i.add_a_b_zero();
      #1;
      $display("Result: %0d", adder_intf_i.result);
      adder_intf_i.add_a_zero_b_random();
      #1;
      $display("Result: %0d", adder_intf_i.result);
      $finish;      
    end
  `endif
  
    `ifdef TEST3 
    // Prueba 3 - 
    //////////////////////////////////////////////
    // 2. Generar 100 sumas con valores random  //
    //////////////////////////////////////////////
    initial begin
      repeat(100) begin
      adder_intf_i.add_a_b_random();   
      #1;
      $display("Result: %0d", adder_intf_i.result);
      end     
    end
  `endif

  initial begin 
    $dumpfile("filel.vcd");
    $dumpvars;
  end  
 
     `ifdef TEST4 
    // Prueba 4 - 
    //////////////////////////////////////////////
    // 2. Generar 10 sumas con valores iguales  //
    //////////////////////////////////////////////
    initial begin
      repeat(10) begin
      adder_intf_i.add_a_b_equal();   
      #1;
      $display("Result: %0d", adder_intf_i.result);
      end     
    end
  `endif

     `ifdef TEST5 
    // Prueba 5 - 
    //////////////////////////////////////////////
    // 2. Generar 10 sumas con valores negados  //
    //////////////////////////////////////////////
    initial begin
      repeat(10) begin
      adder_intf_i.add_a_b_neg();   
      #1;
      $display("Result: %0d", adder_intf_i.result);
      end     
    end
  `endif


  initial begin 
    $dumpfile("filel.vcd");
    $dumpvars;
  end  
  
endmodule: adder_tb
  
interface adder_intf #(parameter WIDTH = 8) ();
 
  logic [WIDTH-1:0] a;
  logic [WIDTH-1:0] b;
  logic [WIDTH-1:0] result;
  // BFM - Bus Functional Model // Conjunto de tasks & functions que permiten generar estimulosvalidos para el DUT
  function add_a_zero_b_random();
    a = '0;
    std::randomize(b);
    $display("a: %0d", a);
    $display("b: %0d", b);
    //$display("Result: %0d", result);
  endfunction
  function add_b_zero_a_random();
    b = '0;
    std::randomize(a); 
    $display("a: %0d", a);
    $display("b: %0d", b);  
    //$display("Result: %0d", result);    
  endfunction
  function add_a_b_random();
    std::randomize(a);
    std::randomize(b);  
    $display("a: %0d", a);
    $display("b: %0d", b);  
    //$display("Result: %0d", result);     
  endfunction
  function add_a_b_zero();
    a = '0;
    b = '0;  
    $display("a: %0d", a);
    $display("b: %0d", b); 
    //$display("Result: %0d", result);   
  endfunction
  
  function add_a_b_max();
    a = 255;
    b = 255;  
    $display("a: %0d", a);
    $display("b: %0d", b); 
    //$display("Result: %0d", result);   
  endfunction
  function add_a_b_255();
    a = 128;
    b = 127;  
    $display("a: %0d", a);
    $display("b: %0d", b); 
    //$display("Result: %0d", result);   
  endfunction 
  function add_a_b_overflow();
    a = 128;
    b = 128;  
    $display("a: %0d", a);
    $display("b: %0d", b); 
    //$display("Result: %0d", result);   
  endfunction 
 
   function add_a_b_equal();
    std::randomize(a);
    b = a; 
    $display("a: %0d", a);
    $display("b: %0d", b); 
    //$display("Result: %0d", result);   
  endfunction 
 
    function add_a_b_neg();
    std::randomize(a);
    b = -a; //complemento a 2
    $display("a: %0d", a);
    $display("b: %0d", b); 
    //$display("Result: %0d", result);   
  endfunction 
 
endinterface: adder_intf