module signextend (input [15:0]offset, output [31:0]extended);
  assign #1 extended = {{16{offset[15]}}, offset};
endmodule
