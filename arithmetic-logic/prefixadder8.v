module prefixadder8(input [7:0]a, [7:0]b, cin, output [7:0] y, overflow, zero);
  wire g00, g11, g22, g33, g44, g55, g66, g77, g99;
  wire p00, p11, p22, p33, p44, p55, p66, p77;
  wire g90, g12, g34, g56;
  wire p90, p12, p34, p56;
  wire g92, g36;
  wire p92, p36;
  wire g96;
  wire p96;
  //G[i -> j]: columns i -> j generate a carry for column j+1
  //P[i -> j]: propagates any carry from column i -> j+1

  assign #1 g99 = cin;
  assign #1 g00 = a[0] & b[0];
  assign #1 g11 = a[1] & b[1];
  assign #1 g22 = a[2] & b[2];
  assign #1 g33 = a[3] & b[3];
  assign #1 g44 = a[4] & b[4];
  assign #1 g55 = a[5] & b[5];
  assign #1 g66 = a[6] & b[6];
  assign #1 g77 = a[7] & b[7];

  assign #1 p00 = a[0] | b[0];
  assign #1 p11 = a[1] | b[1];
  assign #1 p22 = a[2] | b[2];
  assign #1 p33 = a[3] | b[3];
  assign #1 p44 = a[4] | b[4];
  assign #1 p55 = a[5] | b[5];
  assign #1 p66 = a[6] | b[6];
  assign #1 p77 = a[7] | b[7];

  assign #1 g90 = g00 | (cin & p00);
  assign #1 g12 = g22 | (g11 & p22);
  assign #1 g34 = g44 | (g33 & p44);
  assign #1 g56 = g66 | (g55 & p66);

  assign #1 p90 = p00;
  assign #1 p12 = p11 & p22;
  assign #1 p34 = p33 & p44;
  assign #1 p56 = p55 & p66;

  assign #1 g92 = g12 | (g90 & p12);
  assign #1 g36 = g56 | (g34 & p56);

  assign #1 p92 = p90 & p12;
  assign #1 p36 = p34 & p56;

  assign #1 g96 = g36 | (g92 & p36);

  assign #1 p96 = p92 & p36;

  assign #1 g94 = g44 | (g92 & p34);
  assign #1 g91 = g11 | (g90 & p11);
  assign #1 g93 = g33 | (g92 & p33);
  assign #1 g95 = g55 | (g94 & p55);

  assign #1 y[0] = cin ^ a[0] ^ b[0];
  assign #1 y[1] = g90 ^ a[1] ^ b[1];
  assign #1 y[2] = g91 ^ a[2] ^ b[2];
  assign #1 y[3] = g92 ^ a[3] ^ b[3];
  assign #1 y[4] = g93 ^ a[4] ^ b[4];
  assign #1 y[5] = g94 ^ a[5] ^ b[5];
  assign #1 y[6] = g95 ^ a[6] ^ b[6];
  assign #1 y[7] = g96 ^ a[7] ^ b[7];

  assign #1 overflow = g77 | (g96 & p77);

  assign #1 zero = (~y0) & (~y1) & (~y2) & (~y3) & (~y4) & (~y5) & (~y6) & (~y7);
endmodule;
