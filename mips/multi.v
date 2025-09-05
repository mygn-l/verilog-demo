module memory (input clk, we, [31:0]addr, [31:0]wd, output reg [31:0]rd);
  reg [31:0] mem [4294967296:0]; //2^32

  //stored program
  initial begin
    mem[0] = 32`b100011 00000 10000 0000000000001000;   //lw $s0, 1000($0)       opcode=100011
    mem[1] = 32`b100011 00000 10001 0000000000001001;   //lw $s1, 1001($0)       opcode=100011
    mem[2] = 32`b000000 10000 10001 10002 00000 100000; //add $s0, $s1, $s2      opcode=000000 funct=100000 shamt=00000
    mem[3] = 32`b000100 10000 10002 0000000000000002;   //beq $s0, $s2, 3        opcode=000100
    mem[4] = 32`b000000 10000 10001 10002 00000 100110; //xor $s0, $s1, $s2      opcode=000000 funct=100110 shamt=00000
    mem[5] = 32`b101011 00000 10002 0000000000001002;   //sw $s2, 1002($0)       opcode=101011
  end

  always @ (posedge clk) begin
    if (we) mem[addr] <= wd;
    else rd <= mem[addr];
  end
endmodule;

module alu (input [31:0]a, [31:0]b, [3:0]alusel, output [31:0] y, overflow, zero);
  always begin
    case (alusel)
      4`b0000: #1 y = a + b;
      4`b0001: #1 y = a - b;
      4`b0100: #1 y = a << b;
      4`b0101: #1 y = a >> b;
      4`b1000: #1 y = a & b;
      4`b1001: #1 y = a | b;
      4`b1010: #1 y = a ^ b;
      4`b1011: #1 y = ~(a | b);
      4`b1100: #1 y = ~(a & b);
      4`b1101: #1 y = ~(a ^ b);
      4`b1110: #1 y = (a > b) ? 8`b1 : 8`b0;
      4`b1111: #1 y = (a == b) ? 8`b1 : 8`b0;
    endcase
  end

  assign wire extended_addition = {1`b0, a} + {1`b0, b}
  assign #1 overflow = extended_addition[8];
  assign #1 zero = (y == 32`b0) ? 1 : 0;
endmodule;

module register (input clk, [31:0]d, output reg [31:0]rd);
  always @ (posedge clk) rd <= d;
endmodule;

module enregister (input clk, en, [31:0]d, output reg [31:0]rd);
  always @ (posedge clk) if (en) rd <= d;
endmodule;

module registerfile (input clk, we, [4:0]a1, [4:0]a2, [4:0]a3, [31:0]wd, output reg [31:0]rd1, reg [31:0]rd2);
  reg [31:0] registers [31:0];

  always @ (posedge clk) begin
    rd1 <= registers[a1];
    rd2 <= registers[a2];
    if (we) registers[a3] <= wd;
  end
endmodule;

module signextend (input [15:0]offset, output [31:0]extended);
  assign wire extension = extended[15] ? 2`b1111111111111111 : 2`b0000000000000000;
  assign #1 extended = {extension, offset};
endmodule;

module mux2 (input a, b, s, output y);
  assign #1 y = s ? a : b;
endmodule;

module mux4 (input a, b, c, d [1:0]s, output y);
  assign #1 y = s[0] ? (s[1] ? (d : c)) : (s[1] ? (b : a));
endmodule;

module shiftleft2(input [15:0]a, output [15:0]y);
  assign #1 y = a << 2;
endmodule;

module clock (output reg clk);
  initial clk = 0;
  always #10 clk = ~clk;
endmodule;

module controlunit (
  input clk, [5:0]opcode, [5:0]funct,
  output IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUSrcA, [1:0]ALUSrcB, [2:0]ALUControl, PCSrc, Branch, PCWrite
);
  //TO BE DONE
endmodule;


module multi();
  wire clk;
  clock mainclock (clk);

  wire IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUSrcA, [1:0]ALUSrcB, [2:0]ALUControl, PCSrc, Branch, PCWrite;
  controlunit unit (clk, opcode, *, IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUSrcA, ALUSrcB, ALUControl, PCSrc, Branch, PCWrite);

  wire [31:0]memaddr;
  wire [31:0]memwd;
  wire [31:0]memrd;
  memory mem (clk, MemWrite, memaddr, memwd, memrd);

  wire [4:0]rega1, [4:0]rega2, [4:0]rega3, [31:0]regwd, [31:0]rd1, [31:0]rd2;
  registerfile file (clk, RegWrite, rega1, rega2, rega3, regwd, rd1, rd2);

  wire a, b;
  register rd1reg (clk, rd1, a);
  register rd2reg (clk, rd2, b);
  assign memwd = b;

  wire [31:0]pcnew, [31:0]pc, PCEn;
  enregister programcounter (clk, PCEn, pcnew, pc);

  wire [31:0] instr;
  enregister intruction (clk, IRWrite, memrd, instr);

  wire data;
  register datareg (clk, memrd, data);

  wire [15:0]offset, [31:0]extended;
  signextend extend (offset, extended);

  wire [31:0]timed4;
  shiftleft2 times4 (extended, timed4);

  wire [31:0]srcA, [31:0]srcB, [31:0]aluresult, overflow, zero;
  alu mainalu (srcA, srcB, ALUControl, aluresult, overflow, zero);

  wire [31:0]aluout;
  register alureg (clk, aluresult, aluout);

  assign #1 PCEn = (zero & Branch) | PCWrite;

  mux2 muxmemaddr (pc, aluout, IorD, memaddr);

  mux2 muxregwd (aluout, data, MemtoReg, regwd);

  mux2 muxsrcA (pc, a, srcA);
  mux4 muxsrcB (b, 31`b100, extended, timed4, ALUSrcB, srcB);

  mux2 muxpc (aluresult, aluout, PCSrc, pcnew);

  mux2 muxrega3 (instr[20:16], instr[15:11], RegDst, rega3);

  assign wire opcode = instr[31:26];
  assign wire funct = instr[5:0];
  assign rega1 = instr[25:21];
  assign rega2 = instr[20:16];
  assign offset = instr[15:0];

  initial
  begin
    forever
    begin
      clk = 0;
      #10 clk = ~clk;
    end
    a = 0; b = 0; cin = 0;

    #10;

    if (y === 0 && cout === 0) $display("000 success");
    else $display("000 fail");
  end
endmodule;