# MIPS has 32 registers, some are listed here
$0 #register containing the constant zero
$s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7 #registers containing variables
$t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7 #registers containing temporary variables
#there are other registers



#memory
#offset must be multiple of 4
#read:
lw $s0, 0($0)
lw $s0, 4($0)
#write:
sw $s0, 0($0)
sw $s0, 12($0)



#using temporary variables
add $t0, $s0, $s1
sub $s3, $t0, $s2

#immediate
addi $s0, $s0, 3



#logic
and $s0, $s1, $s2
or $s0, $s1, $s2
xor $s0, $s1, $s2
nor $s0, $s1, $s2

#immediate logic
andi $s0, $s0, 0x0000
ori $s0, $s0, 0x0000
xori $s0, $s0, 0x00000000 #if it's 32 bit



#bit shift
sll $s0, $s0, 4
srl $s0, $s0, 4
sra $s0, $s0, 4

#variable bit shift
sllv $s0, $s0, $s1
srlv $s0, $s0, $s1
srav $s0, $s0, $s1



#load 32 bit
lui $s0, 0x0000 #load upper half
ori $s0, $s0, 0x0000 #lower half using OR
#all registers are 32 bit, but you can only load 16 bits at a time



#mult and div
mult $s0, $s1
hi #32 high bits
lo #32 low bits
div $s0, $s1
hi #remainder
lo #quotient



#jump to target if equal
beq $s0, $s1, target
#jump to target if not equal
bne $s0, $s1, target

target:
  add $t0, $t1, $t2
  #etc



#jump unconditional
j target

#jump to register
jr $s0 #the address of the register is held inside s0, itself a register



#simulating arrays
#load base address
lui $s0, 0x0000
ori $s0, $s0, 0x0000
lw $t0, 0($s0) #first element
lw $t1, 4($s0) #second element



#simulating functions
$a0, $a1, $a2, $a3 #function arguments
$v0, $v1 #function return values
$ra #address to resume after function finish, this is automatically set by the caller

#example:
addi $a0, $0, 5
jal addseven

addseven:
  add $v0, $a0, 7
  jr $ra



#stacks
#example to reverse the order of the s
addi $sp, $sp, -12 #sp is a pointer/address
sw $s0, 8($sp)
sw $s1, 4($sp)
sw $s2, 0($sp)

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
addi $sp, $sp, 12



#global variables
$gp #pointer to be offset



#FURTHER READING: IA-32
