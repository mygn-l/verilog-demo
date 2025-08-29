module testbench();
  reg a, b, cin;
  wire y, cout;

  adder testadder (a, b, cin, y, cout);

  initial begin
    a = 0; b = 0; cin = 0; #10;
    if (y === 0 && cout === 0) $display("000 success");
    else $display("000 fail");
  end
endmodule;