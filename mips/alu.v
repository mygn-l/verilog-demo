module alu (
  input [31:0] a, b,
  input [3:0] alusel,
  output reg [31:0] y,
  output reg overflow,
  output zero
);
  always @(*) begin
    case (alusel)
      4'b0010: begin
        #1 y = a + b;
        #1 overflow = ({1'b0, a} + {1'b0, b})[32];
      end
      4'b0110: begin
        #1 y = a - b;
        #1 overflow = ({1'b0, a} - {1'b0, b})[32];
      end
      4'b1111: #1 y = 32'b0;
    endcase
  end

  assign #1 zero = (y == 32'b0) ? 1 : 0;
endmodule
