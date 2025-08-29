module rippleadder4(input [3:0]a, [3:0]b, cin, output [3:0] y, overflow, zero);
  wire cout0, cout1, cout2;

  fulladder pos1 (a[0], b[0], cin, y[0], cout0);
  fulladder pos2 (a[1], b[1], cout0, y[1], cout1);
  fulladder pos3 (a[2], b[2], cout1, y[2], cout2);
  fulladder pos4 (a[3], b[3], cout2, y[3], overflow);

  assign #1 zero = (~y0) & (~y1) & (~y2) & (~y3);
endmodule;
