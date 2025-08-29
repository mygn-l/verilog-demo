module presub8(input [7:0]a, [7:0]b, output reg y, reg overflow, reg zero);
  wire comp;
  comp2 xyz(b, comp);
  preadder8 subber(a, comp, 0, y, overflow, zero);
endmodule;
