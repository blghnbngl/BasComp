# bascompbehavioral
Basic Computer Behavioral Description

-This one has two modules for now. One is a Decoder that I used to decode the op codes which consist of three bits. Other is the main module that starts the ASM process. Main module is called bascompbehavioralVERA. Here, VERA corresponds to version A, because I thought I would create a slightly different alternative version of this verilog code. But later I saw creating and alternative version would be unnecessary, but I didn't change the name.

-I thought about expanding the data width from 16 to 32, but decided not to do that because that would create complications about places of adress, op codes, etc. in a memory cell. But if we want, doing this change would take little time. 

-At times T0, T1 and T2 (which are determined by the sequence counter) I directly followed Uluc Hoca's lecture notes. I didn't write the later ASM steps and the interrupt cycle.

-For the Decoder module I used dataflow modelling. In the main module I used behavioral modelling.

-There are two differences between this code and the Basic Computer we saw in the class:

1)I divided the memory into two parts. One is instructions memory, which should hold the programs written by the user. The other is data memory, which would be the place the programs hold the necessary data values. This division may not be necessary, and if wanted it may be eliminated.

2)I created a display register that would be connected to the screen of FPGA. This register is exclusively used for shoving values in the screen. Accumulator could be used for this function to, but there may be cases that you do not want to show what's in the accumulator directly, but rather want to show something else.
