module mux2(input a, b, s, output y);
  assign #1 y = s ? a : b;
endmodule;
