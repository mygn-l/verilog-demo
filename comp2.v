module comp2(input [7:0]a, output [7:0] y);
  wire overflow, zero;
  preadder add1(~a, 8`b1, 0, y, overflow, zero);
endmodule;
