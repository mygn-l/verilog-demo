module sub8(input [7:0]a, [7:0]b, output y, overflow, zero);
  wire comp;
  complement8 comp8(b, comp);

  prefixadder8 add(a, comp, 0, y, overflow, zero);
endmodule;
