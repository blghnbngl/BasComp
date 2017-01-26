# bascompsemibehavioral
Basic Computer Semi Behavioral Description

-This is mostly complete. It compiles and produces an actual bit file, but I did not have the chance to try. Some errors may occur though.

-All modules other than two are written in dataflow method. This was both the most challenging and most interesting part of this project. 

-The other two, which were written in behavioral method are control and memory. I did not have the time to change the control module to dataflow. Memory is left in behavioral form for two reasons: 
1) Because this basic computer design has a large memory (4096x2 bytes) for Basys 2 Spartan-3E FPGA, it did not fit into the Distributed RAM so I had to use Block RAM. The method that is most compatible with Block RAM configuration is behavioral method.
2) Memory was designed to be written in behavioral form from the beginning anyway.

-Probably most problematic part is input output transfer. Syntaxwise, they seem fine but I am not sure thay are working the way they should. I had to write them to have a complete basic computer description. So that I could check whether this basic computer compiles to see if the whole of basic computer structure is fine or there aren't any blatant mistakes.

-Some other parts may cause less serious problems, it is difficult to guess before trying. But the main structure is solid I guess.


