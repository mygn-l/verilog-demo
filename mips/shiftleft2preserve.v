module shiftleft2(input [25:0]a, output [27:0]y);
  assign #1 y = a << 2;
endmodule
