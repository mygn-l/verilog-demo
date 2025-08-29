module complement8(input [7:0]a, output [7:0] y);
  wire overflow, zero; //sinks
  prefixadder8 add(~a, 8`b1, 0, y, overflow, zero);
endmodule;
