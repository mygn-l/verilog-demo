module register (input clk, [31:0]d, output reg [31:0]rd);
  always @ (posedge clk) #1 rd <= d;
endmodule
