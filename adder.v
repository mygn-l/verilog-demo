module adder(input a, b, cin, output y, cout);
  assign #1 y = a ^ b ^ cin;
  assign #1 cout = (a & (b | cin)) | (b & cin);
endmodule
