module ram16x4(input clk, en, [3:0]adr, [3:0]din, output [3:0]dout);
  reg [3:0] mem [15:0]; //reg [3:0] mem is a single 4-bit word, adding [15:0] tells verilog to have many of these (here, 16).

  always @ (posedge clk)
    if (en) mem[adr] <= din;

  assign #1 dout = mem[adr];
endmodule;
