module shiftleft2(input [15:0]a, output [15:0]y);
  assign #1 y = a << 2;
endmodule
