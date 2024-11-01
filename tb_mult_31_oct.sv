module tb_multiplicacion;

  parameter N = 5; // Number of changes
  parameter WIDTH = 4;
  
  reg clk;
  reg [WIDTH-1:0] a, b, c;
  wire [WIDTH*3-1:0] mul; 

  // multiplicacion module instance
  multiplicacion #(WIDTH) dut (
    .a(a),
    .b(b),
    .c(c),
    .mul(mul)
  );

  // Clk
  always begin
    #2 clk = ~clk; // Pulse each 2 units
  end

  initial begin
    clk = 0; // Inicialize clk
    $dumpfile("dump.vcd");
    $dumpvars;

    // Change values for a, b, c N times
    repeat(N) begin
      @(posedge clk); // Change when positive edge
      a = $urandom; 
      b = $urandom;
      c = $urandom;
      
      $write("A: %h ", a);
      $write("B: %h ", b);
      $write("C: %h ", c);
      $write("MUL: %h ", mul);
      $write("\n");
    end

    repeat(5) @(posedge clk); // Wait 5 more cycles
    $stop;
  end 

endmodule