module mult4(input [3:0]a, [3:0]b, output [7:0]y);
  wire [7:0]u0, [7:0]u1, [7:0]u2, [7:0]u3;

  assign #1 u0[3:0] = b[0] ? a[3:0] : 4`b0;
  assign #1 u1[4:1] = b[1] ? a[3:0] : 4`b0;
  assign #1 u2[5:2] = b[2] ? a[3:0] : 4`b0;
  assign #1 u3[6:3] = b[3] ? a[3:0] : 4`b0;

  wire o1, o2;

  wire overflow, zero; //sinks

  prefixadder8 adder0 (u0, u1, 0, o1, overflow, zero);
  prefixadder8 adder1 (o1, u2, 0, o2, overflow, zero);
  prefixadder8 adder2 (o2, u3, 0, y, overflow, zero);
endmodule;
