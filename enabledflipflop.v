module enabledflipflop(input clk, d, en, output reg q):
  always @ (posedge clk)
    if (en) q <= d;
endmodule;
