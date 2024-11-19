`timescale 1ns / 1ps

module adder #(parameter WIDTH = 8)(
    output [(WIDTH - 1): 0] result,
    output carry_out,
    input [(WIDTH - 1): 0] a,
    input [(WIDTH - 1): 0] b
);
 
assign {carry_out, result} = a + b;
 
endmodule
