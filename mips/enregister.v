module enregister (
  input clk, en,
  input [31:0]d,
  output reg [31:0]rd
);
  always @ (posedge clk) if (en) #1 rd <= d;

  initial rd = 32'b0;
endmodule
