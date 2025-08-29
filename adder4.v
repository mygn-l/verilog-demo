module adder4(input [3:0]a, [3:0]b, cin, output reg [3:0] y, reg overflow, reg zero);
  wire y0, cout0;
  wire y1, cout1;
  wire y2, cout2;
  wire y3, cout3;

  adder pos1 (a[0], b[0], cin, y0, cout0);
  adder pos2 (a[1], b[1], cout0, y1, cout1);
  adder pos3 (a[2], b[2], cout1, y2, cout2);
  adder pos4 (a[3], b[3], cout2, y3, cout3);

  assign #1 y[0] = y0;
  assign #1 y[1] = y1;
  assign #1 y[2] = y2;
  assign #1 y[3] = y3;

  assign #1 zero = (~y0) & (~y1) & (~y2) & (~y3);

  assign #1 overflow = cout3;
endmodule;
