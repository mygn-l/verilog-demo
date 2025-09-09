module multi();
  wire clk;
  clock mainclock (clk);

  wire [5:0] opcode, funct;
  wire iord, memwrite, irwrite, memtoreg, regwrite, alusrca, branch, pcwrite;
  wire [1:0] alusrcb, regdst, pcsrc;
  wire [3:0] alucontrol;
  controlunit maincontrolunit (clk, opcode, funct, iord, memwrite, irwrite, memtoreg, regwrite, alusrca, branch, pcwrite, alusrcb, regdst, pcsrc, alucontrol);

  wire pcen;
  wire [31:0] pccurrent, pcnext;
  assign #1 pcen = pcwrite | (branch & zero);
  enregister pc (clk, pcen, pcnext, pccurrent);

  wire mem_addr;
  wire [31:0] mem_rd;
  assign #1 mem_addr = (iord) ? aluout : pccurrent;
  memory mainmemory (clk, memwrite, mem_addr, b_reg_out, mem_rd);

  wire [31:0] instruction;
  enregister instr_reg (clk, irwrite, mem_rd, instruction);

  wire [31:0] data;
  register data_reg (clk, mem_rd, data);

  wire [4:0] reg_a1, reg_a2, reg_a3;
  wire [31:0] reg_wd;
  wire [15:0] offset;
  wire [25:0] jaddr;
  assign #1 opcode = instruction[31:26];
  assign #1 funct  = instruction[5:0];
  assign #1 reg_a1 = instruction[25:21];
  assign #1 reg_a2 = instruction[20:16];
  assign #1 reg_a3 = (regdst[1]) ? 5'b11111 : ((regdst[0]) ? instruction[15:11] : instruction[20:16]);
  assign #1 reg_wd = (memtoreg) ? data : aluout;
  assign #1 offset = instruction[15:0];
  assign #1 jaddr  = instruction[25:0];

  wire [31:0] reg_rd1, reg_rd2;
  registerfile mainregisterfile (clk, regwrite, reg_a1, reg_a2, reg_a3, reg_wd, reg_rd1, reg_rd2);

  wire [31:0] a_reg_out, b_reg_out;
  register a_reg (clk, reg_rd1, a_reg_out);
  register b_reg (clk, reg_rd2, b_reg_out);

  wire [31:0] signimm, signimmsh;
  signextend mainsignextend (offset, signimm);
  shiftleft2 mainshiftleft2 (signimm, signimmsh);
  wire [27:0] pcjump;
  shiftleft2preserve mainshiftleft2preserve (jaddr, pcjump);

  wire [31:0] srcA, srcB;
  wire [31:0] aluresult;
  wire overflow, zero;
  assign #1 srcA = (alusrca) ? a_reg_out : pccurrent;
  assign #1 srcB = (alusrcb == 2'b00) ? b_reg_out : ((alusrcb == 2'b01) ? 32'd4 : ((alusrcb == 2'b10) ? signimm : signimmsh));
  alu mainalu (srcA, srcB, alucontrol, aluresult, overflow, zero);

  wire [31:0] aluout;
  register alu_reg (clk, aluresult, aluout);

  // Close the loop
  assign #1 pcnext = (pcsrc == 2'b00) ? aluresult : ((pcsrc == 2'b01) ? aluout : {pccurrent[31:28], pcjump});
endmodule;