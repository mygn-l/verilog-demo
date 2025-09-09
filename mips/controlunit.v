module control_unit (
  input clk,
  input [5:0] opcode, funct,
  output reg IorD, MemWrite, IRWrite, MemtoReg, RegWrite, ALUSrcA, Branch, PCWrite,
  output reg [1:0] ALUSrcB, RegDst, PCSrc,
  output reg [3:0] ALUControl
);
  localparam logic [5:0]
    OPCODE_REGISTER = 6'b000000,
    OPCODE_LW       = 6'b100011,
    OPCODE_SW       = 6'b101011,
    OPCODE_BEQ      = 6'b000100,
    OPCODE_ADDI     = 6'b001000,
    OPCODE_J        = 6'b000010,
    OPCODE_JAL      = 6'b000011;

  localparam logic [5:0]
    FUNCT_ADD   = 6'b100000,
    FUNCT_SUB   = 6'b100010;

  localparam logic [3:0]
    ALU_ADD  = 4'b0010,
    ALU_SUB  = 4'b0110,
    ALU_ZERO = 4'b1111;

  localparam logic [3:0]
    STATE_FETCH        = 4'b0000,
    STATE_DECODE       = 4'b0001,
    STATE_MEM_ADDR     = 4'b0010,
    STATE_MEM_READ     = 4'b0011,
    STATE_MEM_WRITE    = 4'b0100,
    STATE_WRITE_BACK   = 4'b0101,
    STATE_EXECUTE      = 4'b0110,
    STATE_RTYPE_WRITE  = 4'b0111,
    STATE_BRANCH       = 4'b1000,
    STATE_JUMP         = 4'b1001,
    STATE_JAL          = 4'b1010,
    STATE_ADDI_EXECUTE = 4'b1011,
    STATE_ADDI_WRITE   = 4'b1100;

  reg [3:0] state;
  initial state = STATE_FETCH;

  always @(posedge clk) begin
    case (state)
      STATE_FETCH: state <= STATE_DECODE;
      STATE_DECODE: begin
        case (opcode)
          OPCODE_LW, OPCODE_SW: state <= STATE_MEM_ADDR;
          OPCODE_BEQ: state <= STATE_BRANCH;
          OPCODE_ADDI: state <= STATE_ADDI_EXECUTE;
          OPCODE_J: state <= STATE_JUMP;
          OPCODE_JAL: state <= STATE_JAL;
          OPCODE_REGISTER: state <= STATE_EXECUTE;
        endcase
      end
      STATE_MEM_ADDR: begin
        case (opcode)
          OPCODE_LW: state <= STATE_MEM_READ;
          OPCODE_SW: state <= STATE_MEM_WRITE;
        endcase
      end
      STATE_MEM_READ: begin
        state <= STATE_WRITE_BACK;
      end
      STATE_WRITE_BACK: begin
        state <= STATE_FETCH;
      end
      STATE_MEM_WRITE: begin
        state <= STATE_FETCH;
      end
      STATE_EXECUTE: begin
        state <= STATE_RTYPE_WRITE;
      end
      STATE_BRANCH: begin
        state <= STATE_FETCH;
      end
      STATE_JUMP: begin
        state <= STATE_FETCH;
      end
      STATE_JAL: begin
        state <= STATE_FETCH;
      end
      STATE_RTYPE_WRITE: begin
        state <= STATE_FETCH;
      end
      STATE_ADDI_EXECUTE: begin
        state <= STATE_ADDI_WRITE;
      end
      STATE_ADDI_WRITE: begin
        state <= STATE_FETCH;
      end
    endcase
  end

  assign #1 PCWrite    = (state == STATE_FETCH) ? 1 : 0;
  assign #1 PCSrc      = (state == STATE_BRANCH) ? 2'b01 : ((state == STATE_JUMP || state == STATE_JAL) ? 2'b10 : 2'b00);
  assign #1 ALUSrcA    = (state == STATE_MEM_ADDR || state == STATE_EXECUTE || state == STATE_BRANCH) ? 1 : 0;
  assign #1 ALUSrcB    = (state == STATE_FETCH) ? 2'b01 : ((state == STATE_MEM_ADDR || state == STATE_ADDI_EXECUTE) ? 2'b10 : 2'b00);
  assign #1 ALUControl = (state == STATE_FETCH || state == STATE_MEM_ADDR) ? ALU_ADD : ((state == STATE_BRANCH) ? ALU_SUB : ALU_ZERO);
  assign #1 IRWrite    = (state == STATE_FETCH) ? 1 : 0;
  assign #1 IorD       = (state == STATE_MEM_READ || state == STATE_MEM_WRITE) ? 1 : 0;
  assign #1 MemWrite   = (state == STATE_MEM_WRITE) ? 1 : 0;
  assign #1 RegWrite   = (state == STATE_WRITE_BACK || state == STATE_RTYPE_WRITE || state == STATE_ADDI_WRITE || state == STATE_JAL) ? 1 : 0;
  assign #1 Branch     = (state == STATE_BRANCH) ? 1 : 0;
  assign #1 MemtoReg   = (state == STATE_WRITE_BACK || state == STATE_ADDI_WRITE) ? 1 : 0;
  assign #1 RegDst     = (state == STATE_RTYPE_WRITE || state == STATE_ADDI_WRITE) ? 2'b01 : ((state == STATE_JAL) ? 2'b10 : 2'b00);
endmodule
