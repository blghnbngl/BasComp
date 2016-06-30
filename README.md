# bascompbehavioral
Basic Computer Behavioral Description

-This description is written in behavioral modelling mode. It consists of a single module. One reason is that I did not see an immediate need to create helper module, another is it is really confusing to use modules in behavioral modelling.

-I thought about expanding the data width from 16 to 32, but decided not to do that because that would create complications about places of adress, op codes, etc. in a memory cell. But if we want, doing this change would take little time. 

-For all instructions, I directly followed Uluc Hoca's lecture notes.

-IMPORTANT: There are two differences between this code and the Basic Computer we saw in the class:

1)I divided the memory into two parts. One is instructions memory, which should hold the programs written by the user. The other is data memory, which would be the place the programs hold the necessary data values. This division may not be necessary, and if wanted it may be eliminated. Actually, I sepearated these two but then followed our lecture notes. InstrcutionsMemory acted like the only memory and I never used the DataMemory in the code even though I defined it.

2)I created a display register that would be connected to the screen of FPGA. This register is exclusively used for shoving values in the screen. Accumulator could be used for this function too, but there may be cases that you do not want to show what's in the accumulator directly, but rather you want to have an intermaediate buffer between.

-IMPORTANT: Even though many things are done, code needs 3 things to be totally complete:

1) I did not write parts related to START and INTERRUPT signals. These should be completed.

2) We should write the code for connecting our input-output signals to the FPGA's physical components.

3) Finally, we should write a testbench to check whether this behavioral model is correct.
