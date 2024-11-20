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
      .b(adder_intf_i.b),
      .carry_out(adder_intf_i.carry_out)
      //.max_val(max_val),
      //.mid_val(mid_val)
  );
  
  localparam logic [ADDER_WIDTH-1:0] max_val = 255;
  localparam logic [ADDER_WIDTH-1:0] mid_val = 128;
  
  bit clk;
  always #1 clk = !clk;
  
    // ********************************************************* COVERGROUP BEGIN ***************************************************************  
covergroup cg_adder @(posedge clk);
    cp_a: coverpoint adder_intf_i.a;
    cp_b: coverpoint adder_intf_i.b;
    co_result: coverpoint adder_intf_i.result;
    crs_ab: cross cp_a, cp_b;
endgroup    
  // Instance
  cg_adder cg_inst = new();
// ********************************************************** COVERGROUP END *************************************************************** 
  
// ********************************************************* DEF PRUEBAS BEGIN ***************************************************************
   //`define TEST1
   //`define TEST2
   `define TEST3
   //`define TEST4
   //`define TEST5
 
  `ifdef TEST1
    // Prueba 1 - 
    //////////////////////////////////////////////
    // 1. Generar una suma de valores máximos   //
    // 2. Generar suma de 255                   //
    // 3. Generar una suma overflow             //
    //////////////////////////////////////////////
    initial begin
      @(posedge clk); 
        adder_intf_i.add_a_b_max();
        $display("a: %0d", adder_intf_i.a);
        $display("b: %0d", adder_intf_i.b); 
        #1 $display("Result: %0d", adder_intf_i.result);    
      @(posedge clk); 
        adder_intf_i.add_a_b_255();
        $display("a: %0d", adder_intf_i.a);
        $display("b: %0d", adder_intf_i.b); 
        #1 $display("Result: %0d", adder_intf_i.result);          
      @(posedge clk); 
        adder_intf_i.add_a_b_overflow();
        $display("a: %0d", adder_intf_i.a);
        $display("b: %0d", adder_intf_i.b); 
        #1 $display("Result: %0d", adder_intf_i.result);          
      @(posedge clk);  
        $finish;
    end 
  `endif
 
  `ifdef TEST2 
    // Prueba 2 - 
    //////////////////////////////////////////////
    // 1. Generar 500 suma a = 0, b es random   //                   
    // 2. Generar 100 sumas con valores random  //
    // 3. Generar 20 suma de 0                  //
    // 4. Generar 50 suma de b = 0, a random    //
    ////////////////////////////////////////////// 
    initial begin
      repeat(50)      // 1. a Zero, b Rndm
        begin
            @(posedge clk);  
              adder_intf_i.add_a_zero_b_random();
            $display("a: %0d", adder_intf_i.a);
            $display("b: %0d", adder_intf_i.b); 
            #1 $display("Result: %0d", adder_intf_i.result);              
        end
      repeat(100)      // 2. randoms
        begin
            cg_inst.sample(); // Añadir al covergroup **************************************
            @(posedge clk);  
              adder_intf_i.add_a_b_random();
            $display("a: %0d", adder_intf_i.a);
            $display("b: %0d", adder_intf_i.b); 
            #1 $display("Result: %0d", adder_intf_i.result);              
        end
      repeat(20)       // 3. Zeros
        begin
            @(posedge clk); 
            $display("a: %0d", adder_intf_i.a);
            $display("b: %0d", adder_intf_i.b); 
            #1 $display("Result: %0d", adder_intf_i.result);     
              adder_intf_i.add_a_b_zero();
        end        
      repeat(50)      // 1. a Zero, b Rndm
        begin
            @(posedge clk);  
            adder_intf_i.add_b_zero_a_random();
            $display("a: %0d", adder_intf_i.a);
            $display("b: %0d", adder_intf_i.b); 
            #1 $display("Result: %0d", adder_intf_i.result);          
        end
      @(posedge clk); 
        $finish;     
    end
  `endif
  
  `ifdef TEST3 
    // Prueba 3 - 
    //////////////////////////////////////////////
    // 2. Generar 100 sumas con valores random  //
    //////////////////////////////////////////////
    initial begin
        repeat(1000) begin
        @(posedge clk); 
            adder_intf_i.add_a_b_random(); 
            $display("a: %0d", adder_intf_i.a);
            $display("b: %0d", adder_intf_i.b); 
            #1 $display("Result: %0d", adder_intf_i.result);            
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
        @(posedge clk);
            adder_intf_i.add_a_b_equal();
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
    @(posedge clk);

    adder_intf_i.add_a_b_neg(); 
    $display("Result: %0d", adder_intf_i.result);
  end     
end
  `endif
