module carrylookaheadadder4(input [3:0]a, [3:0]b, cin, output [3:0] y, overflow, zero);
  wire cout0, cout1, cout2, cout3;

  fulladder pos1 (a[0], b[0], cin, y[0], cout0);
  fulladder pos2 (a[1], b[1], cout0, y[1], cout1);
  fulladder pos3 (a[2], b[2], cout1, y[2], cout2);
  fulladder pos4 (a[3], b[3], cout2, y[3], cout3);

  wire p0, g0, c0, p1, g1, c1, p2, g2, c2, p3, g3;

  assign #1 g0 = a[0] & b[0];
  assign #1 g1 = a[1] & b[1];
  assign #1 g2 = a[2] & b[2];
  assign #1 g3 = a[3] & b[3];

  assign #1 p0 = a[0] | b[0];
  assign #1 p1 = a[1] | b[1];
  assign #1 p2 = a[2] | b[2];
  assign #1 p3 = a[3] | b[3];

  assign #1 overflow = g3 | (p3 & c2);
  assign #1 c2 = g2 | (p2 & c1);
  assign #1 c1 = g1 | (p1 & c0);
  assign #1 c0 = g0 | (p0 & cin);

  assign #1 zero = (~y0) & (~y1) & (~y2) & (~y3);
endmodule;
