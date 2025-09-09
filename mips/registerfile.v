module registerfile (
  input clk,
  input we,
  input [4:0] a1, a2, a3,
  input [31:0] wd,
  output reg [31:0] rd1, rd2
);
  reg [31:0] registers [31:0];

  always @(*) begin
    #1;
    rd1 = registers[a1];
    rd2 = registers[a2];
  end

  always @(posedge clk) begin
    if (we) begin
      #1;
      registers[a3] <= wd;
    end
  end
endmodule