// ********************************************************** DEF PRUEBAS END ***************************************************************
// *********************************************************** ASSERTS BEGIN ****************************************************************

 assert property ( @(posedge clk) (adder_intf_i.a == 0 && adder_intf_i.b != 0) |-> adder_intf_i.result == adder_intf_i.b && adder_intf_i.carry_out == 0) 
    else begin 
        $error("Result should be = b & carry_out = 0");
    end   
 assert property ( @(posedge clk) (adder_intf_i.a != 0 && adder_intf_i.b == 0) |-> adder_intf_i.result == adder_intf_i.a && adder_intf_i.carry_out == 0) 
    else begin 
        $error("Result should be = a & carry_out = 0"); 
    end    
 assert property (@(posedge clk) (adder_intf_i.a == 0 && adder_intf_i.b == 0) |-> adder_intf_i.result == 0 && adder_intf_i.carry_out == 0)
        else begin 
        $error("Result & carry_out should be = Zero"); 
    end
 assert property (@(posedge clk) (adder_intf_i.a == max_val && adder_intf_i.b == max_val) |-> (adder_intf_i.result == max_val - 1) && (adder_intf_i.carry_out == 1))
    begin 
        $display("Carry_out passed, adding max_values");
    end        
        else begin 
        $error("Result should be max value & carry_out should be = 1"); 
    end    
 assert property (@(posedge clk) (adder_intf_i.a == max_val && adder_intf_i.b == 0) |-> adder_intf_i.result == max_val && adder_intf_i.carry_out == 0)
        else begin 
        $error("Result should be max value & carry_out should be = 0"); 
    end     
 assert property (@(posedge clk) (adder_intf_i.b == max_val && adder_intf_i.a == 0) |-> (adder_intf_i.result  == max_val && adder_intf_i.carry_out == 0))        
        else begin 
        $error("Result should be max value  & carry_out should be = 0"); 
    end
 assert property ( @(posedge clk) (adder_intf_i.b > mid_val && adder_intf_i.a >= mid_val) |-> (adder_intf_i.carry_out == '1))   
    begin 
        $display("Carry_out passed");
    end
    else begin 
        $error("Carry_out should be active");     
    end
  assert property ( @(posedge clk) (adder_intf_i.b == mid_val && adder_intf_i.a == mid_val) |-> (adder_intf_i.result == 0 && adder_intf_i.carry_out == '1))   
    begin 
        $display("Carry_out passed, adding mid values");
    end
    else begin 
        $error("Carry_out should be active, and result should de Zero, since mid values sum");     
    end
// ************************************************************* ASSERTS END **************************************************************** 
 
endmodule: adder_tb
 // *****************************************************************************************************************************************
 // *********************************************************** INTERFACE BEGIN *************************************************************
 // *****************************************************************************************************************************************
interface adder_intf #(parameter WIDTH = 8) ();
 
  logic [WIDTH-1:0] a;
  logic [WIDTH-1:0] b;
  logic [WIDTH-1:0] result;
  logic carry_out;
  
  // BFM - Bus Functional Model // Conjunto de tasks & functions que permiten generar estimulosvalidos para el DUT
  
  function add_a_zero_b_random();
    a = '0;
    std::randomize(b);
    assert(a == '0);
  endfunction
  function add_b_zero_a_random();
    b = '0;
    std::randomize(a);    
  endfunction
  function add_a_b_random();
    std::randomize(a);
    std::randomize(b); 
    //$display("a: %0d", a);
    //$display("b: %0d", b); 
    //$display("Result: %0d", result);     
  endfunction
  function add_a_b_zero();
    a = '0;
    b = '0;   
  endfunction
  
  function add_a_b_max();
    a = 255;
    b = 255;    
  endfunction
  function add_a_b_255();
    a = 128;
    b = 127;  
  endfunction 
  function add_a_b_overflow();
    a = 128;
    b = 128;     
  endfunction 
 
   function add_a_b_equal();
    std::randomize(a);
    b = a;  
  endfunction 
 
    function add_a_b_neg();
    std::randomize(a);
    b = -a; //complemento a 2
    //assert(a == b);   
  endfunction 
 
endinterface: adder_intf
