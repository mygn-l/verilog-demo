module ram16x4(input [1:0]adr, output reg [1:0]dout);
  //example outputs
  always @ (adr)
    case (adr)
      2`b00: dout <= 2`b11;
      2`b01: dout <= 2`b00;
      2`b10: dout <= 2`b10;
      2`b11: dout <= 2`b01;
    endcase
endmodule;
