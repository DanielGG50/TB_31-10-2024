module multiplicacion #(parameter WIDTH = 4)(
  output wire [WIDTH*3-1:0] mul,
  input wire [WIDTH-1:0] a, b, c
);
  assign mul = a * b * c;
  
endmodule