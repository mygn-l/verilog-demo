module memory (
  input clk, we,
  input [31:0]addr, wd,
  output [31:0]rd
);
  reg [7:0] mem [4294967296:0]; //2^32 bytes of memory

  initial mem[256] = 0'b00000000; // 20
  initial mem[257] = 0'b00000000;
  initial mem[258] = 0'b00000000;
  initial mem[259] = 0'b00010100;

  initial mem[260] = 0'b00000000; // 27
  initial mem[261] = 0'b00000000;
  initial mem[262] = 0'b00000000;
  initial mem[263] = 0'b00011011;

  initial mem[264] = 0'b00000000; // 61
  initial mem[265] = 0'b00000000;
  initial mem[266] = 0'b00000000;
  initial mem[267] = 0'b00111101;

  initial mem[0] = 0'b10001100; // lw $s0, 256($0)
  initial mem[1] = 0'b00010000;
  initial mem[2] = 0'b00000001;
  initial mem[3] = 0'b00000000;

  initial mem[4] = 0'b10001100; // lw $s1, 260($0)
  initial mem[5] = 0'b00010001;
  initial mem[6] = 0'b00000001;
  initial mem[7] = 0'b00000100;

  initial mem[8] = 0'b00000010; // add $t0, $s0, $s1
  initial mem[9] = 0'b00010001;
  initial mem[10] = 0'b01000000;
  initial mem[11] = 0'b00100000;

  initial mem[8] = 0'b10101100; // sw $t0, 268($0)
  initial mem[9] = 0'b00001000;
  initial mem[10] = 0'b00000001;
  initial mem[11] = 0'b00001100;

  assign #1 rd = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

  always @ (posedge clk) begin
    if (we) begin
      #1;
      mem[addr] = wd[7:0];
      mem[addr+1] = wd[15:8];
      mem[addr+2] = wd[23:16];
      mem[addr+3] = wd[31:24];
    end

    $display({mem[268], mem[269], mem[270], mem[271]});
  end
endmodule;
