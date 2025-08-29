module nor(input a, b, output y);
  assign #1 y = ~(a | b);
endmodule;
