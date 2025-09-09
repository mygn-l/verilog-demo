# How to run

Install Icarus Verilog from Homebrew.
`cd` into the downloaded folder, then `cd mips`, then run:
`iverilog -o testbench multi.v alu.v clock.v controlunit.v enregister.v memory.v register.v registerfile.v shiftleft2.v shiftleft2preserve.v signextend.v`

Then run `vvp testbench`.

It will start outputting memory at each clock edge, then crash.
