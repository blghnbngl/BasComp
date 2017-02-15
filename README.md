# bascompsemibehavioral
Basic Computer Semi Behavioral Description

-This is mostly complete. It compiles and produces an actual bit file, but I did not have the chance to try. 

-All modules other than three are written in dataflow method. This was both the most challenging and most interesting part of this project. 

-The other three, which were written in behavioral method are control, memory and board. I did not have the time to change the control and board modules to dataflow. Memory is left in behavioral form for two reasons: 
1) Because this basic computer design has a large memory (4096x2 bytes) for Basys 2 Spartan-3E FPGA, it did not fit into the Distributed RAM so I had to use Block RAM. The method that is most compatible with Block RAM configuration is behavioral method.
2) Memory was designed to be written in behavioral form from the beginning anyway.

-Probably most problematic part is input output transfer. Syntaxwise, they seem fine but I am not sure thay are working the way they should. I had to write them to have a complete basic computer description. So that I could check whether this basic computer compiles to see if the whole of basic computer structure is fine or there aren't any blatant mistakes.

-Some other parts may cause less serious problems, it is difficult to guess before trying. But the main structure is solid I guess. Note that UCF file is not complete, so to test this by applying some inputs and checking the outputs, first the UCF file should be completed.

-A chart of this Basic Computer can make it easier for you to understand how the above modules are put together. Please note that flip flops are defined in the ff module (which is done by dataflow modelling). flipflop_dataflow module is not used now, but I left it among other modules as some sort of legacy from my earlier work. But both modules are the same actually.

-board                                                                                                 
  | 
  |--main
      |
      |----io_interface 
      |         |
      |         |--keyboard_input
      |         |--vga_output
      |         
      |----memory         
      |
      |----input_register
      |         |
      |         |----ff (d flip-flop)
      |               |----d_latch
      |               |----sr_latch
      |
      |----eightbit_register (output register)
      |         |
      |         |----ff
      |               |----d_latch
      |               |----sr_latch
      |
      |----smallregister (12-bit register)
      |         |
      |         |----ff
      |               |----d_latch
      |               |----sr_latch
      |
      |----register (16-bit register)
      |         |
      |         |----ff
      |               |----d_latch
      |               |----sr_latch
      |
      |----alu_unit
      |       |
      |       |----sixteenbitadder
      |                   |
      |                   |----fulladder      
      |
      |----sequencecounter
      |         |
      |         |----t_ff (t flip-flop)
      |
      |----buschooser
      |
      |----ff (for the flag flip flops under the main)
      |     |----d_latch
      |     |----sr_latch
      |
      |----threebitdecoder
      |
      |----fourbitdecoder
      |
      |----control
 
