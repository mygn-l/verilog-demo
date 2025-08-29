module rotateleft4(input [3:0]a, [1:0]s, output [3:0]y);
  assign #1 y[0] = s[1] ? (s[0] ? a[1] : a[2]) : (s[0] ? a[3] : a[0]);
  assign #1 y[1] = s[1] ? (s[0] ? a[2] : a[3]) : (s[0] ? a[0] : a[1]);
  assign #1 y[2] = s[1] ? (s[0] ? a[3] : a[0]) : (s[0] ? a[1] : a[2]);
  assign #1 y[3] = s[1] ? (s[0] ? a[0] : a[1]) : (s[0] ? a[2] : a[3]);
endmodule;
