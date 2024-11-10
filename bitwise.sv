`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2024 20:25:57
// Design Name: 
// Module Name: bitwise
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module bitwise#(parameter WIDTH = 4)(
  input [WIDTH-1:0] a, b,
  output [WIDTH-1:0] bitwise_and,
  output [WIDTH-1:0] bitwise_or,
  output [WIDTH-1:0] bitwise_xor
);
    assign  bitwise_and= a & b;
    assign  bitwise_or = a | b;
    assign  bitwise_xor = a ^ b; 
endmodule